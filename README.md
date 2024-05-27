# SocketReply for Phoenix LiveView

**Pipe the response of LiveView functions**

## Installation

Simply add `socket_reply` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:socket_reply, "~> 0.1.0"}
  ]
end
```

and import it in your Web-Module `lib/my_app_web.ex` inside `html_helpers`.

```elixir
defp html_helpers do
  quote do
    # HTML escaping functionality
    import Phoenix.HTML

    # SocketReply goes here
    import SocketReply

    ...
```

Documentation can be found at https://hexdocs.pm/socket_reply

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
