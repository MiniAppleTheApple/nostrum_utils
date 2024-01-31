defmodule Mark.Repo.Migrations.AddRefFieldIntoRole do
  use Ecto.Migration

  def change do
    alter table("role") do
      add :ref, :string, default: ""
    end
    flush()
  end
end
