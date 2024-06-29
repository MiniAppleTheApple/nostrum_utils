defmodule NostrumUtils do
  alias Nostrum.Struct.{Interaction, ApplicationCommandInteractionData, Component}
  @doc """
  Gets an option by it's name from the interaction. Returns `nil` if the
  option is not present in the interaction.
  """
  
  @id_length 98
  @id_possible_characters ~c"1234567890abcdefghijklmnopqrstuvwABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-+"

  @spec get_option(Interaction.t(), String.t()) ::
          ApplicationCommandInteractionData.options() | nil
  def get_option(interaction, name),
    do: Enum.find(interaction.data.options || [], fn %{name: n} -> n == name end)

  @spec random_id() :: String.t() 
  def random_id do
    0..@id_length
    |> Enum.map(fn _x -> Enum.random(@id_possible_characters) end)
    |> to_string()
  end

  @spec get_textinputs_from_interaction(Interaction.t()) :: Component.t() 
  def get_textinputs_from_interaction(interaction) do
    interaction.data.components
    |> Enum.map(fn x ->
      x
      |> Map.get(:components)
      |> List.first()
    end)
  end
end
