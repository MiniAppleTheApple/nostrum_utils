defmodule Mark.Test.MessageComponent.AgentTest do
  alias Mark.MessageComponent.Agent
  alias Mark.MessageComponent

  use ExUnit.Case

  setup_all do
    button = MessageComponent.new(data: %{
        style: Mark.Constant.ButtonStyle.primary(),
        label: "hello",
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
            :ok
          end
        ),
        modal: MessageComponent.new(data: %{}, handle: fn interaction -> :ok end),
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

  test "Remove listener", %{button: button, interaction: interaction} do
    Agent.start_link(%{})
    id = button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(button)
    Agent.remove_component(button)
    assert Agent.trigger(id, interaction) == :error
  end

  test "If return :remove after triggered, remove the listener ", %{self_destroy_button: self_destroy_button, interaction: interaction} do
    Agent.start_link(%{})
    id = self_destroy_button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(self_destroy_button)
    assert Agent.trigger(id, interaction) == :remove
    assert Agent.trigger(id, interaction) == :error
  end

  test "Remove listener after triggered", %{self_destroy_button: self_destroy_button, interaction: interaction} do
    Agent.start_link(%{})
    id = self_destroy_button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(self_destroy_button)
    Agent.trigger(id, interaction)
    assert Agent.trigger(id, interaction) == :error
  end

  test "Listener can be triggered unlimited by default", %{button: button, interaction: interaction} do
    Agent.start_link(%{})
    id = button.data.custom_id
    Agent.start_link(%{})
    Agent.add_component(button)
    assert Agent.trigger(id, interaction) == :ok
    assert Agent.trigger(id, interaction) == :ok
  end
end
