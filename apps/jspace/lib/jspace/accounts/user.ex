defmodule Jspace.Accounts.User do
  use Jspace.Schema
  alias Jspace.Crypto

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:name, :string)

    timestamps()
  end

  @required [:email, :password]
  @optional [:name]

  defp changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Crypto.add_password_hash(password))
  end

  defp put_password_hash(changeset), do: changeset

  def create(attrs) do
    %User{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def list_by(%{name: name}) do
    User
    |> where(name: ^name)
    |> Repo.all()
  end
end
