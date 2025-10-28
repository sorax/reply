defmodule ReplyTest do
  use ExUnit.Case
  doctest Reply

  import Reply

  alias TestHelper.Stack

  test "genserver" do
    {:ok, pid} = GenServer.start_link(Stack, "hello,world,1,2,3")

    assert GenServer.call(pid, :pop) == "hello"
    assert GenServer.call(pid, :pop) == "world"
    assert GenServer.call(pid, :pop) == "1"
    assert GenServer.call(pid, :pop) == "2"
    assert GenServer.call(pid, :pop) == "3"
    assert GenServer.call(pid, :pop) == nil
    assert GenServer.cast(pid, {:push, "elixir"}) == :ok
    assert GenServer.call(pid, :pop) == "elixir"
  end

  defmodule DummySocket do
    defstruct id: nil

    @type t :: %__MODULE__{id: binary()}
  end

  setup_all do
    %{socket: %DummySocket{id: "phx-F9Nto__W8RqYDAKC"}}
  end

  test "ok/2 returns {:ok, socket} tuple", %{socket: socket} do
    assert socket |> ok() == {:ok, socket}
  end

  test "ok/3 returns {:ok, socket, keyword} tuple", %{socket: socket} do
    assert socket |> ok(layout: "foo") == {:ok, socket, [{:layout, "foo"}]}
  end

  test "noreply/2 returns {:noreply, socket} tuple", %{socket: socket} do
    assert socket |> noreply() == {:noreply, socket}
  end

  test "reply/3 returns {:reply, term, socket} tuple", %{socket: socket} do
    assert socket |> reply(%{data: "data"}) == {:reply, %{data: "data"}, socket}
    assert socket |> reply(foo: "bar") == {:reply, [foo: "bar"], socket}
    assert socket |> reply("baz") == {:reply, "baz", socket}
  end
end
