defmodule TestNum do
  @moduledoc """
  TestNum Module is uses Wards for filter the input
  """
  def test(x) when is_number(x) and x < 0 do
    :negative
  end

  def test(0) do
    :zero
  end

  def test(x) when is_number(x) and x > 0 do
    :positive
  end
end
