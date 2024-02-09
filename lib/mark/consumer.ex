defmodule Mark.Consumer do
  @moduledoc false
  use Nostrum.Consumer

  require Logger
  alias Mark.MessageComponent

  alias Mark.Commands

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    IO.puts("On ready")
    Commands.register_commands()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    case interaction.type do
      2 ->
        Commands.handle_interaction(interaction)

      3 ->
        custom_id =
          interaction.message.components
          |> List.first()
          |> Map.get(:components)
          |> List.first()
          |> Map.get(:custom_id)

        case MessageComponent.Agent.trigger(custom_id, interaction) do
          :error -> Logger.error("Error in message component handling")
          :remove -> MessageComponent.Agent.remove_component(custom_id)
          _ -> nil
        end
    end
  end

  def handle_event(_data) do
    :ok
  end
end
