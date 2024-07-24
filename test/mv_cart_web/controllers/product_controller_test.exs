defmodule MvCartWeb.ProductControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.CatalogFixtures
  import MvCart.AccountsFixtures

  alias MvCart.Catalog.Product
  alias MvCart.Guardian

  @create_attrs %{
    name: "some name",
    description: "some description",
    quantity: 42,
    price: "120.5"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    quantity: 43,
    price: "456.7"
  }
  @invalid_attrs %{name: nil, description: nil, quantity: nil, price: nil}

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
