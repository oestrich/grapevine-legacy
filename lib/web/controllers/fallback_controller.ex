defmodule Web.FallbackController do
  use Web, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_flash(:error, "Not found")
    |> redirect(to: page_path(conn, :index))
  end
end
