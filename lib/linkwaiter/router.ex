defmodule Linkwaiter.Router do
  use Plug.Router
  import Plug.Conn
  alias Linkwaiter.ApiAuth
  alias Linkwaiter.PageAuth

  plug :basepath_plug
  plug Plug.Static, from: :linkwaiter, at: "/"
  plug :put_secret_key_base
  plug Plug.Session, store: :cookie, key: "__linkwaiter", signing_salt: "linkwaiter-salt"
  plug :fetch_session

  plug PageAuth, paths: ["/", "/links/create"]
  plug ApiAuth, paths: [post: "/logout", delete: ~r/\/links\/\w+/]

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :dispatch

  get "/", to: Linkwaiter.Actions.Links.Index
  get "/signin", to: Linkwaiter.Actions.Sessions.Index
  get "/links/create", to: Linkwaiter.Actions.Links.Create
  post "/links", to: Linkwaiter.Actions.Links.Api.Create
  post "/logout", to: Linkwaiter.Actions.Sessions.Api.Logout
  post "/signin", to: Linkwaiter.Actions.Sessions.Api.Signin
  delete "/links/:id", to: Linkwaiter.Actions.Links.Api.Delete

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  def put_secret_key_base(conn, _) do
    session_key = Application.fetch_env!(:linkwaiter, :session_key)
    put_in conn.secret_key_base, session_key
  end

  defp basepath_plug(conn, _) do
    %Plug.Conn{request_path: request_path} = conn
    basepath = Application.fetch_env!(:linkwaiter, :basepath)

    case Path.split(request_path) do
      ["/", ^basepath | new_path_info] ->
        new_path = if Enum.empty?(new_path_info) do "/" else Path.join(new_path_info) end
        %Plug.Conn{conn | request_path: new_path, path_info: new_path_info}
      _ ->
        conn
        |> send_resp(404, "Not Found")
        |> halt()
    end
  end
end
