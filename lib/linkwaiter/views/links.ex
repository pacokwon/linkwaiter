defmodule Linkwaiter.Views.Links do
  use Linkwaiter.View

  deftemplate("links/index.html.heex", :index)
  deftemplate("links/create.html.heex", :create)
end
