defmodule Botiful.AgentPlug do
  @moduledoc """
  Detect the user agent and identifies the type of user accessing
  our server.
  """
  import Plug.Conn

  @headless_chrome "HeadlessChrome"

  def init(options), do: options

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    with %{"user-agent" => ua} <- Enum.into(conn.req_headers, %{}),
         true <- ua =~ @headless_chrome do
      assign(conn, :type, :headless_chrome)
    else
      _ -> bot_or_user(conn)
    end
  end

  defp bot_or_user(conn) do
    if Browser.bot?(conn),
      do: assign(conn, :type, :bot),
      else: assign(conn, :type, :user)
  end
end
