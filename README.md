# MvCart (COP'D)

This is the Phoenix server for the https://github.com/jacobdarvin/mv-cart front end.

## Project Setup

To begin you must have Phoenix and Elixir installed.

### Get Dependencies

```sh
mix deps.get
```

### Create Database and Migrate Data

```sh
mix ecto.create
mix ecto.migrate
```

### Seed Database with Sample Data

```sh
mix run priv/repo/seeds.exs
```

This will add the following sample data to your mv_cart_dev DB:

```sh
Catalog.create_product(%{
  name: "Nike Air Max 270",
  description:
    "Experience unparalleled comfort with Nike Air Max 270, featuring a large air unit for a cushioned stride.",
  quantity: 10,
  price: 150.00,
  image:
    "https://dynamic.zacdn.com/FHfS_g1yzCZDCVh5_9F1h94MTIM=/filters:quality(70):format(webp)/https://static-ph.zacdn.com/p/nike-1614-4575913-2.jpg"
})

Catalog.create_product(%{
  name: "Nike Air Force 1",
  description:
    "Classic design meets modern comfort in Nike Air Force 1, perfect for any casual outfit.",
  quantity: 5,
  price: 120.00,
  image:
    "https://dynamic.zacdn.com/7f7QkMVe0h0Qn57T1Gz4KmiJKk0=/filters:quality(70):format(webp)/https://static-ph.zacdn.com/p/nike-0565-7017322-2.jpg"
})

Catalog.create_product(%{
  name: "Nike Revolution 5",
  description:
    "Step into a smooth, stable run with Nike Revolution 5, featuring lightweight cushioning and a minimalist design.",
  quantity: 8,
  price: 80.00,
  image:
    "https://dynamic.zacdn.com/xbhx5QJdbZ5izH7zNrVq2Tvkzw4=/filters:quality(70):format(webp)/https://static-ph.zacdn.com/p/nike-8414-5285433-2.jpg"
})
```

## Run server

```sh
mix phx.server
```

This will run a phoenix server on http://localhost:4000

### Run the frontend

After this run the frontend: https://github.com/jacobdarvin/mv-cart

