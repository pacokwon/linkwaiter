defmodule Linkwaiter.Action do
  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      import Linkwaiter.Action.Helpers

      def init(opts), do: opts
    end
  end

  defmodule Helpers do
    import Plug.Conn

    def render(conn, body) do
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, body)
    end

    def redirect(conn, to: url) do
      basepath = Application.fetch_env!(:linkwaiter, :basepath)

      conn
      |> put_resp_header("location", "/" <> basepath <> url)
      |> put_resp_content_type("text/html")
      |> send_resp(302, "You are being redirected to #{url}")
    end
  end
end
