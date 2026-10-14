defmodule Reply do
  @moduledoc """
  Pipe the response of Phoenix LiveView and GenServer callbacks instead of building tuples by hand.

      def mount(_params, _session, socket) do
        socket
        |> assign(:posts, Blog.list_posts())
        |> ok()
      end

  See the [README](README.md) for installation.

  ## Overview

  | Function                              | Returns                                  | LiveView | GenServer |
  | ------------------------------------- | ---------------------------------------- | :------: | :-------: |
  | `ok(socket_or_state)`                 | `{:ok, socket_or_state}`                 |    ✓     |     ✓     |
  | `ok(socket_or_state, opts_or_action)` | `{:ok, socket_or_state, opts_or_action}` |    ✓     |     ✓     |
  | `noreply(socket_or_state)`            | `{:noreply, socket_or_state}`            |    ✓     |     ✓     |
  | `noreply(state, action)`              | `{:noreply, state, action}`              |          |     ✓     |
  | `reply(socket_or_state, payload)`     | `{:reply, payload, socket_or_state}`     |    ✓     |     ✓     |
  | `reply(state, payload, action)`       | `{:reply, payload, state, action}`       |          |     ✓     |
  | `stop(state, reason)`                 | `{:stop, reason, state}`                 |          |     ✓     |
  | `stop(state, reason, payload)`        | `{:stop, reason, payload, state}`        |          |     ✓     |

  An action is a timeout, `:hibernate` or `{:continue, term}`.

  In a `Phoenix.Channel`, use `import Reply, except: [reply: 2]` to avoid a conflict with `Phoenix.Channel.reply/2`.
  """

  @doc """
  Returns `{:ok, socket_or_state}`.

      iex> %{count: 0} |> ok()
      {:ok, %{count: 0}}

  """
  def ok(socket_or_state), do: {:ok, socket_or_state}

  @doc """
  Returns `{:ok, socket_or_state, opts_or_action}`.

  Mount options in a LiveView, an action in a GenServer.

      iex> %{count: 0} |> ok({:continue, :load})
      {:ok, %{count: 0}, {:continue, :load}}

  """
  def ok(socket_or_state, opts_or_action), do: {:ok, socket_or_state, opts_or_action}

  @doc """
  Returns `{:noreply, socket_or_state}`.

      iex> %{count: 0} |> noreply()
      {:noreply, %{count: 0}}

  """
  def noreply(socket_or_state), do: {:noreply, socket_or_state}

  @doc """
  Returns `{:noreply, state, action}`.

      iex> %{count: 0} |> noreply(:hibernate)
      {:noreply, %{count: 0}, :hibernate}

  """
  def noreply(state, action), do: {:noreply, state, action}

  @doc """
  Returns `{:reply, payload, socket_or_state}`.

      iex> %{count: 1} |> reply(:ok)
      {:reply, :ok, %{count: 1}}

  """
  def reply(socket_or_state, payload), do: {:reply, payload, socket_or_state}

  @doc """
  Returns `{:reply, payload, state, action}`.

      iex> %{count: 1} |> reply(:ok, {:continue, :persist})
      {:reply, :ok, %{count: 1}, {:continue, :persist}}

  """
  def reply(state, payload, action), do: {:reply, payload, state, action}

  @doc """
  Returns `{:stop, reason, state}`.

      iex> %{count: 1} |> stop(:normal)
      {:stop, :normal, %{count: 1}}

  """
  def stop(state, reason), do: {:stop, reason, state}

  @doc """
  Returns `{:stop, reason, payload, state}`.

      iex> %{count: 1} |> stop(:normal, :ok)
      {:stop, :normal, :ok, %{count: 1}}

  """
  def stop(state, reason, payload), do: {:stop, reason, payload, state}
end
