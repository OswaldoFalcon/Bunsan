defmodule CalculatorApi do
  @moduledoc """
  This calcultor, uses process to calculate,
  trough  message passing. But using an API  
  """
  def init() do
    spawn(fn -> calc(0) end)
  end

  def sum(pid, val), do: send(pid, {:sum, val})
  def sub(pid, val), do: send(pid, {:sub, val})
  def mult(pid, val), do: send(pid, {:mult, val})
  def div(pid, val), do: send(pid, {:div, val})

  def state(pid) do
    send(pid, {:state, self()})

    receive do
      {:state, val} -> val
      _ -> :error
    end
  end

  defp calc(current_value) do
    receive do
      {:sum, value} ->
        current_value + value

      {:sub, value} ->
        current_value - value

      {:mult, value} ->
        current_value * value

      {:div, value} ->
        current_value / value

      {:state, pid} ->
        send(pid, {:state, current_value})
        current_value

      _ ->
        IO.puts("Invalid request")
    end
    |> calc()
  end
end
