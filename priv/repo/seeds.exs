alias MvCart.Catalog

Catalog.create_product(%{
  name: "Product 1",
  description: "Description 1",
  quantity: 10,
  price: 100.00
})

Catalog.create_product(%{
  name: "Product 2",
  description: "Description 2",
  quantity: 5,
  price: 50.00
})
