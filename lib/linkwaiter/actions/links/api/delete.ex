defmodule Linkwaiter.Actions.Links.Api.Delete do
  use Linkwaiter.Action

  def call(conn, _opts) do
    %{"id" => id} = conn.path_params

    IO.inspect(id)
    Linkwaiter.LinkStore.remove_link(id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{ "success" => true }))
  end
end
