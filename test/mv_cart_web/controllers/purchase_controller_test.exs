defmodule MvCartWeb.PurchaseControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.AccountsFixtures
  import MvCart.CatalogFixtures
  import Ecto.Query, only: [from: 2]

  alias MvCart.Guardian
  alias MvCart.Repo
  alias MvCart.Sales.WalletTransaction
  alias Decimal

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup :setup_user

    test "returns unauthenticated", %{conn: conn} do
      conn = get(conn, ~p"/api/purchases")
      assert json_response(conn, 401)
    end

    test "lists all purchases for authenticated user", %{conn: conn, token: token} do
      conn = conn |> put_req_header("authorization", "Bearer #{token}") |> get(~p"/api/purchases")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create" do
    setup :setup_user_and_product

    test "returns unauthenticated", %{conn: conn} do
      conn = post(conn, ~p"/api/purchases", purchase: %{})
      assert json_response(conn, 401)
    end

    test "returns error when insufficient balance", %{
      conn: conn,
      token: token,
      product: product,
      user: user
    } do
      # Reduce the user's wallet transactions to reflect an insufficient balance
      Repo.delete_all(from(t in WalletTransaction, where: t.wallet_id == ^user.wallet.id))

      purchase_params = %{
        "product_id" => product.id,
        "quantity" => 1
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post(~p"/api/purchases", purchase: purchase_params)

      assert json_response(conn, 422)["error"] == "Insufficient balance"
    end

    test "returns error when quantity is invalid", %{conn: conn, token: token, product: product} do
      purchase_params = %{
        "product_id" => product.id,
        "quantity" => product.quantity + 1
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post(~p"/api/purchases", purchase: purchase_params)

      assert json_response(conn, 422)["error"] == "Invalid quantity"
    end
  end

  defp setup_user(_context) do
    user = user_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    %{token: token}
  end

  defp setup_user_and_product(_context) do
    user = user_fixture() |> Repo.preload(:wallet)
    product = product_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    # Create wallet transactions to ensure sufficient balance
    Repo.insert!(%WalletTransaction{
      wallet_id: user.wallet.id,
      amount: Decimal.new("1000.0")
    })

    %{token: token, product: product, user: user}
  end
end
