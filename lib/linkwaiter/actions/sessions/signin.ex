defmodule Linkwaiter.Actions.Sessions.Signin do
  use Linkwaiter.Action

  def call(conn, _opts) do
    %{"username" => username, "password" => password} = conn.params

    admin_username = Application.fetch_env!(:linkwaiter, :admin_username)
    admin_password = Application.fetch_env!(:linkwaiter, :admin_password)

    case {username, password} do
      {^admin_username, ^admin_password} ->
        conn
        |> put_session(:current_user, username)
        |> redirect(to: "/")
      _ ->
        conn
        |> redirect(to: "/signin?error")
    end
  end
end
