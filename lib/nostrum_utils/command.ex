defmodule NostrumUtils.Command do
  @moduledoc """
  Behaviour for application command implementations.
  """
  alias Nostrum.Struct.Interaction
  
  @doc """
  Used to define the spec for the command to be used for command registration.
  See https://hexdocs.pm/nostrum/application-commands.html for more info on the
  required shape for the spec.
  """
  @callback spec(name :: String.t()) :: map()

  @doc """
  Called when the command is invoked.
  """
  @callback handle_interaction(Interaction.t()) :: any()
end
