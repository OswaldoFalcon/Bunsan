defmodule FizzBuzz do
    def imprime(x) do
        n = 1..x   # Crea una secuencia de 1 -- hasta n #
        Enum.each(n, fn y -> 
            cond do 
                rem(y,3) == 0 and rem(y,5) == 0 -> IO.puts("FizzBuzz") 
                rem(y,3) == 0 -> IO.puts("Fizz")  
                rem(y,5) == 0 -> IO.puts("Buzz") 
                true -> IO.puts(y)
            end
         end )
    end
end