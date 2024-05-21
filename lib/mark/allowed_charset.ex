defmodule Mark.AllowedCharset do
  import Bitwise

  # constants

  def english(), do: 1 <<< 0
  def chinese(), do: 1 <<< 1
  def japanese(), do: 1 <<< 2
  def korean(), do: 1 <<< 3
  def number(), do: 1 <<< 4
  def special_symbols(), do: 1 <<< 5

  def map() do
    %{
      english: english(),
      chinese: chinese(),
      japanase: japanese(),
      korean: korean(),
      number: number(),
      special_symbols: special_symbols(),
    }
  end

  def none(), do: 0
  def default(), do: none()

  def all() do
    map()
    |> Map.values()
    |> Enum.reduce(default(), &add/2)
  end

  def add(allowed, charset) do
    allowed ||| charset
  end
end
