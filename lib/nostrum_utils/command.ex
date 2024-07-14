defmodule NostrumUtils.Command do
  @moduledoc """
  Behaviour for application command implementations.
  """
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.ApplicationCommandInteractionDataOption
  defstruct [:spec, :handle_interaction]

  @type t() :: %__MODULE__{spec: map(), handle_interaction: (Interaction.t(), ApplicationCommandInteractionDataOption.t() -> :ok | {:error, atom()})}
end
