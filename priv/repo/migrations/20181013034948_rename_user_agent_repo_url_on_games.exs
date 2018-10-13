defmodule Grapevine.Repo.Migrations.RenameUserAgentRepoUrlOnGames do
  use Ecto.Migration

  def change do
    rename table(:games), :user_agent_repo_url, to: :user_agent_url
  end
end
