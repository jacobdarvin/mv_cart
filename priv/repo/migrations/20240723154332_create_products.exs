defmodule MvCart.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :quantity, :integer
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
