defmodule Linkwaiter.PageAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{method: method}, _opts) when method != "GET" do
    conn
  end

  def call(conn = %Plug.Conn{request_path: path}, opts) do
    is_target = opts[:paths] |> Enum.any?(&matches_path?(path, &1))
    if is_target do
      verify_request(conn)
    else
      conn
    end
  end

  defp matches_path?(path, pattern) when is_binary(pattern) do
    path == pattern
  end

  defp matches_path?(path, pattern = %Regex{}) do
    String.match?(path, pattern)
  end

  defp verify_request(conn) do
    current_user = get_session(conn, :current_user)
    if current_user == nil do
      conn
      |> put_resp_header("location", "/signin")
      |> put_resp_content_type("text/html")
      |> send_resp(302, "You are being redirected to /signin")
      |> halt()
    else
      conn
    end
  end
end
