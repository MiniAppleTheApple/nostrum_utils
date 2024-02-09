defmodule Mark.Commands.Ping do
  alias Mark.MessageComponent

  alias Nostrum.Api
  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.ActionRow

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
      data: %Component{
        type: 2,
        label: "Dingding",
        custom_id: MessageComponent.random_id(),
        style: 1
      },
      handle: fn interaction ->
        Api.create_interaction_response!(interaction, %{
          type: 4,
          data: %{
            content: "Ping by clicking the button"
          }
        })
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
