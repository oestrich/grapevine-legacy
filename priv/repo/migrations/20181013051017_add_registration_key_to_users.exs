defmodule Grapevine.Repo.Migrations.AddRegistrationKeyToUsers do
  use Ecto.Migration

  def change do
    execute ~s{create extension "uuid-ossp";}

    alter table(:users) do
      add(:registration_key, :uuid, default: fragment("uuid_generate_v4()"), null: false)
    end
  end
end
