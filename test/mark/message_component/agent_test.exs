defmodule Mark.Test.MessageComponent.AgentTest do
  alias Mark.MessageComponent.Agent
  alias Mark.MessageComponent

  use ExUnit.Case

  setup_all do
    button =
      MessageComponent.new(
        data: %{
          style: Mark.Constant.ButtonStyle.primary(),
          label: "hello"
        },
        handle: fn interaction ->
          :ok
        end
      )

    {
      :ok,
      %{
        button: button,
        self_destroy_button: button |> Map.put(:handle, fn interaction -> :remove end),
        interaction: nil
      }
    }
  end

  test "Add button listener to the agent", %{button: button, interaction: interaction} do
    id = button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(button)
    assert Agent.trigger(id, interaction) == :ok
  end

  test "Trigger the undefined listener", %{interaction: interaction} do
    Agent.start_link(%{})
    assert Agent.trigger("id", interaction) == :error
  end

  test "Remove listener", %{button: button, interaction: interaction} do
    Agent.start_link(%{})
    id = button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(button)
    Agent.remove_listener(id)
    assert Agent.trigger(id, interaction) == :error
  end

  test "Listener can be triggered unlimited by default", %{
    button: button,
    interaction: interaction
  } do
    Agent.start_link(%{})
    id = button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(button)
    assert Agent.trigger(id, interaction) == :ok
    assert Agent.trigger(id, interaction) == :ok
  end
end
