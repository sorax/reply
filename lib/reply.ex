defmodule Reply do
  @moduledoc """
  `Reply` lets you pipe the reply in a Phoenix LiveView.
  Just write `socket |> assigns |> reply` in `mount` and `handle_*` functions insted of dealing with tuples.
  """

  @doc """
  Transforms a piped reply into a response tuple.

  ## Examples

      def mount(_params, _session, socket) do
        socket
        |> assign(:posts, Blog.list_posts())
        |> assign(:post, nil)
        |> reply(:ok)
      end

  """
  def reply(socket, term), do: {term, socket}

  @doc """
  Transforms a piped reply with data into a response tuple.
  Works with maps and keyword lists.

  ## Examples

      def handle_event("update", params, socket) do
        {:ok, post} = Blog.get_post!(id)

        socket
        |> assign(:post, Blog.get_post!(id))
        |> reply(:reply, %{last_update: post.updated_at}})
      end

  """
  def reply(socket, :ok, keyword) when is_list(keyword), do: {:ok, socket, keyword}
  def reply(socket, term, payload), do: {term, payload, socket}
end
