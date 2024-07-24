defmodule MvCartWeb.WalletTransactionControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.SalesFixtures

  alias MvCart.Sales.WalletTransaction

  @create_attrs %{
    purchase_id: "7488a646-e31f-11e4-aace-600308960662",
    wallet_id: "7488a646-e31f-11e4-aace-600308960662",
    amount: "120.5"
  }
  @update_attrs %{
    purchase_id: "7488a646-e31f-11e4-aace-600308960668",
    wallet_id: "7488a646-e31f-11e4-aace-600308960668",
    amount: "456.7"
  }
  @invalid_attrs %{purchase_id: nil, wallet_id: nil, amount: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all wallet_transactions", %{conn: conn} do
      conn = get(conn, ~p"/api/wallet_transactions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create wallet_transaction" do
    test "renders wallet_transaction when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/wallet_transactions", wallet_transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/wallet_transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "120.5",
               "purchase_id" => "7488a646-e31f-11e4-aace-600308960662",
               "wallet_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/wallet_transactions", wallet_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update wallet_transaction" do
    setup [:create_wallet_transaction]

    test "renders wallet_transaction when data is valid", %{
      conn: conn,
      wallet_transaction: %WalletTransaction{id: id} = wallet_transaction
    } do
      conn =
        put(conn, ~p"/api/wallet_transactions/#{wallet_transaction}",
          wallet_transaction: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/wallet_transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "456.7",
               "purchase_id" => "7488a646-e31f-11e4-aace-600308960668",
               "wallet_id" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      wallet_transaction: wallet_transaction
    } do
      conn =
        put(conn, ~p"/api/wallet_transactions/#{wallet_transaction}",
          wallet_transaction: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete wallet_transaction" do
    setup [:create_wallet_transaction]

    test "deletes chosen wallet_transaction", %{
      conn: conn,
      wallet_transaction: wallet_transaction
    } do
      conn = delete(conn, ~p"/api/wallet_transactions/#{wallet_transaction}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/wallet_transactions/#{wallet_transaction}")
      end
    end
  end

  defp create_wallet_transaction(_) do
    wallet_transaction = wallet_transaction_fixture()
    %{wallet_transaction: wallet_transaction}
  end
end
