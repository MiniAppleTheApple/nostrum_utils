defmodule Elppa.Consumer do
  @moduledoc false
  use Nostrum.Consumer

  alias Nostrum.Api

  alias Elppa.Commands

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    IO.puts("On ready")
    Commands.register_commands()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    if interaction.type == 3 do
      Api.create_interaction_response!(interaction, %{
        type: 4,
        data: %{
          content: "<@#{interaction.data.custom_id}>",
        }
      })
    else
      Commands.handle_interaction(interaction)
    end
  end

  def handle_event(_data) do
    :ok
  end
end
