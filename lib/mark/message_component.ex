defmodule Mark.MessageComponent do
  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Interaction

  @type t :: %__MODULE__{}
  @type data :: Component.t()
  @type handle :: (Interaction.t() -> nil)

  @id_length 98
  @id_possible_characters ~c"1234567890abcdefghijklmnopqrstuvwABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-+"

  defstruct [
    :handle,
    data: %Component{}
  ]

  def random_id do
    0..@id_length
    |> Enum.map(fn _x -> Enum.random(@id_possible_characters) end)
    |> to_string()
  end

  @spec new(data: data(), handle: handle()) :: t()
  def new(data: data, handle: handle),
    do: %__MODULE__{data: data |> Map.put_new(:custom_id, random_id()), handle: handle}
end
