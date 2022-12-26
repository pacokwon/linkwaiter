defmodule Linkwaiter.Actions.Sessions.Signin do
  use Linkwaiter.Action

  def call(conn, _opts) do
    %{"email" => email} = conn.params
    IO.inspect(email)

    conn
    |> put_session(:current_user, email)
    |> redirect(to: "/")
  end
end
