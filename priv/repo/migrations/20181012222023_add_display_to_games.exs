defmodule Grapevine.Repo.Migrations.AddDisplayToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add(:display, :boolean, default: false, null: false)
    end
  end
end
