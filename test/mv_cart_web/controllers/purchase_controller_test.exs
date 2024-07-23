defmodule MvCartWeb.PurchaseControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.SalesFixtures

  alias MvCart.Sales.Purchase

  @create_attrs %{
    quantity: 42
  }
  @update_attrs %{
    quantity: 43
  }
  @invalid_attrs %{quantity: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all purchases", %{conn: conn} do
      conn = get(conn, ~p"/api/purchases")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create purchase" do
    test "renders purchase when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/purchases", purchase: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/purchases/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/purchases", purchase: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update purchase" do
    setup [:create_purchase]

    test "renders purchase when data is valid", %{conn: conn, purchase: %Purchase{id: id} = purchase} do
      conn = put(conn, ~p"/api/purchases/#{purchase}", purchase: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/purchases/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, purchase: purchase} do
      conn = put(conn, ~p"/api/purchases/#{purchase}", purchase: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete purchase" do
    setup [:create_purchase]

    test "deletes chosen purchase", %{conn: conn, purchase: purchase} do
      conn = delete(conn, ~p"/api/purchases/#{purchase}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/purchases/#{purchase}")
      end
    end
  end

  defp create_purchase(_) do
    purchase = purchase_fixture()
    %{purchase: purchase}
  end
end
