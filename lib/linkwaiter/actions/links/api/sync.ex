defmodule Linkwaiter.Actions.Links.Api.Sync do
  use Linkwaiter.Action

  def call(conn, _opts) do
    Linkwaiter.LinkStore.reload_from_fs()
    send_resp(conn, 200, "ok")
  end
end
