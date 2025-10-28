# Reply for Phoenix LiveView

**Pipe the response of LiveView functions**

[![Tests](https://github.com/sorax/reply/actions/workflows/test.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/test.yml)
[![Code Quality](https://github.com/sorax/reply/actions/workflows/quality.yml/badge.svg)](https://github.com/sorax/reply/actions/workflows/quality.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/reply.svg)](https://hex.pm/packages/reply)
[![hexdocs.pm](https://img.shields.io/badge/docs-1.1.0-brightgreen.svg)](https://hexdocs.pm/reply/1.1.0/Reply.html)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/reply)](https://hex.pm/packages/reply)
[![License](https://img.shields.io/hexpm/l/reply.svg)](https://github.com/sorax/reply/blob/min/LICENSE.md)

## Installation

Simply add `reply` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:reply, "~> 1.1"}
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

You can now use `ok/2`, `noreply/2` or `reply/3` to pipe the response in `mount` and `handle_*` all the way down.

```elixir
def mount(_params, _session, socket) do
  socket
  |> assign(:posts, Blog.list_posts())
  |> ok()
end

def handle_params(%{"id" => id}, _, socket) do
  socket
  |> assign(:post, Blog.get_post!(id))
  |> noreply()
end
```

and if you want to reply with data, it works as well using `reply/3`

```elixir
def handle_event("update", %{"id" => id}, socket) do
  {:ok, post} = Blog.get_post!(id)

  socket
  |> assign(:post, post)
  |> reply(%{last_update: post.updated_at})
end
```
