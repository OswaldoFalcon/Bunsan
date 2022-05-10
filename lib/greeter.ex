defmodule Greeter do
  @moduledoc """
  The Greeter Module, recives a remitent and pid and sends a message
  """
  def greet() do
    receive do
      {who, pid} -> send(pid, "Hello #{who} from #{inspect(self())}")
      _ -> IO.puts("uh??")
    end

    greet()
  end
end
