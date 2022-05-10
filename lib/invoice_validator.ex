defmodule InvoiceValidator do
  @moduledoc """
  This Module recives 2 dates and compares including Timzones 
  - When the emisor date is ahead in time. 
  - When passes 72 hours before the pac date.
  - Or when both are equal. 
  """
  def validator_dates(%DateTime{} = emisor_date, %DateTime{} = pac_date) do
    dif_h = DateTime.diff(pac_date, emisor_date) / 60 / 60
    dif_m = DateTime.diff(emisor_date, pac_date) / 60

    cond do
      DateTime.compare(emisor_date, pac_date) == :gt ->
        cond do
          dif_m <= 5 -> :ok
          dif_m > 5 -> {:error, "Invoice is more than 5 mins ahead in time"}
        end

      DateTime.compare(emisor_date, pac_date) == :lt ->
        cond do
          dif_h <= 72 -> :ok
          dif_h > 72 -> {:error, "Invoice pass the 72 hr "}
        end

      DateTime.compare(emisor_date, pac_date) == :eq ->
        {:ok, "your in the same time"}
    end
  end
end
