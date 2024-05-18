defmodule Mark.Util do
  alias Nostrum.Struct.Interaction
  alias Mark.Schema.Server

  import Ecto.Query
  @doc """
  Gets an option by it's name from the interaction. Returns `nil` if the
  option is not present in the interaction.
  """
  
  @id_length 98
  @id_possible_characters ~c"1234567890abcdefghijklmnopqrstuvwABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-+"

  @spec get_option(Interaction.t(), String.t()) ::
          Nostrum.Struct.ApplicationCommandInteractionData.options() | nil
  def get_option(interaction, name),
    do: Enum.find(interaction.data.options || [], fn %{name: n} -> n == name end)

  def random_id do
    0..@id_length
    |> Enum.map(fn _x -> Enum.random(@id_possible_characters) end)
    |> to_string()
  end

  def get_textinputs_from_interaction(interaction) do
    interaction.data.components
    |> Enum.map(fn x ->
      x
      |> Map.get(:components)
      |> List.first()
    end)
  end

  @spec query_corresponding_server(String.t(), [atom()]) :: Queryable.t()
  def query_corresponding_server(guild_id, preload \\ []) do
    from s in Server, where: s.ref == ^(guild_id |> to_string()), preload: ^preload, select: s
  end
end
