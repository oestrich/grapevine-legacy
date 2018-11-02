defmodule Web.AuthConnCase do
  defmacro __using__(_opts) do
    quote do
      use Web.ConnCase

      setup %{conn: conn} do
        user = create_user()
        conn = conn |> assign(:current_user, user)
        %{conn: conn, user: user}
      end
    end
  end
end
