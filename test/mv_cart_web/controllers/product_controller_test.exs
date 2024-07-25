defmodule MvCartWeb.ProductControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.AccountsFixtures

  alias MvCart.Guardian

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # Before All
    setup :setup_user

    test "returns unauthenticated", %{conn: conn} do
      conn = get(conn, ~p"/api/products")
      assert json_response(conn, 401)
    end

    test "lists all products", %{conn: conn, token: token} do
      conn = conn |> put_req_header("authorization", "Bearer #{token}") |> get(~p"/api/products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  defp setup_user(_context) do
    user = user_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    %{token: token}
  end
end
