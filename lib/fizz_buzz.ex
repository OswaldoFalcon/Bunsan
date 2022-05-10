defmodule FizzBuzz do
  @moduledoc """
  The FizzBuzz Module prints Fizz when n is multiple 3 , 
  Buzz when n multiple is 5
  and FizzBuzz when is multiple of 3 and 5
  """
  def imprime(x) do
    # Crea una secuencia de 1 -- hasta n #
    n = 1..x

    Enum.each(n, fn y ->
      cond do
        rem(y, 3) == 0 and rem(y, 5) == 0 -> IO.puts("FizzBuzz")
        rem(y, 3) == 0 -> IO.puts("Fizz")
        rem(y, 5) == 0 -> IO.puts("Buzz")
        true -> IO.puts(y)
      end
    end)
  end
end
