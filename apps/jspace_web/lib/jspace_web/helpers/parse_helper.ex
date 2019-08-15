defmodule JspaceWeb.ParseHelper do
  def safe_parse_params(params, infos) when is_map(params) do
    try do
      result =
        infos
        |> normalize_infos()
        |> Enum.reduce(%{}, fn {target, type, opts}, acc ->
          required = opts[:required] || false
          name = opts[:name] || to_string(target)
          should_in = opts[:in] || nil
          max_length = opts[:max_length] || 256
          nullable = opts[:null] || false

          value =
            case params[name] do
              nil -> opts[:default]
              value -> value
            end

          case value do
            nil ->
              if required, do: throw(:api_required_params_not_provided)
              if nullable, do: acc |> Map.put(target, nil), else: acc

            not_nil_value ->
              if get_length(value) > max_length, do: throw(:invalid_arguments)

              case parse_param(not_nil_value, type) do
                {:ok, result} ->
                  if should_in do
                    in? =
                      case result do
                        result when is_list(result) -> result |> Enum.all?(&(&1 in should_in))
                        result -> result in should_in
                      end

                    if not in?, do: throw(:invalid_arguments)
                  end

                  Map.put(acc, target, result)

                _ ->
                  throw(:api_invalid_param_types)
              end
          end
        end)

      {:ok, result}
    catch
      error -> {:error, error}
    end
  end

  def safe_parse_params(_params, infos), do: safe_parse_params(%{}, infos)

  defp normalize_infos(infos) when is_list(infos) do
    infos
    |> Enum.map(fn
      {target, type} -> {target, type, []}
      {target, type, opts} -> {target, type, opts}
    end)
  end

  defp normalize_infos(_infos), do: []

  defp get_length(value) when is_binary(value), do: value |> String.length()
  defp get_length(value), do: value |> :erlang.term_to_binary() |> byte_size()

  defp parse_param(param, :string) when is_binary(param), do: {:ok, param}
  defp parse_param(param, :boolean) when is_boolean(param), do: {:ok, param}
  defp parse_param(param, :integer) when is_integer(param), do: {:ok, param}
  defp parse_param(param, :map) when is_map(param), do: {:ok, param}
  defp parse_param(param, :list) when is_list(param), do: {:ok, param}
  defp parse_param(param, :decimal) when is_binary(param), do: Decimal.parse(param)
  defp parse_param(param, :decimal) when is_float(param), do: {:ok, Decimal.from_float(param)}
  defp parse_param(param, :decimal), do: {:ok, Decimal.new(param)}
  # defp parse_param(param, :datetime) when is_integer(param), do: DateTimeHelper.from_unix(param)
  defp parse_param(_, _), do: :error
end
