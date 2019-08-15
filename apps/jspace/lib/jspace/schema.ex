defmodule Jspace.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import unquote(__MODULE__)
      import Ecto.{Query, Changeset}
      import Jspace.QueryHelper

      alias Jspace.Repo
      alias __MODULE__

      @timestamps_opts [type: :utc_datetime]
    end
  end
end
