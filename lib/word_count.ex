defmodule WordCount do
    def count(path) do
    {:ok, text} = File.read(path)
    #se usa Sigils para poder elinar los caracteres especiales, pero mantener letras y numeros#
    list_words = String.downcase(text) |> String.normalize(:nfd) |> String.replace(~r/[^0-9A-z\s]/u, "") |> String.split(" ")
    # Ahora el  acumulador es un mapa y vamos agregando llaves 
    list_words|> Enum.reduce(%{}, fn palabra, acc_mapa -> Map.update(acc_mapa, palabra, 1, fn palabra -> palabra + 1 end) end)
    end
end

    