defmodule ProcessRing do
    def init(n) do
        #1..3 |> Enum.map(fn _ -> spawn(fn -> send(parent, {:ok,self()}) end)end)
      pids = Enum.map(1..n, fn _ -> spawn(&wait_for_config/0) end)
      next_pids = Enum.drop(pids, 1) ++ [hd(pids)]
      ring_config = Enum.zip(pids, next_pids)
  
      ring_config
      |> hd()
      |> then(fn {pid, next} -> send(pid, {:config, next, true}) end)
  
      ring_config
      |> Enum.drop(1)
      |> Enum.each(fn {pid, next_pid} ->
        send(pid, {:config, next_pid, false})
      end)
      hd(pids)
    end
  
    def rounds(pid, msg, n) do #ring = ProcessRing.init(5) # ProcessRing.rounds(ring,"holi",3)
        
    end
  
    def wait_for_config() dox
      receive do
        {:config, next_pid, main} ->
          IO.puts("pid: #{inspect(self())}, next: #{inspect(next_pid)} main: #{main}")
          process_msg(next_pid, main)
        _ -> :ok
      end
    end
  
    def process_msg(next, main) do
      receive do
        {msg, n} ->
          IO.puts("Process #{inspect(self())} received message \"#{msg}\", round #{n}")
          cond do 
           # n > 0 and n !=1 -> send(next, {msg, n})
            main and n > 0 and n !=1 -> send(next, {msg, n-1})
            main and n -> :ok
            true -> send(next, {msg, n})
          end
        _ -> :ok
      end
      process_msg(next, main)
    end
  end

