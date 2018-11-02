defmodule Web.Plugs.FetchUser do
  @moduledoc """
  Fetch a user from the session
  """

  import Plug.Conn

  alias Grapevine.Accounts
  alias Grapevine.Authorizations

  def init(default), do: default

  def call(conn, [api: true]) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case Authorizations.get_token(token) do
          {:ok, access_token} ->
            conn
            |> assign(:access_token, access_token)
            |> assign(:current_user, access_token.authorization.user)

          _ ->
            conn
        end

      [] ->
        conn
    end
  end

  def call(conn, _opts) do
    case conn |> get_session(:user_token) do
      nil ->
        conn

      token ->
        load_user(conn, Accounts.from_token(token))
    end
  end

  defp load_user(conn, {:ok, user}) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  defp load_user(conn, _), do: conn
end
