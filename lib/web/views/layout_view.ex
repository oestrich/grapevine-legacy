defmodule Web.LayoutView do
  use Web, :view

  def user_token(%{assigns: %{user_token: token}}), do: token
  def user_token(_), do: ""

  def profile_id(user) do
    URI.encode_www_form(user.username)
  end
end
