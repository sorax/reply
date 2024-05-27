defmodule SocketReply do
  @moduledoc """
  `SocketReply` lets you pipe the reply in a Phoenix LiveView.
  Just write `socket |> assigns |> reply` in `mount` and `handle_*` functions insted of dealing with tuples.
  """

  @doc """
  Transforms a piped reply into a response tuple.

  ## Examples

      socket
      |> assign(foo: "bar")
      |> reply(:noreply)

  """
  def reply(socket, term), do: {term, socket}

  @doc """
  Transforms a piped reply with data into a response tuple.
  Works with maps and keyword lists.

  ## Examples

      socket
      |> assign(foo: "bar")
      |> reply(:reply, %{key: "value"})

  """
  def reply(socket, :ok, keyword) when is_list(keyword), do: {:ok, socket, keyword}
  def reply(socket, term, payload), do: {term, payload, socket}
end
