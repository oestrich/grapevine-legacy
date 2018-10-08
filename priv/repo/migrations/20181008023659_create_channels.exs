defmodule Grapevine.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:remote_id, :integer, null: false)
      add(:name, :string, null: false)
      add(:description, :text)
      add(:hidden, :boolean, null: false)

      timestamps()
    end
  end
end
