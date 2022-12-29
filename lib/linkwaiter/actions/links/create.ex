defmodule Linkwaiter.Actions.Links.Create do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Links

  def call(conn, _opts) do
    categories = Linkwaiter.LinkStore.categories
    success = Map.get(conn.query_params, "success")

    render(conn, Links.create([categories: categories, success: success]))
  end
end
