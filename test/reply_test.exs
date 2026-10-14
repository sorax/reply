defmodule ReplyTest do
  use ExUnit.Case
  doctest Reply, import: true

  import Reply

  alias TestHelper.{Counter, Stack}

  defmodule DummySocket do
    defstruct id: nil

    @type t :: %__MODULE__{id: binary()}
  end

  describe "LiveView" do
    setup do
      %{socket: %DummySocket{id: "phx-F9Nto__W8RqYDAKC"}}
    end

    test "ok/1 returns {:ok, socket} tuple", %{socket: socket} do
      assert socket |> ok() == {:ok, socket}
    end

    test "ok/2 returns {:ok, socket, opts} tuple", %{socket: socket} do
      assert socket |> ok(layout: "foo") == {:ok, socket, [layout: "foo"]}
    end

    test "noreply/1 returns {:noreply, socket} tuple", %{socket: socket} do
      assert socket |> noreply() == {:noreply, socket}
    end

    test "reply/2 returns {:reply, payload, socket} tuple", %{socket: socket} do
      assert socket |> reply(%{data: "data"}) == {:reply, %{data: "data"}, socket}
      assert socket |> reply(foo: "bar") == {:reply, [foo: "bar"], socket}
      assert socket |> reply("baz") == {:reply, "baz", socket}
    end
  end

  describe "GenServer" do
    test "ok/1, reply/2 and noreply/1" do
      pid = start_supervised!({Stack, "hello,world,1,2,3"})

      assert GenServer.call(pid, :pop) == "hello"
      assert GenServer.call(pid, :pop) == "world"
      assert GenServer.call(pid, :pop) == "1"
      assert GenServer.call(pid, :pop) == "2"
      assert GenServer.call(pid, :pop) == "3"
      assert GenServer.call(pid, :pop) == nil
      assert GenServer.cast(pid, {:push, "elixir"}) == :ok
      assert GenServer.call(pid, :pop) == "elixir"
    end

    test "ok/2 continues after init" do
      pid = start_supervised!({Counter, 1})

      assert GenServer.call(pid, :get) == 2
    end

    test "reply/3 continues after call" do
      pid = start_supervised!({Counter, 1})

      assert GenServer.call(pid, :increment_and_double) == :ok
      assert GenServer.call(pid, :get) == 6
    end

    test "reply/3 hibernates after call" do
      pid = start_supervised!({Counter, 1})

      assert GenServer.call(pid, :hibernate) == :ok
      assert GenServer.call(pid, :get) == 2
    end

    test "noreply/2 continues after cast" do
      pid = start_supervised!({Counter, 1})

      GenServer.cast(pid, :increment_and_double)
      assert GenServer.call(pid, :get) == 6
    end

    test "noreply/2 sets a timeout" do
      pid = start_supervised!({Counter, 1})

      GenServer.cast(pid, {:increment_after, 10})
      Process.sleep(50)
      assert GenServer.call(pid, :get) == 3
    end

    test "stop/2 stops the process" do
      {:ok, pid} = GenServer.start(Counter, 1)
      ref = Process.monitor(pid)

      GenServer.cast(pid, :stop)
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end

    test "stop/3 replies and stops the process" do
      {:ok, pid} = GenServer.start(Counter, 1)
      ref = Process.monitor(pid)

      assert GenServer.call(pid, :stop) == 2
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end
  end
end
