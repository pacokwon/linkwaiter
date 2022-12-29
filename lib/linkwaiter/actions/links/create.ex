defmodule Linkwaiter.Actions.Links.Create do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Links

  def call(conn, _opts) do
    render(conn, Links.create([]))
  end
end
