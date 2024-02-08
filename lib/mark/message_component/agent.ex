defmodule Mark.MessageComponent.Agent do
  use Agent

  alias Mark.MessageComponent

  @spec start_link(map()) :: Agent.on_start()
  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end


  def value do
    Agent.get(__MODULE__, &(&1))
  end

  def add_listener(id, listener) do
    Agent.update(__MODULE__, &Map.put(&1, id, listener))
  end



  @spec add_component(MessageComponent.t()) :: nil
  def add_component(%MessageComponent{data: data, handle: handle}) do
    add_listener(data.custom_id, handle)
  end

  def trigger(id, interaction) do
    Agent.get(__MODULE__, fn x ->
      listener = Map.get(x, id)
      if listener do
        listener.(interaction)
        :ok
      else
        :error
      end
    end)
  end
end
