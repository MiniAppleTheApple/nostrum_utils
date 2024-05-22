defmodule Mark.Commands.Mark.Name.Set do
  alias Nostrum.Api
  alias Nostrum.Struct.Component.{SelectMenu, ActionRow, Option}
  alias Nostrum.Constants.{ApplicationCommandOptionType, InteractionCallbackType}

  alias Mark.{SubCommand, AllowedCharset, Util}

  import Bitwise

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "新增新的可以使用的字符格式",
      type: ApplicationCommandOptionType.sub_command(),
      options: []
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, _option) do
    map = AllowedCharset.map()
    id = Util.random_id()
    
    select_menu = SelectMenu.select_menu(id, [
      min_values: 1,
      max_values: map |> Enum.count(),
      options: map |> Enum.map(fn {_key, {value, text}} ->
        %Option{
          label: text,
          value: value,
        }
      end)
    ])

    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        flags: 1 <<< 6, #empheral
        components: [ActionRow.action_row(select_menu)]
      }
    })
  end
end
