defmodule Mark.Commands.Ping do
  alias Mark.Command
  alias Mark.MessageComponent

  alias Nostrum.Api

  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.ActionRow

  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Cache.Me

  @behaviour Command

  @impl Command
  def spec(name) do
    %{
      name: name,
      description: "A command to check if the bot is alive"
    }
  end

  @impl Command
  def handle_interaction(interaction) do
    button = %MessageComponent{
      data: Component.Button.interaction_button("This button will be deleted after clicked", MessageComponent.random_id()),
      handle: fn new_interaction ->
        Api.create_interaction_response!(new_interaction, %{
          type: InteractionCallbackType.channel_message_with_source(),
          data: %{
            content: "Ping by clicking the button"
          }
        })
        Api.delete_interaction_response!(Me.get().id, interaction.token)
        :remove
      end
    }

    MessageComponent.Agent.add_component(button)

    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        contents: "Ping by slash command",
        components: [
          ActionRow.action_row() |> ActionRow.append(button.data)
        ]
      }
    })
  end
end
