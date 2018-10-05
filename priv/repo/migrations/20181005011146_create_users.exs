defmodule Grapevine.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :token, :uuid

      timestamps()
    end

    create index(:users, :username, unique: true)
    create index(:users, :email, unique: true)
  end
end
