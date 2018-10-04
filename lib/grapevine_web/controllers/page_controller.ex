defmodule GrapevineWeb.PageController do
  use GrapevineWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
