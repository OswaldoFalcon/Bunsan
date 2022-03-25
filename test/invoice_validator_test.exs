defmodule InvoiceValidatorTest do
  use ExUnit.Case

  test "Comparacion de zonas preubas mías" do
    # Prueba cuando esta 5 min + 1 segundo en el futuro la emision
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-23 09:05:01], "Mexico/BajaNorte")
    assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validator_dates(emisor, pac)
    # Prueba cunado esta 5 min -1 en el futuro la emsion
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-23 09:04:59], "Mexico/BajaNorte")
    assert :ok == InvoiceValidator.validator_dates(emisor, pac)
    # Prueba cuando esta 5 minutos en el futuro la emision
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-23 09:05:00], "Mexico/BajaNorte")
    assert :ok == InvoiceValidator.validator_dates(emisor, pac)
    # Prueba cuando son 72 horas pasadas de emision
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-20 09:00:00], "Mexico/BajaNorte")
    assert :ok == InvoiceValidator.validator_dates(emisor, pac)
    # Pureba cuando son  72 horas + 1 segundo pasadas de emision
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-20 08:59:59], "Mexico/BajaNorte")
    assert {:error, "Invoice pass the 72 hr "} == InvoiceValidator.validator_dates(emisor, pac)
    # Prueba cuando son  72 horas -1 segundo 
    pac = InvoiceValidator.zona(~N[2022-03-23 10:00:00], "Mexico/General")
    emisor = InvoiceValidator.zona(~N[2022-03-20 09:00:01], "Mexico/BajaNorte")
    assert :ok == InvoiceValidator.validator_dates(emisor, pac)
  end

  test "Facturacion Valores de Prueba" do
    ######################## # 72 horas atras ##############################
    # America/Tijuana
    timbrado = InvoiceValidator.zona(~N[2022-03-23 15:06:35], "Mexico/General")
    emision = InvoiceValidator.zona(~N[2022-03-20 13:06:31], "America/Tijuana")
    assert {:error, "Invoice pass the 72 hr "} == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/Sinaloa"
    emision = InvoiceValidator.zona(~N[2022-03-20 14:06:31], "America/Mazatlan")
    assert {:error, "Invoice pass the 72 hr "} == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/CDMX"
    emision = InvoiceValidator.zona(~N[2022-03-20 15:06:31], "Mexico/General")
    assert {:error, "Invoice pass the 72 hr "} == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/QROO"
    emision = InvoiceValidator.zona(~N[2022-03-20 16:06:31], "America/Cancun")
    assert {:error, "Invoice pass the 72 hr "} == InvoiceValidator.validator_dates(emision, timbrado)
    # America/Tijuana se corrigio este ya que daban 73 horas y no era valido, 
    emision = InvoiceValidator.zona(~N[2022-03-20 14:06:35], "America/Tijuana")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # America Sinaloa
    emision = InvoiceValidator.zona(~N[2022-03-20 14:06:35], "America/Tijuana")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # America /CDMX
    emision = InvoiceValidator.zona(~N[2022-03-20 15:06:35], "Mexico/General")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/QROO"
    emision = InvoiceValidator.zona(~N[2022-03-20 16:06:35], "America/Cancun")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)

    ######################## # 5mins adelante  ############################## 
    # America/Tijuana
    emision = InvoiceValidator.zona(~N[2022-03-23 13:11:35], "America/Tijuana")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/Sinaloa"
    emision = InvoiceValidator.zona(~N[2022-03-23 14:11:35], "America/Mazatlan")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # America /CDMX
    emision = InvoiceValidator.zona(~N[2022-03-23 15:11:35], "Mexico/General")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/QROO"
    emision = InvoiceValidator.zona(~N[2022-03-23 16:11:35], "America/Cancun")
    assert :ok == InvoiceValidator.validator_dates(emision, timbrado)
    # America/Tijuana se corrigio porque se estaba considerando con una hora de mas a tijuana
    emision = InvoiceValidator.zona(~N[2022-03-23 14:11:36], "America/Tijuana")
    assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/Sinaloa"
    emision = InvoiceValidator.zona(~N[2022-03-23 14:11:36], "America/Mazatlan")
    assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validator_dates(emision, timbrado)
    # America /CDMX
    emision = InvoiceValidator.zona(~N[2022-03-23 15:11:36], "Mexico/General")
    assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validator_dates(emision, timbrado)
    # "America/QROO"
    emision = InvoiceValidator.zona(~N[2022-03-23 16:11:36], "America/Cancun")
    assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validator_dates(emision, timbrado)
  end
end
