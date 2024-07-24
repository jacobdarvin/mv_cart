defmodule MvCart.Repo.Migrations.CreateWalletTransactions do
  use Ecto.Migration

  def change do
    create table(:wallet_transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :purchase_id, :uuid
      add :wallet_id, :uuid
      add :amount, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
