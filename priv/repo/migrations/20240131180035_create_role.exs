defmodule Mark.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table("role") do
      add :server_id, references(:server) 
    end
  end

end
