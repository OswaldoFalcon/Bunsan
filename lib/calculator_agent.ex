defmodule CalculatorAgent do
  
  @moduledoc """
  This module is a Calculator. Each state representes 
  a total count.
  """
    
  def init(init_val) do
    {_, pid} = Agent.start(fn -> init_val end)
    pid
  end

  def sum(pid, val), do: calc({pid, :sum, val})
  def sub(pid, val), do: calc({pid, :sub, val})
  def mult(pid, val), do: calc({pid, :mult, val})
  def div(pid, val), do: calc({pid, :div, val})
  def state(pid), do: calc({pid, :state})

  defp calc(operation) do
    case operation do
      {pid, :sum, val} -> Agent.update(pid, &(&1 + val))
      {pid, :sub, val} -> Agent.update(pid, &(&1 - val))
      {pid, :mult, val} -> Agent.update(pid, &(&1 * val))
      {pid, :div, val} -> Agent.update(pid, &(&1 / val))
      {pid, :state} -> Agent.get(pid, & &1)
      _ -> IO.puts("Invalid request")
    end
  end
end
