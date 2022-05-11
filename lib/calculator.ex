defmodule Calculator do
  @moduledoc """
  This module recives a mmessage, and do differents operations
  """
  def init(n) do
    state =
      receive do
        {:sum, num, pid} ->
          send(pid, {:state, n + num})
          n + num

        {:mult, num, pid} ->
          send(pid, {:state, n * num})
          n * num

        {:sub, num, pid} ->
          send(pid, {:state, n - num})
          n - num

        {:div, num, pid} ->
          send(pid, {:state, n / num})
          n / num

        _ ->
          IO.puts("really bru...???")
      end

    init(state)
  end
end
