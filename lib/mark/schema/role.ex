defmodule Mark.Schema.Role do
  use Ecto.Schema

  schema "role" do
    field :ref, :string
    belongs_to(:server, Mark.Schema.Server)
  end
end
