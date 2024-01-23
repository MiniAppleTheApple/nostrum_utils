defmodule Mark.SubCommand do
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.ApplicationCommandInteractionDataOption

  @callback spec(name :: String.t()) :: map()
  @callback handle_interaction(Interaction.t(), ApplicationCommandInteractionDataOption.t()) :: any()
end
