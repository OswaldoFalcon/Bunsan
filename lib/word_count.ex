defmodule WordCount do
    def frequencies_tasks(path) do
        map_in_parts=path
        |> File.stream!()
        |> Enum.chunk_every(1_000)
        |> Enum.map(fn lines -> Task.async(fn -> count(Enum.join(lines)) end) end)
        |> Enum.map(fn task -> Task.await(task) end)

        # Join the maps
        # Use a map to add the sum of words.
        Enum.reduce(map_in_parts, %{}, fn map, acc ->  
        # Merge the map acc and the next map
            Map.merge(map, acc, fn _k, word1, word2->
               word1+word2
            end)
        end)
      end
    def count(path) do
    {:ok, text} = File.read(path)
    #se usa Sigils para poder elinar los caracteres especiales, pero mantener letras y numeros#
    list_words = String.downcase(text) |> String.normalize(:nfd) |> String.replace(~r/[^0-9A-z\s]/u, "") |> String.split(" ")
    # Ahora el  acumulador es un mapa y vamos agregando llaves 
    list_words|> Enum.reduce(%{}, fn palabra, acc_mapa -> Map.update(acc_mapa, palabra, 1, fn palabra -> palabra + 1 end) end)
    end
end

    