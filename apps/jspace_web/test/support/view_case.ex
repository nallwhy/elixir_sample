defmodule JspaceWeb.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Jspace.CaseHelper

      import Phoenix.View
      import Jspace.Factory

      def to_unix(datetime) do
        DateTime.to_unix(datetime, :millisecond)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Jspace.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Jspace.Repo, {:shared, self()})
    end

    :ok
  end
end
