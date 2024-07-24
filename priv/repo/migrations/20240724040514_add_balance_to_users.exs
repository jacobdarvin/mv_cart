defmodule MvCart.Repo.Migrations.AddBalanceToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal, default: 0.0, null: false
    end
  end
end
