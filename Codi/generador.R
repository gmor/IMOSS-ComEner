library(data.table)
library(jsonlite)
library(lubridate)
library(ggplot2)

df1 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/046644274443a8c3f4c4c4ceb291276f05e6c940a162bb411f867617d0c89d5c_EnergyConsumptionGridElectricity.json")[[1]]
df1$value<-(df1$value)*8/max(df1$value)
NIF1 <- "V15411202"
CUPS1 <- "ES001241506180691661QD0Z"

df2 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/0c758d9bdadb8222dbd5a107113c249c7001077be944251af6f31b7d480f241a_EnergyConsumptionGridElectricity.json")[[1]]
df2$value<-(df2$value)*3/max(df2$value)
NIF2 <- "V87511202"
CUPS2 <- "ES066241506180691661QD0H"

df3 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/0f18fc295dd61d79b9b4dfc3644fca6d31052ced976d3ff561c5b7d1a702a584_EnergyConsumptionGridElectricity.json")[[1]]
df3$value<-(df3$value)*10/max(df3$value)
NIF3 <- "V11551202"
CUPS3 <- "ES007241511280691661QD0Z"

df4 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/102702fa23f8c51eea8dfe2588cb96d29af73ad5d91da6d18d872444732395c1_EnergyConsumptionGridElectricity.json")[[1]]
df4$value<-(df4$value)*4/max(df4$value)
NIF4 <- "B65411202"
CUPS4 <- "ES000241506180691661QBFD"

df5 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/16b63f78c811be9be0307121c356294036fb48a247fc67a2380afd19b27d3a1f_EnergyConsumptionGridElectricity.json")[[1]]
df5$value<-(df5$value)*12/max(df5$value)
NIF5 <- "Z55411202"
CUPS5 <- "ES001241506180691661QMMM"

df6 <- fromJSON("~/GitHub/biggr/data/20_buildings_with_tariff/1ea71c77eace4a4f4309ff8a896e77de54fd3816f28d00b3d624ab1a47f25691_EnergyConsumptionGridElectricity.json")[[1]]
df6$value<-(df6$value)*5/max(df6$value)
NIF6 <- "V15671223"
CUPS6 <- "ES006743503780691661QCVS"

for (i in 1:6){
  aux <- eval(parse(text=paste0("df",i)))
  aux$start <- as.POSIXct(substr(aux$start,1,19),tz = "UTC",
                          format="%Y-%m-%dT%H:%M:%S")
  aux$start <- with_tz(aux$start, "Europe/Madrid")
  aux$fecha <- format(aux$start-3600,"%Y/%m/%d",tz = "Europe/Madrid")
  aux$hora <- sprintf("%02i:00",
                      ifelse(hour(aux$start)==0, 24,
                      hour(aux$start)))
  aux_t <- data.frame(
    "cups"=eval(parse(text=paste0("CUPS",i))),
    "fecha"=aux$fecha,
    "hora"=aux$hora,
    "consumo_kWh"=gsub("\\.","\\,",round(aux$value,2)),
    "metodoObtencion"=ifelse(aux$isReal,"Real","Estimada"),
    "energiaVertida_kWh"="NULL"
    )
  write.table(aux_t, paste0("~/GitHub/IMOSS-ComEner/Demanda/input/datadis",
                            eval(parse(text=paste0("NIF",i))),
                            "_1.csv"),
              quote = F,row.names = F,col.names = T,sep=";"
              )
}

