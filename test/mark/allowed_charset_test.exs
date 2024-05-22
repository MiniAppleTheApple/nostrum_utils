defmodule Mark.Test.AllowedCharset do
  alias Mark.AllowedCharset

  use ExUnit.Case
  
  test "Does &all/0 really has all?" do
    all = AllowedCharset.all()
    assert all |> AllowedCharset.has(AllowedCharset.english())
    assert all |> AllowedCharset.has(AllowedCharset.chinese())
    assert all |> AllowedCharset.has(AllowedCharset.japanese())
    assert all |> AllowedCharset.has(AllowedCharset.korean())
    assert all |> AllowedCharset.has(AllowedCharset.special_symbols())
    assert all |> AllowedCharset.has(AllowedCharset.number())
  end

  test "Does &none/0 really has none" do
    none = AllowedCharset.none()
    assert not (none |> AllowedCharset.has(AllowedCharset.english()))
    assert not (none |> AllowedCharset.has(AllowedCharset.chinese()))
    assert not (none |> AllowedCharset.has(AllowedCharset.japanese()))
    assert not (none |> AllowedCharset.has(AllowedCharset.korean()))
    assert not (none |> AllowedCharset.has(AllowedCharset.special_symbols()))
    assert not (none |> AllowedCharset.has(AllowedCharset.number()))
  end

  test "To settings" do
    assert AllowedCharset.all() |> AllowedCharset.to_settings() == %{
      english: true,
      chinese: true,
      japanese: true,
      korean: true,
      special_symbols: true,
      number: true,
    }
  end
end
