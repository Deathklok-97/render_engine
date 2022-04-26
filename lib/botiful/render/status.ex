defmodule Botiful.Render.Status do
  use GenServer

  def start_link({agents, owner}) do
    GenServer.start_link(__MODULE__, {agents, owner})
  end

  @impl true
  def init({agents, owner}) do
    schedule_check()

    {:ok, %{
      requests: agents.requests,
      responses: agents.responses,
      owner: owner
    }}
  end

  @impl true
  def handle_info(:check, state) do
    requests_count = count_calls(state.requests)
    responses_count = count_calls(state.responses)

    invalid_responses = count_invalid_responses(state.responses)

    cond do
      requests_count == responses_count && invalid_responses == 0 ->
        Process.send(state.owner, :completed_and_valid, [:nosuspend])
        {:stop, :normal, state}

      requests_count == responses_count ->
        Process.send(state.owner, :completed, [:nosuspend])
        {:stop, :normal, state}

      true ->
        schedule_check()
        {:noreply, state}

    end
  end

  defp count_invalid_responses(responses) do
    Agent.get(responses, fn calls ->
      calls
      |> Enum.filter(fn status -> status >= 500 end)
      |> Enum.count()
    end)
  end

  defp count_calls(pid), do: Agent.get(pid, &Enum.count/1)

  defp schedule_check() do
    Process.send_after(self(), :check, 500)
  end

end
