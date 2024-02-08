defmodule Mark.Test.MessageComponent.AgentTest do
  alias Mark.MessageComponent.Agent
  alias Mark.MessageComponent

  use ExUnit.Case

  setup_all do
    {
      :ok,
      %{
        button: MessageComponent.new(data: %{
            style: Mark.Constant.ButtonStyle.primary(),
            label: "hello",
          },
          handle: fn interaction ->
            nil
          end
        ),
        select_menu: MessageComponent.new(data: %{
            placeholder: "Menu",
            min_values: 1,
            max_values: 1,
            options: [
              %{
                label: "first",
                value: "first",
                description: "description",
              },
              %{
                label: "second",
                value: "second",
                description: "description",
              },
            ],
          },
          handle: fn interaction ->
            nil
          end
        ),
        modal: MessageComponent.new(data: %{}, handle: fn interaction -> nil end),
        interaction: nil,
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
end
