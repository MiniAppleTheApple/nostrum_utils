defmodule Mark.SubCommand do
  alias Nostrum.Struct.ApplicationCommandInteractionDataOption

  @callback spec(name :: String.t()) :: map()
  @callback handle_interaction(Interaction.t(), ApplicationCommandInteractionDataOption.t()) :: any()
  @spec get_option(ApplicationCommandInteractionDataOption.t(), String.t()) ::
          Nostrum.Struct.ApplicationCommandInteractionDataOption | nil
  def get_option(option, name),
    do: Enum.find(option.options || [], fn %{name: n} -> n == name end)

end
