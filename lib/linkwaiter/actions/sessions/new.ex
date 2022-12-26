defmodule Linkwaiter.Actions.Sessions.New do
  use Linkwaiter.Action
  alias Linkwaiter.Views.Sessions

  def call(conn, _opts) do
    render(conn, Sessions.new([]))
  end
end
