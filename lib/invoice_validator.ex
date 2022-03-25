defmodule InvoiceValidator do
    def validator_dates(%DateTime{} = emisor_date, %DateTime{} = pac_date ) do
        dif_h = DateTime.diff(pac_date, emisor_date) /60 /60
        dif_m = DateTime.diff(emisor_date, pac_date) /60
        cond do
            DateTime.compare(emisor_date,pac_date) == :gt ->
                cond do
                        dif_m <= 5 -> :ok
                        dif_m > 5 -> {:error, "Invoice is more than 5 mins ahead in time"}
                end
            DateTime.compare(emisor_date,pac_date) == :lt ->
                cond do
                    dif_h <= 72 -> :ok
                    dif_h > 72 -> {:error, "Invoice pass the 72 hr "}
                end
            DateTime.compare(emisor_date,pac_date) == :eq -> {:ok, "your in the same time"}
        end
    end
    #	~N[2018-10-28 02:30:00], "Mexico/BajaNorte"
    #   ~N[2018-10-28 02:30:00], "Mexico/General"
    def zona(%NaiveDateTime{} = date, zona), do: DateTime.from_naive!(date,zona,Tzdata.TimeZoneDatabase)
    
end