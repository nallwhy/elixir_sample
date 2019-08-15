defmodule Jspace.QueryHelper do
  import Ecto.Query

  alias Jspace.Repo

  defmacro defquery(:count) do
    quote do
      def count() do
        __MODULE__
        |> select(count())
        |> Repo.one()
      end
    end
  end

  defmacro defquery(:get_by) do
    quote do
      def get_by(params) do
        __MODULE__
        |> Repo.get_by(params)
      end
    end
  end

  defmacro defquery(:list) do
    quote do
      def list() do
        __MODULE__
        |> Repo.all()
      end
    end
  end

  defmacro defquery(:create) do
    quote do
      def create(attrs) do
        %__MODULE__{}
        |> changeset_create(attrs)
        |> Repo.insert()
      end
    end
  end

  defmacro defquery(:update) do
    quote do
      def update(%__MODULE__{} = model, attrs) do
        model
        |> changeset_update(attrs)
        |> Repo.update()
      end
    end
  end

  defmacro defquery(:delete) do
    quote do
      def delete(%__MODULE__{} = model) do
        model |> Repo.delete()
      end
    end
  end

  defmacro defsubquery(param_name, operator_atom, field \\ nil)

  defmacro defsubquery(param_name, :contained, field) do
    field = field || param_name

    quote do
      defp unquote(:"subquery_#{param_name}")(query, %{unquote(param_name) => param})
           when not is_nil(param),
           do:
             query
             |> where([q], ilike(q.unquote(field), ^"%#{param}%"))

      defp unquote(:"subquery_#{param_name}")(query, _params), do: query
    end
  end

  defmacro defsubquery(param_name, operator_atom, field) do
    operator =
      case operator_atom do
        :eq -> :==
        :gt -> :>
        :lt -> :<
        :ge -> :>=
        :le -> :<=
        :in -> :in
      end

    field = field || param_name

    quote do
      defp unquote(:"subquery_#{param_name}")(query, %{unquote(param_name) => param})
           when not is_nil(param),
           do: query |> where([q], unquote(operator)(q.unquote(field), ^param))

      defp unquote(:"subquery_#{param_name}")(query, _params), do: query
    end
  end

  defmacro defsubquery(param_name, :between, min_field, max_field) do
    quote do
      defp unquote(:"subquery_#{param_name}")(query, %{unquote(param_name) => param})
           when not is_nil(param),
           do:
             query
             |> where([q], q.unquote(min_field) <= ^param and ^param <= q.unquote(max_field))

      defp unquote(:"subquery_#{param_name}")(query, _params), do: query
    end
  end

  def limit_size(query, params, max_size \\ 30) do
    case params |> Map.get(:size) do
      nil -> query |> limit(^max_size)
      size when size > max_size -> query |> limit(^max_size)
      size -> query |> limit(^size)
    end
  end

  def page(query, params, per_page \\ 30) do
    case params |> Map.get(:page) do
      nil ->
        query

      page ->
        per_page = params |> Map.get(:per_page, per_page)
        offset = per_page * page
        query |> offset(^offset) |> limit(^per_page)
    end
  end

  def order_bys(query, params, default \\ []) do
    case params |> Map.get(:order_bys, default) do
      [] -> query
      order_bys -> query |> order_by(^order_bys)
    end
  end

  def preloads(query, params) do
    case params |> Map.get(:preloads, []) do
      [] -> query
      preloads -> query |> preload(^preloads)
    end
  end

  def query_results(%{columns: columns, rows: rows}, module \\ nil) do
    columns = columns |> Enum.map(&String.to_existing_atom/1)

    results =
      rows
      |> Enum.map(fn row ->
        Enum.zip(columns, row) |> Enum.into(%{})
      end)

    case module do
      module when is_atom(module) and not is_nil(module) ->
        results |> Enum.map(&struct(module, &1))

      _ ->
        results
    end
  end
end
