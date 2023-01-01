defmodule Linkwaiter.Actions.Sessions.Api.Logout do
  use Linkwaiter.Action

  def call(conn, _opts) do
    conn
    |> clear_session()
    |> redirect(to: "/signin")
  end
end
