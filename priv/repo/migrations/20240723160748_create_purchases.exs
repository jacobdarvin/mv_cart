defmodule MvCart.Repo.Migrations.CreatePurchases do
  use Ecto.Migration

  def change do
    create table(:purchases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:purchases, [:product_id])
  end
end
