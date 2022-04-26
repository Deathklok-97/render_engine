defmodule Botiful do
  @moduledoc """
  Documentation for Botiful.
  """

  use Plug.Router
  plug Plug.Logger
  plug Botiful.AgentPlug


  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, :ok, "world")
  end

  match(_, do: send_resp(conn, :not_found, "oh no"))
end
