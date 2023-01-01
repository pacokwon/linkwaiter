defmodule Linkwaiter.ApiAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{request_path: path, method: req_method}, opts) do
    is_target = opts[:paths] |> Enum.any?(&matches_path?(path, req_method, &1))
    if is_target do
      verify_request(conn)
    else
      conn
    end
  end

  defp matches_path?(path, req_method, {method, pattern}) when is_binary(pattern) do
    method_atom = req_method |> String.downcase() |> String.to_existing_atom()
    method_atom == method and path == pattern
  end

  defp matches_path?(path, req_method, {method, pattern = %Regex{}}) do
    method_atom = req_method |> String.downcase() |> String.to_existing_atom()
    method_atom == method and String.match?(path, pattern)
  end

  defp verify_request(conn) do
    current_user = get_session(conn, :current_user)
    if current_user == nil do
      conn
      |> send_resp(401, "Unauthorized")
      |> halt()
    else
      conn
    end
  end
end
