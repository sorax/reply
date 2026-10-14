defmodule Mix.Tasks.Reply.Install.Docs do
  @moduledoc false

  def short_doc do
    "Installs Reply into your project"
  end

  def example do
    "mix igniter.install reply"
  end

  def long_doc do
    """
    #{short_doc()}

    Adds `import Reply` to `html_helpers` in your web module,
    so it is available in every LiveView and LiveComponent.

    ## Example

    ```sh
    #{example()}
    ```
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Reply.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    alias Igniter.Code.{Common, Function}
    alias Sourceror.Zipper

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :reply,
        example: __MODULE__.Docs.example()
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      web_module = Igniter.Libs.Phoenix.web_module(igniter)

      case Igniter.Project.Module.find_and_update_module(igniter, web_module, &import_reply/1) do
        {:ok, igniter} ->
          igniter

        {:error, igniter} ->
          Igniter.add_notice(igniter, """
          Reply: Could not find #{inspect(web_module)}.
          Add `import Reply` to the modules where you want to use it.
          """)
      end
    end

    defp import_reply(zipper) do
      with {:ok, zipper} <- Function.move_to_defp(zipper, :html_helpers, 0),
           {:ok, zipper} <- Function.move_to_function_call_in_current_scope(zipper, :quote, 1),
           {:ok, zipper} <- Common.move_to_do_block(zipper) do
        cond do
          match?({:ok, _}, move_to_import(zipper, Reply)) ->
            {:ok, zipper}

          match?({:ok, _}, move_to_import(zipper)) ->
            {:ok, zipper |> move_to_import_target() |> add_import_after()}

          true ->
            {:ok, Common.add_code(zipper, "import Reply", placement: :before)}
        end
      else
        :error ->
          {:warning,
           """
           Reply: Could not find `html_helpers` in your web module.
           Add `import Reply` to the modules where you want to use it.
           """}
      end
    end

    # After `import Phoenix.HTML` like in the README, otherwise after the last import
    defp move_to_import_target(zipper) do
      case move_to_import(zipper, Phoenix.HTML) do
        {:ok, zipper} -> zipper
        :error -> move_to_last_import(zipper)
      end
    end

    # Moves the blank line after the target import below `import Reply`
    defp add_import_after(%Zipper{node: {:import, meta, args}} = zipper) do
      newlines = get_in(meta, [:end_of_expression, :newlines]) || 1

      import_reply =
        {:import, [end_of_expression: [newlines: newlines]], [{:__aliases__, [], [:Reply]}]}

      zipper
      |> Zipper.replace({:import, put_in(meta, [:end_of_expression, :newlines], 1), args})
      |> Common.add_code(import_reply)
    end

    defp move_to_import(zipper, module \\ nil) do
      Function.move_to_function_call_in_current_scope(zipper, :import, [1, 2], fn zipper ->
        is_nil(module) || Function.argument_equals?(zipper, 0, module)
      end)
    end

    defp move_to_last_import(zipper) do
      {:ok, zipper} = move_to_import(zipper)

      with right when not is_nil(right) <- Zipper.right(zipper),
           {:ok, _} <- move_to_import(right) do
        move_to_last_import(right)
      else
        _ -> zipper
      end
    end
  end
else
  defmodule Mix.Tasks.Reply.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task 'reply.install' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
