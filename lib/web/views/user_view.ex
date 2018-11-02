defmodule Web.UserView do
  use Web, :view

  def render("show.json", %{user: user}) do
    Map.take(user, [:email])
  end
end
