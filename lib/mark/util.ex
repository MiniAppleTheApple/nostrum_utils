defmodule Mark.Util do
  alias Nostrum.Struct.Interaction
  @doc """
  Gets an option by it's name from the interaction. Returns `nil` if the
  option is not present in the interaction.
  """
  @spec get_option(Interaction.t(), String.t()) ::
          Nostrum.Struct.ApplicationCommandInteractionData.options() | nil
  def get_option(interaction, name),
    do: Enum.find(interaction.data.options || [], fn %{name: n} -> n == name end)

  def get_textinputs_from_interaction(interaction) do
    interaction.data.components
    |> Enum.map(fn x ->
      x
      |> Map.get(:components)
      |> List.first()
    end)
  end
end
