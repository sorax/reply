# Reply

**Pipe the response of LiveViews and GenServers**

[![Tests](https://github.com/sorax/reply/actions/workflows/test.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/test.yml)
[![Code Quality](https://github.com/sorax/reply/actions/workflows/quality.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/quality.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/reply.svg)](https://hex.pm/packages/reply)
[![hexdocs.pm](https://img.shields.io/badge/docs-1.2.0-brightgreen.svg)](https://hexdocs.pm/reply/1.2.0/Reply.html)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/reply)](https://hex.pm/packages/reply)
[![License](https://img.shields.io/hexpm/l/reply.svg)](https://github.com/sorax/reply/blob/main/LICENSE.md)

Instead of wrapping your result in a tuple at the end of a callback

```elixir
def mount(_params, _session, socket) do
  socket =
    socket
    |> assign(:posts, Blog.list_posts())

  {:ok, socket}
end
```

just pipe it all the way down:

```elixir
def mount(_params, _session, socket) do
  socket
  |> assign(:posts, Blog.list_posts())
  |> ok()
end
```

## Installation

### With Igniter

If you use [Igniter](https://hexdocs.pm/igniter), run:

```sh
mix igniter.install reply
```

This adds `reply` to your dependencies and imports it in `html_helpers` of your web module.

### Manually

Add `reply` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:reply, "~> 1.2"}
  ]
end
```

and import it in your web module `lib/my_app_web.ex` inside `html_helpers`, so it is available in every LiveView and LiveComponent:

```diff
defp html_helpers do
  quote do
    # HTML escaping functionality
    import Phoenix.HTML

+   import Reply

    ...
```

In a GenServer, simply `import Reply` in the module.

## Usage

### Phoenix LiveView

Use `ok/1` in `mount` and `noreply/1` in `handle_*` callbacks:

```elixir
def mount(_params, _session, socket) do
  socket
  |> assign(:posts, Blog.list_posts())
  |> ok()
end

def handle_params(%{"id" => id}, _uri, socket) do
  socket
  |> assign(:post, Blog.get_post!(id))
  |> noreply()
end
```

Options for `mount` can be passed to `ok/2`:

```elixir
def mount(_params, _session, socket) do
  socket
  |> assign(:posts, Blog.list_posts())
  |> ok(temporary_assigns: [posts: []])
end
```

To reply to the client in `handle_event`, use `reply/2`:

```elixir
def handle_event("load", %{"id" => id}, socket) do
  post = Blog.get_post!(id)

  socket
  |> assign(:post, post)
  |> reply(%{title: post.title})
end
```

### GenServer

The same functions work with the state of a GenServer:

```elixir
defmodule Stack do
  use GenServer

  import Reply

  def init(elements) do
    elements
    |> ok()
  end

  def handle_call(:pop, _from, [head | tail]) do
    tail
    |> reply(head)
  end

  def handle_cast({:push, element}, state) do
    [element | state]
    |> noreply()
  end
end
```

GenServer actions (a timeout, `:hibernate` or `{:continue, term}`) are passed as the last argument:

```elixir
def init(args) do
  args
  |> ok({:continue, :load})
end

def handle_cast({:push, element}, state) do
  [element | state]
  |> noreply({:continue, :persist})
end

def handle_call(:pop, _from, [head | tail]) do
  tail
  |> reply(head, :hibernate)
end
```

and `stop/2` or `stop/3` stop the process:

```elixir
def handle_info(:shutdown, state) do
  state
  |> stop(:normal)
end

def handle_call(:shutdown, _from, state) do
  state
  |> stop(:normal, :ok)
end
```

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

## Phoenix Channels

`Phoenix.Channel` defines its own `reply/2`. If you import `Reply` in a channel, exclude it to avoid an ambiguous call:

```elixir
import Reply, except: [reply: 2]
```

## Documentation

Documentation can be found at [hexdocs.pm/reply](https://hexdocs.pm/reply).

## License

Reply is released under the [MIT License](LICENSE.md).
