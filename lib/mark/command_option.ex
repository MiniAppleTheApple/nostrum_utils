defmodule Mark.CommandOption do
  alias Nostrum.Struct.ApplicationCommandInteractionDataOption

  alias Mark.Constant.ApplicationCommandOptionType

  @spec sub_command_or_sub_command_group?(ApplicationCommandInteractionDataOption.t()) ::
          boolean()
  def sub_command_or_sub_command_group?(%ApplicationCommandInteractionDataOption{type: type}) do
    type == ApplicationCommandOptionType.sub_command() or
      type == ApplicationCommandOptionType.sub_command_group()
  end

  @spec get_option(ApplicationCommandInteractionDataOption.t(), String.t()) ::
          ApplicationCommandInteractionDataOption.t()
  def get_option(option_root, name) do
    option_root.options
    |> Enum.find(fn %{name: n} ->
      name == n
    end)
  end
end
