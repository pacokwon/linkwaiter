# https://hexdocs.pm/elixir/1.12/Supervisor.html
defmodule Linkwaiter.LinkStore do
  use Agent

  def start_link(opts) do
    path = Keyword.get(opts, :path)
    {:ok, contents} = File.read(path)
    links = Jason.decode!(contents)
    Agent.start_link(fn -> links end, name: __MODULE__)
  end

  def categories do
    Agent.get(__MODULE__, &Map.keys(&1))
  end

  def get_json do
    Agent.get(__MODULE__, &Jason.encode!(&1, pretty: true))
  end

  def add_link(new_link) do
    %{"link" => link, "description" => description, "category" => category} = new_link
    Agent.update(__MODULE__, fn state ->
      new_link = %{"link" => link, "description" => description, "date" => "#{Date.utc_today()}"}
      state |> Map.update(category, [new_link], &[new_link | &1])
    end)

    Task.Supervisor.start_child(Linkwaiter.TaskSupervisor, fn ->
      json = Linkwaiter.LinkStore.get_json()
      file_path = Application.fetch_env!(:linkwaiter, :links_json_path)
      blog_path = Application.fetch_env!(:linkwaiter, :blog_root)

      :ok = File.write!(file_path, json)

      :ok = File.cd!(blog_path)
      System.cmd("git", ["add", file_path])
      System.cmd("git", ["commit", "-m", "[#{Calendar.strftime(DateTime.utc_now(), "%Y-%m-%d %H:%M:%S")}] Automated commit from linkwaiter"])
      System.cmd("git", ["push"])
    end)
  end
end
