ExUnit.start()

defmodule TestHelper.Stack do
  use GenServer

  import Reply

  def start_link(arg), do: GenServer.start_link(__MODULE__, arg)

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

defmodule TestHelper.Counter do
  use GenServer

  import Reply

  def start_link(arg), do: GenServer.start_link(__MODULE__, arg)

  @impl true
  def init(count) do
    count
    |> ok({:continue, :double})
  end

  @impl true
  def handle_continue(:double, count) do
    (count * 2)
    |> noreply()
  end

  @impl true
  def handle_call(:get, _from, count), do: count |> reply(count)

  def handle_call(:increment_and_double, _from, count) do
    (count + 1)
    |> reply(:ok, {:continue, :double})
  end

  def handle_call(:hibernate, _from, count) do
    count
    |> reply(:ok, :hibernate)
  end

  def handle_call(:stop, _from, count) do
    count
    |> stop(:normal, count)
  end

  @impl true
  def handle_cast(:increment_and_double, count) do
    (count + 1)
    |> noreply({:continue, :double})
  end

  def handle_cast({:increment_after, timeout}, count) do
    count
    |> noreply(timeout)
  end

  def handle_cast(:stop, count) do
    count
    |> stop(:normal)
  end

  @impl true
  def handle_info(:timeout, count) do
    (count + 1)
    |> noreply()
  end
end
