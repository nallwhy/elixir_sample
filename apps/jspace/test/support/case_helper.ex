defmodule Jspace.CaseHelper do
  import ExUnit.Assertions, only: [assert: 1, flunk: 1]
  import Jspace.CommonHelper, only: [defbang: 2]

  defmacro __using__(_opts) do
    quote do
      import Jspace.CaseHelper

      alias unquote(get_test_target_module(__CALLER__.module))
      alias Jspace.Fixture
    end
  end

  def assert_changeset_error(key, message \\ "", function) when is_function(function) do
    assert {:error, %Ecto.Changeset{} = changeset} = function.()

    case Jspace.EctoHelper.has_error?(changeset, key, message) do
      true ->
        nil

      _ ->
        message_str =
          case message do
            "" -> nil
            _ -> ", \"#{message}\""
          end

        flunk(
          "changeset doesn't have :#{key}#{message_str} error.\n#{
            inspect(changeset, pretty: true)
          }"
        )
    end
  end

  def reload(data) do
    clauses =
      data.__struct__.__schema__(:primary_key)
      |> Enum.map(fn primary_key ->
        {primary_key, Map.get(data, primary_key)}
      end)

    Jspace.Repo.get_by(data.__struct__, clauses)
  end

  defbang(:reload, 1)

  @spec same_record?(atom | %{__struct__: any}, atom | %{__struct__: any}) :: boolean
  def same_record?(a, b) do
    with true <- a.__struct__ == b.__struct__,
         primary_keys <- a.__struct__.__schema__(:primary_key),
         true <- same_fields?(a, b, primary_keys) do
      true
    else
      _ -> false
    end
  end

  def same_fields?(a, b, keys) when is_list(keys) do
    Enum.all?(keys, &same_values?(Map.get(a, &1), Map.get(b, &1)))
  end

  def same_values?(%DateTime{} = a, %DateTime{} = b), do: DateTime.compare(a, b) == :eq
  def same_values?(%Decimal{} = a, %Decimal{} = b), do: Decimal.equal?(a, b)
  def same_values?(%Decimal{} = a, b) when is_integer(b), do: Decimal.equal?(a, b)

  def same_values?(%Decimal{} = a, b) when is_float(b),
    do: Decimal.equal?(a, Decimal.from_float(b))

  def same_values?(%Decimal{} = a, b) when is_binary(b), do: Decimal.equal?(a, Decimal.new(b))
  def same_values?(a, %Decimal{} = b), do: same_values?(b, a)
  def same_values?(a, b), do: a == b

  def has_timestamps?(data) do
    data.inserted_at != nil and data.updated_at != nil
  end

  defp get_test_target_module(module) do
    splits = module |> Module.split()
    new_last = splits |> List.last() |> String.trim_trailing("Test")

    ((splits |> Enum.slice(0..-2)) ++ [new_last])
    |> Module.concat()
  end
end
