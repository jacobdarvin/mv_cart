defmodule MvCart.Repo.Migrations.CreateWalletAndWalletTransactions do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create table(:wallet_transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :purchase_id, references(:purchases, type: :uuid, on_delete: :delete_all)
      add :wallet_id, references(:wallets, type: :uuid, on_delete: :delete_all)
      add :amount, :decimal

      timestamps()
    end

    create index(:wallets, [:user_id])
    create index(:wallet_transactions, [:purchase_id])
    create index(:wallet_transactions, [:wallet_id])
  end
end
