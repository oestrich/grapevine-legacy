defmodule Grapevine.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add(:remote_id, :integer, null: false)
      add(:name, :string, null: false)
      add(:short_name, :string, null: false)
      add(:user_agent, :string)
      add(:user_agent_repo_url, :string)
      add(:description, :string)
      add(:homepage_url, :string)
      add(:connections, {:array, :jsonb}, default: fragment("'{}'"), null: false)

      timestamps()
		end

    create index(:games, :remote_id, unique: true)
  end
end
