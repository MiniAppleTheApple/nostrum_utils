defmodule Mark.Test.ListenersTest do
  alias Mark.Util
  alias Mark.Listeners

  alias Nostrum.Struct.Component.Button

  alias Nostrum.Constants.ButtonStyle

  use ExUnit.Case

  setup_all do
    button = Button.interaction_button("Hello", Util.random_id(), style: ButtonStyle.primary())
    {
      :ok,
      %{
        button: button,
        handle: fn _interaction -> {:ok, []} end,
        interaction: nil
      }
    }
  end

  test "Add button listener to the agent", %{button: button, interaction: interaction} do
    id = button.data.custom_id
    Listeners.start_link(%{})
    Listeners.add_listener(id, button.handle)
    assert Listeners.trigger(id, interaction) == {:ok, []}
  end

  test "Trigger the undefined listener", %{interaction: interaction} do
    Listeners.start_link(%{})
    assert Listeners.trigger("id", interaction) == :error
  end

  test "Remove listener", %{button: button, interaction: interaction} do
    Listeners.start_link(%{})
    id = button.data.custom_id
    Listeners.start_link(%{})
    Listeners.add_listener(id, button.handle)
    Listeners.remove_listener(id)
    assert Listeners.trigger(id, interaction) == :error
  end

  test "Listener can be triggered unlimited by default", %{
    button: button,
    interaction: interaction
  } do
    Listeners.start_link(%{})
    id = button.data.custom_id
    Listeners.start_link(%{})
    Listeners.add_listener(id, button.handle)
    assert Listeners.trigger(id, interaction) == {:ok, []}
    assert Listeners.trigger(id, interaction) == {:ok, []}
  end
end
