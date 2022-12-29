defmodule Linkwaiter.Actions.Sessions.Index do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Sessions

  def call(conn, _opts) do
    error = Map.get(conn.query_params, "error")
    render(conn, Sessions.index(error: error))
  end
end
