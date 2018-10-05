defmodule Grapevine.Repo.Migrations.LowercaseUniqueIndexesOnUsers do
  use Ecto.Migration

  def up do
    drop index(:users, :username, unique: true)
    drop index(:users, :email, unique: true)

    create index(:users, ["lower(username)"], unique: true, name: :users_lower_username_index)
    create index(:users, ["lower(email)"], unique: true, name: :users_lower_email_index)
  end

  def down do
    drop index(:users, :username)
    drop index(:users, :email)

    create index(:users, :username, unique: true)
    create index(:users, :email, unique: true)
  end
end
