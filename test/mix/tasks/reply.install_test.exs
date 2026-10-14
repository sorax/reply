defmodule Mix.Tasks.Reply.InstallTest do
  use ExUnit.Case, async: true

  import Igniter.Test

  @web_module """
  defmodule TestWeb do
    def live_view do
      quote do
        use Phoenix.LiveView

        unquote(html_helpers())
      end
    end

    defp html_helpers do
      quote do
        # Translation
        use Gettext, backend: TestWeb.Gettext

        # HTML escaping functionality
        import Phoenix.HTML
        # Core UI components
        import TestWeb.CoreComponents

        # Common modules used in templates
        alias Phoenix.LiveView.JS
        alias TestWeb.Layouts

        # Routes generation with the ~p sigil
        unquote(verified_routes())
      end
    end
  end
  """

  test "imports Reply in html_helpers" do
    test_project(files: %{"lib/test_web.ex" => @web_module})
    |> Igniter.compose_task("reply.install", [])
    |> assert_has_patch("lib/test_web.ex", """
    + |      import Reply
    """)
  end

  test "imports Reply after import Phoenix.HTML" do
    test_project(files: %{"lib/test_web.ex" => @web_module})
    |> Igniter.compose_task("reply.install", [])
    |> assert_content("lib/test_web.ex", "import Phoenix.HTML\n      import Reply\n")
  end

  test "imports Reply after the last import without Phoenix.HTML" do
    test_project(
      files: %{
        "lib/test_web.ex" => """
        defmodule TestWeb do
          defp html_helpers do
            quote do
              import TestWeb.CoreComponents
              import TestWeb.Helpers

              alias Phoenix.LiveView.JS
            end
          end
        end
        """
      }
    )
    |> Igniter.compose_task("reply.install", [])
    |> assert_content("lib/test_web.ex", "import TestWeb.Helpers\n      import Reply\n")
  end

  test "is idempotent" do
    test_project(files: %{"lib/test_web.ex" => @web_module})
    |> Igniter.compose_task("reply.install", [])
    |> apply_igniter!()
    |> Igniter.compose_task("reply.install", [])
    |> assert_unchanged()
  end

  test "imports Reply when html_helpers has no imports" do
    test_project(
      files: %{
        "lib/test_web.ex" => """
        defmodule TestWeb do
          defp html_helpers do
            quote do
              alias Phoenix.LiveView.JS
            end
          end
        end
        """
      }
    )
    |> Igniter.compose_task("reply.install", [])
    |> assert_has_patch("lib/test_web.ex", """
    + |      import Reply
    """)
  end

  test "warns when html_helpers is missing" do
    test_project(files: %{"lib/test_web.ex" => "defmodule TestWeb do\nend\n"})
    |> Igniter.compose_task("reply.install", [])
    |> assert_has_warning(&(&1 =~ "Could not find `html_helpers`"))
  end

  test "adds a notice when there is no web module" do
    test_project()
    |> Igniter.compose_task("reply.install", [])
    |> assert_unchanged()
    |> assert_has_notice(&(&1 =~ "Could not find TestWeb"))
  end

  defp assert_content(igniter, path, expected) do
    content =
      igniter
      |> apply_igniter!()
      |> Map.fetch!(:rewrite)
      |> Rewrite.source!(path)
      |> Rewrite.Source.get(:content)

    assert content =~ expected
  end
end
