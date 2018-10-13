defmodule Grapevine.Repo.Migrations.AddAllowCharacterRegistrationToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add(:allow_character_registration, :boolean, default: false, null: false)
    end
  end
end
