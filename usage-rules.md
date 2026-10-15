# Reply

Reply is imported in this project. End LiveView and GenServer callbacks by piping
into a Reply function instead of writing the return tuple by hand.

    # instead of {:noreply, socket |> assign(:post, post)}
    socket
    |> assign(:post, post)
    |> noreply()

This also applies to examples in other usage rules that return tuples.

## Functions

The socket or state is always the first argument, so the order differs from the tuple:

- `ok(socket_or_state)` → `{:ok, socket_or_state}`
- `ok(socket_or_state, opts_or_action)` → `{:ok, socket_or_state, opts_or_action}`
- `noreply(socket_or_state)` → `{:noreply, socket_or_state}`
- `noreply(state, action)` → `{:noreply, state, action}` (GenServer only)
- `reply(socket_or_state, payload)` → `{:reply, payload, socket_or_state}`
- `reply(state, payload, action)` → `{:reply, payload, state, action}` (GenServer only)
- `stop(state, reason)` → `{:stop, reason, state}` (GenServer only)
- `stop(state, reason, payload)` → `{:stop, reason, payload, state}` (GenServer only)

An action is a timeout, `:hibernate` or `{:continue, term}`.

## Notes

- In a GenServer, add `import Reply` to the module. In LiveViews it is already imported via `html_helpers`.
- In a `Phoenix.Channel`, use `import Reply, except: [reply: 2]` and keep `{:reply, ...}` tuples there.
- Don't mix styles within a module.
