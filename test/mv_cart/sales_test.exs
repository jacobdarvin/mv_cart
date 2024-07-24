defmodule MvCart.SalesTest do
  use MvCart.DataCase

  alias MvCart.Sales

  describe "purchases" do
    alias MvCart.Sales.Purchase

    import MvCart.SalesFixtures

    @invalid_attrs %{quantity: nil}

    test "list_purchases/0 returns all purchases" do
      purchase = purchase_fixture()
      assert Sales.list_purchases() == [purchase]
    end

    test "get_purchase!/1 returns the purchase with given id" do
      purchase = purchase_fixture()
      assert Sales.get_purchase!(purchase.id) == purchase
    end

    test "create_purchase/1 with valid data creates a purchase" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %Purchase{} = purchase} = Sales.create_purchase(valid_attrs)
      assert purchase.quantity == 42
    end

    test "create_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_purchase(@invalid_attrs)
    end

    test "update_purchase/2 with valid data updates the purchase" do
      purchase = purchase_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %Purchase{} = purchase} = Sales.update_purchase(purchase, update_attrs)
      assert purchase.quantity == 43
    end

    test "update_purchase/2 with invalid data returns error changeset" do
      purchase = purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_purchase(purchase, @invalid_attrs)
      assert purchase == Sales.get_purchase!(purchase.id)
    end

    test "delete_purchase/1 deletes the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{}} = Sales.delete_purchase(purchase)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_purchase!(purchase.id) end
    end

    test "change_purchase/1 returns a purchase changeset" do
      purchase = purchase_fixture()
      assert %Ecto.Changeset{} = Sales.change_purchase(purchase)
    end
  end

  describe "wallet_transactions" do
    alias MvCart.Sales.WalletTransaction

    import MvCart.SalesFixtures

    @invalid_attrs %{purchase_id: nil, wallet_id: nil, amount: nil}

    test "list_wallet_transactions/0 returns all wallet_transactions" do
      wallet_transaction = wallet_transaction_fixture()
      assert Sales.list_wallet_transactions() == [wallet_transaction]
    end

    test "get_wallet_transaction!/1 returns the wallet_transaction with given id" do
      wallet_transaction = wallet_transaction_fixture()
      assert Sales.get_wallet_transaction!(wallet_transaction.id) == wallet_transaction
    end

    test "create_wallet_transaction/1 with valid data creates a wallet_transaction" do
      valid_attrs = %{purchase_id: "7488a646-e31f-11e4-aace-600308960662", wallet_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5"}

      assert {:ok, %WalletTransaction{} = wallet_transaction} = Sales.create_wallet_transaction(valid_attrs)
      assert wallet_transaction.purchase_id == "7488a646-e31f-11e4-aace-600308960662"
      assert wallet_transaction.wallet_id == "7488a646-e31f-11e4-aace-600308960662"
      assert wallet_transaction.amount == Decimal.new("120.5")
    end

    test "create_wallet_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_wallet_transaction(@invalid_attrs)
    end

    test "update_wallet_transaction/2 with valid data updates the wallet_transaction" do
      wallet_transaction = wallet_transaction_fixture()
      update_attrs = %{purchase_id: "7488a646-e31f-11e4-aace-600308960668", wallet_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7"}

      assert {:ok, %WalletTransaction{} = wallet_transaction} = Sales.update_wallet_transaction(wallet_transaction, update_attrs)
      assert wallet_transaction.purchase_id == "7488a646-e31f-11e4-aace-600308960668"
      assert wallet_transaction.wallet_id == "7488a646-e31f-11e4-aace-600308960668"
      assert wallet_transaction.amount == Decimal.new("456.7")
    end

    test "update_wallet_transaction/2 with invalid data returns error changeset" do
      wallet_transaction = wallet_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_wallet_transaction(wallet_transaction, @invalid_attrs)
      assert wallet_transaction == Sales.get_wallet_transaction!(wallet_transaction.id)
    end

    test "delete_wallet_transaction/1 deletes the wallet_transaction" do
      wallet_transaction = wallet_transaction_fixture()
      assert {:ok, %WalletTransaction{}} = Sales.delete_wallet_transaction(wallet_transaction)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_wallet_transaction!(wallet_transaction.id) end
    end

    test "change_wallet_transaction/1 returns a wallet_transaction changeset" do
      wallet_transaction = wallet_transaction_fixture()
      assert %Ecto.Changeset{} = Sales.change_wallet_transaction(wallet_transaction)
    end
  end
end
