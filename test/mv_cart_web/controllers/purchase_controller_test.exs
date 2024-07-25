defmodule MvCartWeb.PurchaseControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.AccountsFixtures
  import MvCart.CatalogFixtures
  import Ecto.Query, only: [from: 2]

  alias MvCart.Guardian
  alias MvCart.Repo
  alias MvCart.Sales.WalletTransaction
  alias Decimal

  # Setup to include common headers for all tests
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup :setup_user

    # Test to verify unauthenticated request handling for purchase listing
    test "returns unauthenticated", %{conn: conn} do
      conn = get(conn, ~p"/api/purchases")
      assert json_response(conn, 401)
    end

    # Test to verify purchase listing for an authenticated user
    test "lists all purchases for authenticated user", %{conn: conn, token: token} do
      conn = conn |> put_req_header("authorization", "Bearer #{token}") |> get(~p"/api/purchases")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create" do
    setup :setup_user_and_product

    # Test to verify unauthenticated request handling for purchase creation
    test "returns unauthenticated", %{conn: conn} do
      conn = post(conn, ~p"/api/purchases", purchase: %{})
      assert json_response(conn, 401)
    end

    # Test to verify handling of insufficient balance during purchase creation
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

    # Test to verify handling of invalid quantity during purchase creation
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

    # Test to verify successful purchase creation
    test "creates a purchase successfully", %{
      conn: conn,
      token: token,
      product: product,
      user: user
    } do
      purchase_params = %{
        "product_id" => product.id,
        "quantity" => 1
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post(~p"/api/purchases", purchase: purchase_params)

      response = json_response(conn, 201)
      assert response["id"]
      assert response["product_id"] == product.id
      assert response["quantity"] == 1

      # Check the database for the new purchase
      purchase = Repo.get_by(MvCart.Sales.Purchase, id: response["id"])
      assert purchase
      assert purchase.user_id == user.id
      assert purchase.product_id == product.id
      assert purchase.quantity == 1

      # Verify that the product quantity has been updated
      updated_product = Repo.get(MvCart.Catalog.Product, product.id)
      assert updated_product.quantity == product.quantity - 1

      # Verify that the wallet transaction has been created
      wallet_transaction =
        Repo.get_by(MvCart.Sales.WalletTransaction, purchase_id: purchase.id)

      assert wallet_transaction
      assert wallet_transaction.wallet_id == user.wallet.id
      assert Decimal.compare(wallet_transaction.amount, Decimal.negate(product.price)) == :eq
    end
  end

  # Helper function to setup a user and generate an authentication token
  defp setup_user(_context) do
    user = user_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    %{token: token}
  end

  # Helper function to setup a user, product, and generate an authentication token
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
