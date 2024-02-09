defmodule Mark.Commands.Ping do
  alias Mark.MessageComponent

  alias Nostrum.Api

  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.ActionRow

  alias Nostrum.Cache.Me

  alias Mark.Command

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
      data: Component.button("This button will be deleted after clicked"),
        custom_id: MessageComponent.random_id(),
        style: 1
      },
      handle: fn new_interaction ->
        Api.create_interaction_response!(new_interaction, %{
          type: 4,
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
      type: 4,
      data: %{
        contents: "Ping by slash command",
        components: [
          ActionRow.action_row() |> ActionRow.append(button.data)
        ]
      }
    })
  end
end
