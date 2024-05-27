defmodule SocketReplyTest do
  use ExUnit.Case
  doctest SocketReply

  test "greets the world" do
    assert SocketReply.hello() == :world
  end
end
