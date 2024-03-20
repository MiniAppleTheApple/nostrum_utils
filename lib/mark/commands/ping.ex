defmodule Mark.Commands.Ping do
  alias Mark.Command

  alias Nostrum.Api

  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.ActionRow

  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Cache.Me

  @behaviour Command
  # Hello

  @impl Command
  def spec(name) do
    %{
      name: name,
      description: "A command to check if the bot is alive"
    }
  end

  @impl Command
  def handle_interaction(interaction) do
    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        contents: "Ping by slash command",
      }
    })
  end
end
