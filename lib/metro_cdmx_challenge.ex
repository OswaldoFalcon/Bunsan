defmodule MetroCdmxChallenge do

    defmodule Station do
        defstruct [:name, :coords ]     
    end

    defmodule Line do
        defstruct [:name, :stations]
    end

    def metrolines(path) do #  "./data/metro.kml"
        import SweetXml
        #cargamos el archivo
        xml = File.read!(path)
        #declaramos variables con los datos de KML
        coord_line = xml |> xpath(~x"//Document/Folder[1]/Placemark/LineString/coordinates/text()"sl) 
        coord_line = coord_line|> Enum.map(fn x -> x
        |> String.trim()
        |> String.replace([" "], "")
        |> String.split("\n") 
        end)
        line_name = xml |> xpath(~x"//Document/Folder[1]/Placemark/name/text()"sl)
        station_name = xml |> xpath(~x"//Document/Folder[2]/Placemark/name/text()"sl)
        coord_station = xml |> xpath(~x"//Document/Folder[2]/Placemark/Point/coordinates/text()"sl) 
        |> Enum.map(fn x -> String.replace(x,["\n", " "], "")
        end) #estaciones coordenadas
        
        #creamos un mapa con las coordenadas como "key" y nombre de estacion como "value"
        station_coord = Enum.zip(coord_station, station_name) |> Map.new()
        #Creamos un mapa con el nombre de linea "key" y las coordenadas ordenadas "values"
        line_coord = Enum.zip(line_name, coord_line) |> Map.new() 
        #Ahora  buscamos el nombre de la estacion con la coordenada 
        line_coord |> Enum.map(fn {k, v} -> 
            Enum.map(v, fn coordenada ->  
            %Line{name: k, stations: %Station{name: station_coord[coordenada], coords: coordenada} } 
            end)
        end)
    end
    
    def metro_graph (path) do
        #usamos el resultado de metrolines
        linea = metrolines(path)

        # se crea un lista de las esatciones adyacentes
        linea_coord_lista = linea|> Enum.map(fn x -> x 
        |> Enum.map(fn st -> st.stations.name end)
        end)
        #chunkeamos en parejas las estaciones adyacentes
        chunkeado = linea_coord_lista |> Enum.map(fn x -> x
        |> Enum.chunk_every(2, 1, :discard) # puede que no halla pares, entonces tomamos el ultimo
        end) 
        #chunkeamos todo junto#
        chunkeado = List.flatten(chunkeado) |> Enum.chunk_every(2)

        #creamos el grafo
        graph = Graph.new(type: :undirected)
        #agregamos los pares al grafo 
        chunkeado|> Enum.reduce(graph, fn ypair,graph -> 
        Graph.add_edge(graph,List.first(ypair),List.last(ypair)) 
        end) 
    end
end