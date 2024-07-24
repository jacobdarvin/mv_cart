defmodule MvCart.CatalogTest do
  use MvCart.DataCase

  alias MvCart.Catalog
  alias MvCart.Catalog.Product

  import MvCart.CatalogFixtures

  describe "create_product/1" do
    test "returns product" do
      params = %{
        name: "Name",
        description: "Description",
        quantity: 5,
        price: 120.00,
        image: "randomlink.jpg"
      }

      name = params.name
      assert {:ok, %Product{name: ^name}} = Catalog.create_product(params)
    end

    test "returns error if product params are invalid (image is blank)" do
      params = %{
        name: "Name",
        description: "Description",
        quantity: 5,
        price: 120.00
      }

      assert {:error, changeset} = Catalog.create_product(params)
      assert changeset.valid? == false
      assert [image: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end

  describe "list_products/0" do
    test "returns list of products" do
      _product1 = product_fixture(%{name: "Product 1"})
      _product2 = product_fixture(%{name: "Product 2"})

      products = Catalog.list_products()

      assert length(products) == 2
      assert Enum.any?(products, fn product -> product.name == "Product 1" end)
      assert Enum.any?(products, fn product -> product.name == "Product 2" end)
    end

    test "returns empty list if no product found" do
      Repo.delete_all(Product)

      products = Catalog.list_products()

      assert products == []
    end
  end

  describe "get_product!/1" do
    test "returns the product with the given id" do
      product = product_fixture(%{name: "Product 1"})
      fetched_product = Catalog.get_product!(product.id)
      assert fetched_product.id == product.id
    end

    test "raises an error if the product does not exist" do
      non_existent_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        Catalog.get_product!(non_existent_id)
      end
    end
  end

  describe "get_product/1" do
    test "returns {:ok, product} if the product exists" do
      product = product_fixture(%{name: "Product 1"})
      assert {:ok, fetched_product} = Catalog.get_product(product.id)
      assert fetched_product.id == product.id
    end

    test "returns {:error, :not_found} if the product does not exist" do
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Catalog.get_product(non_existent_id)
    end
  end

  describe "update_product_quantity/2" do
    test "updates the product quantity" do
      product = product_fixture(%{quantity: 10})
      assert {:ok, %Product{} = updated_product} = Catalog.update_product_quantity(product, 3)
      assert updated_product.quantity == 7
    end

    test "returns an error if the product quantity update fails" do
      product = product_fixture(%{quantity: 10})
      assert {:error, _changeset} = Catalog.update_product_quantity(product, 20)
    end
  end
end
