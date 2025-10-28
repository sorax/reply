defmodule Reply do
  @moduledoc """
  Lets you pipe the reply in a Phoenix LiveView.
  Just write `socket |> assigns |> ok()` in `mount` or `socket |> assigns |> noreply()` in `handle_*` functions insted of dealing with tuples.
  """

  @doc """
  Transforms a piped reply into a {:ok, socket} response tuple.

  ## Examples

      def mount(_params, _session, socket) do
        socket
        |> assign(:posts, Blog.list_posts())
        |> ok()
      end

  """
  def ok(socket), do: {:ok, socket}
  def ok(socket, keyword), do: {:ok, socket, keyword}

  @doc """
  Transforms a piped reply into a {:noreply, socket} response tuple.

  ## Examples

      def handle_event("update", %{"id" => id}, socket) do
        socket
        |> assign(:post, Blog.get_post!(id))
        |> noreply()
      end

  """
  def noreply(socket), do: {:noreply, socket}

  @doc """
  Transforms a piped reply with payload into a {:reply, payload, socket} response tuple.

  ## Examples

      def handle_event("update", %{"id" => id}, socket) do
        {:ok, post} = Blog.get_post!(id)

        socket
        |> assign(:post, post)
        |> reply(%{last_update: post.updated_at})
      end

  """
  def reply(socket, payload), do: {:reply, payload, socket}
end
