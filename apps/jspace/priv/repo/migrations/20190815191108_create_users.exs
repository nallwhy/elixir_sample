defmodule Jspace.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:name, :string, null: true)

      timestamps()
    end

    create unique_index(:users, [:email])
    create index(:users, [:name])
  end
end
