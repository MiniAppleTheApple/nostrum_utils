defmodule Mark.Commands.Mark.Set do
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType
  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Struct.Component.TextInput
  alias Nostrum.Struct.Component.ActionRow

  alias Mark.SubCommand
  alias Mark.MessageComponent

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "生成介面",
      type: ApplicationCommandOptionType.sub_command()
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, _option) do
    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.modal(),
      data: %{
        title: "Form",
        custom_id: MessageComponent.random_id(),
        components: [ActionRow.action_row(components: [TextInput.text_input("Label", MessageComponent.random_id())])]
      }
    })
  end
end
