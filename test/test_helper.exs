ExUnit.start()

defmodule TestHelper.Stack do
  use GenServer

  import Reply

  @impl true
  def init(list) do
    list
    |> String.split(",", trim: true)
    |> reply(:ok)
  end

  @impl true
  def handle_call(:pop, _from, []), do: [] |> reply(:reply, nil)

  def handle_call(:pop, _from, [item | state]) do
    state
    |> reply(:reply, item)
  end

  @impl true
  def handle_cast({:push, element}, state) do
    [element | state]
    |> reply(:noreply)
  end
end
