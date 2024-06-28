defmodule NostrumUtils.Listeners do
  use Agent

  alias Nostrum.Struct.Interaction

  @type trigger_result() :: :ok | :error | :remove | {:add_listener, [{String.t(), handler()}]}
  @type handler() :: (Interation.t() -> trigger_result())

  @spec start_link(map()) :: Agent.on_start()
  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  @spec add_listener(String.t(), handler()) :: :ok
  def add_listener(id, listener) do
    Agent.update(__MODULE__, &Map.put(&1, id, listener))
  end

  @spec trigger(String.t(), Interaction.t()) :: trigger_result()
  def trigger(id, interaction) do
    Agent.get(__MODULE__, fn x ->
      listener = Map.get(x, id)

      if listener do
        listener.(interaction)
      else
        :error
      end
    end)
  end

  def remove_listener(id) do
    Agent.update(__MODULE__, fn x ->
      x
      |> Map.delete(id)
    end)
  end
end
