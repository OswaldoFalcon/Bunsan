defmodule MylisTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Funcion each/2 sumando " do
    fun = fn -> assert Mylist.each([0, 2, 4], fn x -> x + 1 end) == 5 end
    assert capture_io(fun) == "1\n3\n"
  end

  test "funcion map/2 sumando" do
    assert Mylist.map([2, 3, 4], fn x -> x + 1 end) == [3, 4, 5]
  end

  test "Funcion reduce/3 sumador " do
    assert Mylist.reduce([1, 2, 3, 4, 5], 1, fn x, a -> x + a end) == 16
  end

  test "Funcion Zip/2 " do
    assert Mylist.zip([1, 2, 3], [1, 2, 3]) == [{1, 1}, {2, 2}, {3, 3}]
  end

  test "Funcion zip_with" do
    assert Mylist.zip_with([1, 2, 3], [1, 2, 3], fn x, y -> x + y end) == [2, 4, 6]
  end
end
