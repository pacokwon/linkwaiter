defmodule Linkwaiter.Actions.Links.Create do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Links

  def call(conn, _opts) do
    current_user = get_session(conn, :current_user)

    case current_user do
      nil -> redirect(conn, to: "/signin")
      _ ->
        categories = Linkwaiter.LinkStore.categories
        success = Map.get(conn.query_params, "success")

        render(conn, Links.create([categories: categories, success: success]))
    end
  end
end
