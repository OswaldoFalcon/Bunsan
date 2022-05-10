defmodule DataDrivenTest do
  use ExUnit.Case

  data = [
    {1, 3, 4},
    {7, 4, 11},
    {8, 9, 17},
    {5, 2, 7},
    {10, 3, 13},
    # Error intencional
    {11, 11, 22}
  ]

  for {a, b, c} <- data do
    @a a
    @b b
    @c c
    test "sum of #{@a} and #{@b} should equal #{@c}" do
      assert SUT.sum(@a, @b) == @c
    end
  end
end
