defmodule Mark.Schema.Server do
  use Ecto.Schema

  schema "server" do
    has_many :needed_roles, Mark.Schema.Role
    field :ref, :string
  end
end
