defmodule Linkwaiter.Actions.Links.Index do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Links

  def call(conn, _opts) do
    current_user = get_session(conn, :current_user)
    state = Linkwaiter.LinkStore.get()
    case current_user do
      nil -> redirect(conn, to: "/signin")
      _ -> render(conn, Links.index(links: state))
    end
  end
end
