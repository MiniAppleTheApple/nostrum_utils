defmodule NostrumUtils.Command do
  @moduledoc """
  Behaviour for application command implementations.
  """
  alias Nostrum.Struct.Interaction
  defstruct [:spec, :handle_interaction]

  @type t() :: %__MODULE__{spec: map(), handle_interaction: (Interaction.t() -> :ok | {:error, atom()})}
end
