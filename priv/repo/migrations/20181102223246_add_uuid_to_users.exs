defmodule Grapevine.Repo.Migrations.AddUuidToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:uid, :uuid, default: fragment("uuid_generate_v4()"), null: false)
    end

    create index(:users, :uid, unique: true)
  end
end
