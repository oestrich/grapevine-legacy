defmodule Web.ProfileView do
  use Web, :view

  def current_user?(assigns, user) do
    Map.has_key?(assigns, :current_user) && assigns.current_user.id == user.id
  end

  def pending_characters(characters) do
    Enum.filter(characters, &(&1.state == "pending"))
  end

  def approved_characters(characters) do
    Enum.filter(characters, &(&1.state == "approved"))
  end
end
