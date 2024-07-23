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
end
