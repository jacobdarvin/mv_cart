defmodule MvCart.SalesTest do
  use MvCart.DataCase

  alias MvCart.Sales

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
end
