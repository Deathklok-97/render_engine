defmodule Botiful.Render.Engine do
  use GenServer

  alias ChromeRemoteInterface.{
    RPC,
    PageSession
  }

  alias Botiful.Render.Status

  require Logger

  # Client

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def html(pid) do
    GenServer.call(pid, :html, 20_000)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  # Server Callbacks
  def init(url) do
    conn = ChroxyClient.page_session!(%{ host: "localhost", port: 1330})
    {:ok, requests} = Agent.start_link(fn -> [] end)
    {:ok, responses} = Agent.start_link(fn -> [] end)
    {:ok, status} = Status.start_link({
      %{requests: requests, responses: responses},
      self()
    })

    {:ok, _} = RPC.Page.enable(conn)
    {:ok, _} = RPC.Network.enable(conn)


    :ok = PageSession.subscribe(conn, "Network.requestWillBeSent", self())
    :ok = PageSession.subscribe(conn, "Network.responseReceived", self())

    {:ok, _} = RPC.Page.navigate(conn, %{url: url})

    {:ok, %{
      conn: conn,
      url: url,
      requests: requests,
      responses: responses,
      status: status,
      origin: "https://content.mwstatic.com",
      valid: false,
      completed: false
      }}
  end

  def handle_call(:html, _from, state) do
    cond do
      state.completed && state.valid ->
        {:ok, %{"result" => %{"result" => %{"value" => html}}}}=
          RPC.Runtime.evaluate(state.conn, %{
            expression: "document.documentElement.outerHTML"
          })

          {:reply, html, state}

      state.completed ->
        {:reply, "", state}

      true ->
        {:reply, :incomplete, state }
    end
  end

  def handle_info(:completed_and_valid, state) do
    {:noreply, Map.merge(state, %{ completed: true, valid: true})}
  end

  def handle_info(:completed, state) do
    {:noreply, Map.merge(state, %{ completed: true})}
  end

  def handle_info({:chrome_remote_interface, "Network.requestWillBeSent", data}, state) do

    url = data["params"]["request"]["url"]

    if url =~ state.origin do
      Agent.update(state.requests, fn state -> state ++ [url] end)
    end

    {:noreply, state}
  end

  def handle_info({:chrome_remote_interface, "Network.responseReceived", data}, state)  do
    %{"url" => url, "status" => status} = data["params"]["response"]

    if url =~ state.origin do
      Agent.update(state.responses, fn state -> state ++ [status] end)
    end

    {:noreply, state}
  end

  def terminate(:normal, state) do
    Logger.info("[Engine] Stopping Engine for #{state.url}")

    PageSession.unsubscribe_all(state.conn)
    PageSession.stop(state.conn)
  end

end
