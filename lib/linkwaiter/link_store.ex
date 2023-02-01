# https://hexdocs.pm/elixir/1.12/Supervisor.html
defmodule Linkwaiter.LinkStore do
  use Agent
  require Logger

  def start_link(opts) do
    path = Keyword.get(opts, :path)
    {:ok, contents} = File.read(path)
    links = Jason.decode!(contents)
    Agent.start_link(fn -> links end, name: __MODULE__)
  end

  def categories do
    Agent.get(__MODULE__, &Map.keys(&1))
  end

  def get do
    Agent.get(__MODULE__, &Function.identity/1)
  end

  def get_json do
    Agent.get(__MODULE__, &Jason.encode!(&1, pretty: true))
  end

  def remove_link(uuid) do
    Agent.update(__MODULE__, fn state ->
      Enum.reduce(state, %{}, fn {category, entries}, acc ->
        {_, rest} = pop_in(entries, [Access.filter(&(&1["uuid"] == uuid))])

        case rest do
          [] -> acc
          _ -> Map.put(acc, category, rest)
        end
      end)
    end)

    sync_fs()
  end

  def add_link(new_link) do
    %{"link" => link, "description" => description, "category" => category, "alias" => alias} =
      new_link

    Agent.update(__MODULE__, fn state ->
      uuid = UUID.uuid4(:hex)

      new_link = %{
        "link" => link,
        "description" => description,
        "date" => "#{Date.utc_today()}",
        "uuid" => uuid,
        "alias" => alias,
      }

      state |> Map.update(category, [new_link], &[new_link | &1])
    end)

    sync_fs()
  end

  def reload_from_fs do
    Agent.update(__MODULE__, fn _ ->
      path = Application.fetch_env!(:linkwaiter, :links_json_path)
      {:ok, contents} = File.read(path)
      Jason.decode!(contents)
    end)
  end

  defp sync_fs do
    Task.Supervisor.start_child(Linkwaiter.TaskSupervisor, fn ->
      json = Linkwaiter.LinkStore.get_json()
      file_path = Application.fetch_env!(:linkwaiter, :links_json_path)
      blog_path = Application.fetch_env!(:linkwaiter, :blog_root)

      :ok = File.write!(file_path, json)

      :ok = File.cd!(blog_path)
      System.cmd("git", ["add", file_path])

      System.cmd("git", [
        "commit",
        "--no-verify",
        "-m",
        "[#{Calendar.strftime(DateTime.utc_now(), "%Y-%m-%d %H:%M:%S")}] Automated commit from linkwaiter"
      ])
    end)
  end
end
