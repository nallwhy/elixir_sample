defmodule Jspace.EctoHelper do
  def has_error?(%Ecto.Changeset{} = changeset, key, message \\ "") do
    changeset
    |> errors_on()
    |> Map.get(key, [])
    |> Enum.any?(&(&1 =~ message))
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
