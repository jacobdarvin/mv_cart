defmodule MvCart.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :uuid

      timestamps(type: :utc_datetime)
    end
  end
end
