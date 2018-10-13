defmodule Web.CharacterController do
  use Web, :controller

  alias Grapevine.Accounts
  alias Grapevine.Characters

  def approve(conn, %{"character_id" => id}) do
    %{current_user: user} = conn.assigns

    with {:ok, character} <- Characters.get(id),
         {:ok, character} <- Characters.check_user(character, user),
         {:ok, _character} <- Characters.approve_character(character) do
      conn
      |> put_flash(:info, "Character approved!")
      |> redirect(to: profile_path(conn, :show, Accounts.profile_id(user)))
    else
      _ ->
        conn
        |> put_flash(:error, "An issue occurred. Please try again")
        |> redirect(to: profile_path(conn, :show, Accounts.profile_id(user)))
    end
  end

  def deny(conn, %{"character_id" => id}) do
    %{current_user: user} = conn.assigns

    with {:ok, character} <- Characters.get(id),
         {:ok, character} <- Characters.check_user(character, user),
         {:ok, _character} <- Characters.deny_character(character) do
      conn
      |> put_flash(:info, "Character denied.")
      |> redirect(to: profile_path(conn, :show, Accounts.profile_id(user)))
    else
      _ ->
        conn
        |> put_flash(:error, "An issue occurred. Please try again")
        |> redirect(to: profile_path(conn, :show, Accounts.profile_id(user)))
    end
  end
end
