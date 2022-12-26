defmodule Linkwaiter.Actions.Links.Create do
  use Linkwaiter.Action

  def call(conn, _opts) do
    # %{"post" => post} = conn.params

    redirect(conn, to: "/")
  end
end
