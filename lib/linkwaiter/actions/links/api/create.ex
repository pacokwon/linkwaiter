defmodule Linkwaiter.Actions.Links.Api.Create do
  use Linkwaiter.Action

  def call(conn, _opts) do
    conn.params
    |> Map.take(["link", "category", "description"])
    |> Linkwaiter.LinkStore.add_link()

    conn
    |> redirect(to: "/links/create?success")
  end
end
