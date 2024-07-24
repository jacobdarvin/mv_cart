defmodule MvCart.Repo.Migrations.AddBalanceToUsers500 do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal, default: 500.0, null: false
    end
  end
end
