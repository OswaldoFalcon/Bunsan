
defmodule Mylist do

    #Funcion each
    def each([x], fun) do
        [h | _] = [x]
        fun.(h)
    end
    def each([h | t], fun) do
        IO.puts(fun.(h))
        each(t, fun)
    end

    #2.Funcion Map
    def map([], _), do: []
    def map([h | t], fun), do: [fun.(h) | map(t, fun)]

    #3. reduce/3 (con acumulador)
    def reduce([], acc, _), do: acc
    def reduce([h | t], acc, fun), do: reduce(t, fun.(h, acc), fun)  

    #4. zip/2 
    def zip([], _), do: [] 
    def zip(_, []), do: [] 
    def zip([h1 | t1], [h2 | t2]), do: [ {h1, h2} | zip(t1, t2) ]

    #5. zip_with/3
    def zip_with([], _, _), do: [] 
    def zip_with(_, [], _), do: [] 
    def zip_with([h1 | t1], [h2 | t2], fun), do: [ fun.(h1, h2) | zip_with(t1, t2, fun) ]
end