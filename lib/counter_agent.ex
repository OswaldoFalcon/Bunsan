defmodule CounterAgent do
  @moduledoc """
  The CounterAgent Module uses Agents to Count
  """
  use Agent

  def start(init_val) do
    Agent.start(fn -> init_val end)
  end

  def value(pid) do
    Agent.get(pid, & &1)
  end

  def inc(pid) do
    Agent.update(pid, &(&1 + 1))
  end
end
