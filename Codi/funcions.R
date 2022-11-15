read_datadis_files <- function(files){
  raw_dfs <- do.call(
    rbind,
    lapply(
      files,
      function(d){
        aux <- fread(d,data.table = F)
        aux <- aux %>% filter(metodoObtencion=="Real")
        data.frame(
          "NIF" = strsplit(tail(strsplit(d,"/")[[1]],1),"_")[[1]][1],
          "CUPS" = aux$cups,
          "time" = as.POSIXct( paste(aux$fecha,
                          sprintf("%02i:%02i",
                                  as.numeric(substr(aux$hora,1,2))-1,
                                  as.numeric(substr(aux$hora,4,5)))),
                          format="%Y/%m/%d %H:%M", tz="Europe/Madrid"),
          "consumption" = as.numeric(gsub(",","\\.",aux$consumo_kWh))
        )
      }
    )
  )
  raw_dfs
}
