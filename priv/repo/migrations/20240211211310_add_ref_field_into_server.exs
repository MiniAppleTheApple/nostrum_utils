defmodule Mark.Repo.Migrations.AddRefFieldIntoServer do
  use Ecto.Migration

  def change do
    alter table("server") do
      add :ref, :string, default: ""
    end
    flush()
  end
end
