defmodule Mark.Consumer.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [Mark.Consumer, {Mark.DB, nil}]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule Mark.DB do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def save(data) do
    Agent.update(__MODULE__, fn _ -> data end)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end
end
