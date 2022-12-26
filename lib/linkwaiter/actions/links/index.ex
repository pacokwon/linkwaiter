defmodule Linkwaiter.Actions.Links.Index do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Links

  def call(conn, _opts) do
    current_user = get_session(conn, :current_user)
    render(conn, Links.index(adjective1: "coolest", adjective2: "fastest", current_user: current_user))
  end
end
