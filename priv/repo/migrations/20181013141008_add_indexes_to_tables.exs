defmodule Grapevine.Repo.Migrations.AddIndexesToTables do
  use Ecto.Migration

  def change do
    create index(:games, :short_name)
    create index(:games, ["lower(short_name)"], unique: true)
    create index(:users, :username)
  end
end
