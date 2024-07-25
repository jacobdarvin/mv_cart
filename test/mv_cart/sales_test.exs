defmodule MvCart.SalesTest do
  use MvCart.DataCase

  alias MvCart.Sales
  alias MvCart.Sales.{Purchase, WalletTransaction}
  alias MvCart.Accounts.Wallet

  import MvCart.SalesFixtures
  import MvCart.AccountsFixtures

  describe "list_user_purchases/1" do
    test "returns list of purchases for a user" do
      # Create a valid user
      user = user_fixture()
      purchase1 = purchase_fixture(%{user_id: user.id})
      purchase2 = purchase_fixture(%{user_id: user.id})

      purchases = Sales.list_user_purchases(user.id)

      assert length(purchases) == 2
      assert Enum.any?(purchases, fn p -> p.id == purchase1.id end)
      assert Enum.any?(purchases, fn p -> p.id == purchase2.id end)
    end

    test "returns an empty list if the user has no purchases" do
      user = user_fixture()

      purchases = Sales.list_user_purchases(user.id)

      assert purchases == []
    end

    test "returns an empty list for a non-existent user" do
      non_existent_user_id = Ecto.UUID.generate()

      purchases = Sales.list_user_purchases(non_existent_user_id)

      assert purchases == []
    end
  end

  describe "create_purchase/1" do
    test "creates a purchase" do
      user = user_fixture()
      product = MvCart.CatalogFixtures.product_fixture()

      attrs = %{
        user_id: user.id,
        product_id: product.id,
        quantity: 1
      }

      assert {:ok, %Purchase{} = purchase} = Sales.create_purchase(attrs)
      assert purchase.user_id == attrs.user_id
      assert purchase.product_id == attrs.product_id
      assert purchase.quantity == attrs.quantity
    end
  end

  describe "top_up_wallet/2" do
    test "tops up the wallet with a valid amount" do
      user = user_fixture()
      _wallet = Wallet |> Repo.get_by!(user_id: user.id)

      assert {:ok, _} = Sales.top_up_wallet(user.id, Decimal.new("50.00"))
      assert {:ok, balance} = Sales.calculate_balance(user.id)
      assert balance == Decimal.new("50.00")
    end
  end

  describe "calculate_balance/1" do
    test "calculates the balance for a user with transactions" do
      user = user_fixture()
      wallet = Wallet |> Repo.get_by!(user_id: user.id)
      wallet_transaction_fixture(%{wallet_id: wallet.id, amount: Decimal.new("100.00")})

      assert {:ok, balance} = Sales.calculate_balance(user.id)
      assert balance == Decimal.new("100.00")
    end

    test "returns zero balance if there are no transactions" do
      user = user_fixture()

      assert {:ok, balance} = Sales.calculate_balance(user.id)
      assert balance == Decimal.new("0.00")
    end

    test "returns error if the wallet does not exist" do
      non_existent_user_id = Ecto.UUID.generate()

      assert {:error, :not_found} = Sales.calculate_balance(non_existent_user_id)
    end
  end

  describe "create_wallet_transaction/1" do
    test "creates a wallet transaction" do
      wallet = wallet_fixture()
      attrs = %{wallet_id: wallet.id, amount: Decimal.new("50.00")}

      assert {:ok, %WalletTransaction{} = transaction} = Sales.create_wallet_transaction(attrs)
      assert transaction.wallet_id == attrs.wallet_id
      assert transaction.amount == attrs.amount
    end
  end
end
