defmodule Greeter do

  def greet() do
    receive do
      {who, pid} -> send(pid, "Hello #{who} from #{inspect(self())}")
      _ -> IO.puts("uh??")
    end
    greet()
  end
end