defmodule InvoiceValidatorTest do
  use ExUnit.Case
  import InvoiceValidator
  
  @timbrado DateTime.from_naive!(~N[2022-03-23 15:06:35],"Mexico/General",Tzdata.TimeZoneDatabase)
  data= [
    {"72 hours before", "America/Tijuana", ~N[2022-03-20 13:06:31], "FAIL passes 72 limit"},
    {"72 hours before", "America/Mazatlan", ~N[2022-03-20 14:06:31],"FAIL passes 72 limit"},
    {"72 hours before", "Mexico/General", ~N[2022-03-20 15:06:31], "FAIL passes 72 limit" },
    {"72 hours before", "America/Cancun", ~N[2022-03-20 16:06:31], "FAIL passes 72 limit" },
    {"72 hours before", "America/Tijuana", ~N[2022-03-20 14:06:35], "SUCCESS on time" }, #tijuana Hora corregida
    {"72 hours before", "America/Mazatlan", ~N[2022-03-20 14:06:35], "SUCCESS on time" }, #Sinaloa
    {"72 hours before", "Mexico/General", ~N[2022-03-20 15:06:35], "SUCCESS on time" }, #CDMX
    {"72 hours before", "America/Cancun", ~N[2022-03-20 16:06:35], "SUCCESS on time" }, #QROO
    {"5 mins ahead", "America/Tijuana", ~N[2022-03-23 13:11:35], "SUCCESS on time" }, #tijuana
    {"5 mins ahead", "America/Mazatlan", ~N[2022-03-23 14:11:35], "SUCCESS on time" }, #Sinaloa
    {"5 mins ahead", "Mexico/General", ~N[2022-03-23 15:11:35], "SUCCESS on time" }, #CDMX
    {"5 mins ahead", "America/Cancun", ~N[2022-03-23 16:11:35], "SUCCESS on time" }, #QROO
    {"5 mins ahead", "America/Tijuana", ~N[2022-03-23 14:11:36], "FAIL yu are more 5 mins ahead" }, #corrigio porque se estaba considerando con una hora de mas a tijuana
    {"5 mins ahead", "America/Mazatlan", ~N[2022-03-23 14:11:36], "FAIL yu are more 5 mins ahead" }, #Sinaloa 
    {"5 mins ahead", "Mexico/General", ~N[2022-03-23 15:11:36], "FAIL yu are more 5 mins ahead" }, #CDMX
    {"5 mins ahead", "America/Cancun", ~N[2022-03-23 16:11:36], "FAIL yu are more 5 mins ahead" }, #QROO
  ]

  for {time, em_zn, em_dt, msg} <- data do
    @time time
    @em_zn em_zn
    @em_dt em_dt
    @msg msg

    case @time do
      "72 hours before" ->
        case @msg do
          "FAIL passes 72 limit" ->
            test "#{@time}, emisor in #{@em_zn} at #{@em_dt} returns #{@msg}" do
              assert {:error, "Invoice pass the 72 hr "} == validator_dates(zona_f(@em_dt, @em_zn), @timbrado)
            end
          "SUCCESS on time" -> 
            test "#{@time}, emisor in #{@em_zn} at #{@em_dt} returns #{@msg}" do
              assert :ok == validator_dates(zona_f(@em_dt, @em_zn), @timbrado)
              end      
        end
        
      "5 mins ahead" -> 
        case @msg do
          "SUCCESS on time" ->
            test "#{@time}, emisor in #{@em_zn} at #{@em_dt} returns #{@msg}" do
              assert :ok == validator_dates(zona_f(@em_dt, @em_zn), @timbrado)
              end 
            "FAIL yu are more 5 mins ahead" ->
              test "#{@time}, emisor in #{@em_zn} at #{@em_dt} returns #{@msg}" do
                assert {:error, "Invoice is more than 5 mins ahead in time"} == validator_dates(zona_f(@em_dt, @em_zn), @timbrado)
                end 
        end
    end
  end

   defp zona_f(%NaiveDateTime{} = date, zona), do: DateTime.from_naive!(date,zona,Tzdata.TimeZoneDatabase) 
end
