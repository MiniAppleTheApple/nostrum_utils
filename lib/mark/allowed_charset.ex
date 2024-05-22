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
      english: {english(), "英文"},
      chinese: {chinese(), "中文"},
      japanese: {japanese(), "日文"},
      korean: {korean(), "韓文"},
      number: {number(), "數字"},
      special_symbols: {special_symbols(), "特殊符號"},
    }
  end

  def none(), do: 0
  def default(), do: all()

  def all() do
    map()
    |> Map.values()
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(none(), &add/2)
  end

  def has(bit, charset), do: (bit &&& charset) == charset

  def to_settings(bit) do
    map()
    |> Enum.map(fn {key, {value, _text}} ->
      {key, has(bit, value)}
    end)
    |> Enum.into(%{})
  end

  def add(allowed, charset) do
    allowed ||| charset
  end
end
