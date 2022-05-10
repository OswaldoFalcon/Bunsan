defmodule FizzBuzzTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Funcion Imprime/2 15 " do
    fun = fn -> assert FizzBuzz.imprime(15) == :ok end

    assert capture_io(fun) ==
             "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n"
  end

  test "Funcion Imprime/2 5 " do
    fun = fn -> assert FizzBuzz.imprime(5) == :ok end
    assert capture_io(fun) == "1\n2\nFizz\n4\nBuzz\n"
  end
end
