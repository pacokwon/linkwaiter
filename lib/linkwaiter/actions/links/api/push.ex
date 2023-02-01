defmodule Linkwaiter.Actions.Links.Api.Push do
  use Linkwaiter.Action

  def call(conn, _opts) do
    Task.Supervisor.start_child(Linkwaiter.TaskSupervisor, fn ->
      blog_path = Application.fetch_env!(:linkwaiter, :blog_root)
      :ok = File.cd!(blog_path)
      System.cmd("git", ["push"])
    end)

    send_resp(conn, 200, "ok")
  end
end
