# Reply for Phoenix LiveView

**Pipe the response of LiveView functions**

[![Tests](https://github.com/sorax/reply/actions/workflows/test.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/test.yml)
[![Code Quality](https://github.com/sorax/reply/actions/workflows/quality.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/quality.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/reply.svg)](https://hex.pm/packages/reply)
[![hexdocs.pm](https://img.shields.io/badge/docs-0.2.0-brightgreen.svg)](https://hexdocs.pm/reply/0.2.0/Reply.html)

## Installation

Simply add `reply` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:reply, "~> 0.2.0"}
  ]
end
```

and import it in your Web-Module `lib/my_app_web.ex` inside `html_helpers`

```diff
defp html_helpers do
  quote do
    # HTML escaping functionality
    import Phoenix.HTML

+   import Reply

    ...
```

Documentation can be found at https://hexdocs.pm/reply

## Usage

You can now use `reply/2` to pipe the response in `mount` and `handle_*` all the way down.

```elixir
def mount(_params, _session, socket) do
  socket
  |> assign(:posts, Blog.list_posts())
  |> assign(:post, nil)
  |> reply(:ok)
end

def handle_params(%{"id" => id}, _, socket) do
  socket
  |> assign(:post, Blog.get_post!(id))
  |> reply(:noreply)
end
```

and if you want to reply with data, it works as well using `reply/3`

```elixir
def handle_event("update", params, socket) do
  {:ok, post} = Blog.get_post!(id)

  socket
  |> assign(:post, Blog.get_post!(id))
  |> reply(:reply, %{last_update: post.updated_at}})
end
```
