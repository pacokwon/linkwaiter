defmodule Linkwaiter.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :put_secret_key_base
  plug Plug.Session, store: :cookie, key: "__linkwaiter", signing_salt: "linkwaiter-salt"
  plug :fetch_session
  plug :dispatch

  get "/", to: Linkwaiter.Actions.Links.Index
  get "/signin", to: Linkwaiter.Actions.Sessions.New
  post "/links", to: Linkwaiter.Actions.Links.Create
  post "/signin", to: Linkwaiter.Actions.Sessions.Signin

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  def put_secret_key_base(conn, _) do
    session_key = Application.fetch_env!(:linkwaiter, :session_key)
    put_in conn.secret_key_base, session_key
  end
end
