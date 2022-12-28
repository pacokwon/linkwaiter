defmodule Linkwaiter.Actions.Sessions.New do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Sessions

  def call(conn, _opts) do
    error? = Map.get(conn.query_params, "error")
    render(conn, Sessions.new(error: error?))
  end
end
