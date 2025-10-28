ExUnit.start()

defmodule TestHelper.Stack do
  use GenServer

  import Reply

  @impl true
  def init(list) do
    list
    |> String.split(",", trim: true)
    |> ok()
  end

  @impl true
  def handle_call(:pop, _from, []), do: [] |> reply(nil)

  def handle_call(:pop, _from, [item | state]) do
    state
    |> reply(item)
  end

  @impl true
  def handle_cast({:push, element}, state) do
    [element | state]
    |> noreply()
  end
end
