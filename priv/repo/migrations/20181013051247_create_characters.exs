defmodule Grapevine.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add(:user_id, references(:users), null: false)
      add(:game_id, references(:games), null: false)
      add(:name, :string, null: false)
      add(:state, :string, default: "pending")

      timestamps()
    end

    create index(:characters, [:game_id, :name], unique: true)
  end
end
