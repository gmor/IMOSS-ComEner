read_datadis_files <- function(files, only_real_values=T){
  raw_dfs <- do.call(
    rbind,
    lapply(
      files,
      function(d){
        aux <- fread(d,data.table = F)
        if(only_real_values){
          aux <- aux %>% filter(metodoObtencion=="Real")
        }
        if(nrow(aux)>0){
          data.frame(
            "NIF" = strsplit(tail(strsplit(d,"/")[[1]],1),"_")[[1]][1],
            "CUPS" = aux$cups,
            "time" = force_tz(parsedate::parse_date( paste(aux$fecha,
                            sprintf("%02i:%02i",
                                    as.numeric(mapply(function(i)i[1],strsplit(aux$hora,":")))-1,
                                    as.numeric(mapply(function(i)i[2],strsplit(aux$hora,":")))
                            ))),tzone = "Europe/Madrid"),
            "consumption" = as.numeric(gsub(",","\\.",aux$consumo_kWh))
          )
        }
      }
    )
  )
  raw_dfs
}

read_edistribucion_files <- function(files, only_real_values=T){
  raw_dfs <- do.call(
    rbind,
    lapply(
      files,
      function(d){
        aux <- fread(d,data.table = F,dec=",")
        if(only_real_values){
          aux <- aux %>% filter(`REAL/ESTIMADO`=="R")
        }
        if(nrow(aux)>0){
          data.frame(
            "NIF" = strsplit(tail(strsplit(d,"/")[[1]],1),"_")[[1]][1],
            "CUPS" = aux$CUPS,
            "time" = force_tz(as.POSIXct(
              paste(aux$Fecha,
               sprintf("%02i:00",
                       aux$Hora-1)),
              format="%d/%m/%Y %H:%M"),tzone = "Europe/Madrid"),
            "consumption" = aux$AE_kWh
          )
        }
      }
    )
  )
  raw_dfs
}
  
  
args_pvgis <- function(arg){
  translations <- list(
      "Latitud"="lat",
      "Longitud"="lon",
      "ElevacioTerreny"="usehorizon",
      "Ombres"="UserHorizon",
      "PotenciaFV"="peakpower",
      "TecnologiaFV"="pvtechchoice",
      "MuntatgeFV"="mountingplace",
      "Perdues"="loss",
      "InclinacioFV"="angle",
      "AzimutRespecteSud"="aspect"
      # lat	F	Yes	-	Latitude, in decimal degrees, south is negative.
      # lon	F	Yes	-	Longitude, in decimal degrees, west is negative.
      # usehorizon	I	No	1	Calculate taking into account shadows from high horizon. Value of 1 for "yes".
      # userhorizon	L	No	-	Height of the horizon at equidistant directions around the point of interest, in degrees. Starting at north and moving clockwise. The series '0,10,20,30,40,15,25,5' would mean the horizon height is 0° due north, 10° for north-east, 20° for east, 30° for south-east, etc.
      # raddatabase	T	No	
      # default DB Name of the radiation database. "PVGIS-SARAH" for Europe, Africa and Asia or "PVGIS-NSRDB" for the Americas between 60°N and 20°S, "PVGIS-ERA5" and "PVGIS-COSMO" for Europe (including high-latitudes), and "PVGIS-CMSAF" for Europe and Africa (will be deprecated)
      # peakpower	F	Yes	-	Nominal power of the PV system, in kW.
      # pvtechchoice	T	No	"crystSi"	PV technology. Choices are: "crystSi", "CIS", "CdTe" and "Unknown".
      # mountingplace	T	No	"free"	Type of mounting of the PV modules. Choices are: "free" for free-standing and "building" for building-integrated.
      # loss	F	Yes	-	Sum of system losses, in percent.
      # fixed	I	No	1	Calculate a fixed mounted system. Value of 0 for "no". All other values (or no value) mean "Yes". Note that this means the default is "yes".
      # angle	F	No	0	Inclination angle from horizontal plane of the (fixed) PV system.
      # aspect	F	No	0	Orientation (azimuth) angle of the (fixed) PV system, 0=south, 90=west, -90=east.
      # optimalinclination	I	No	0	Calculate the optimum inclination angle. Value of 1 for "yes". All other values (or no value) mean "no".
      # optimalangles	I	No	0	Calculate the optimum inclination AND orientation angles. Value of 1 for "yes". All other values (or no value) mean "no".
      # inclined_axis	I	No	0	Calculate a single inclined axis system. Value of 1 for "yes". All other values (or no value) mean "no".
      # inclined_optimum	I	No	0	Calculate optimum angle for a single inclined axis system. Value of 1 for "yes". All other values (or no value) mean "no".
      # inclinedaxisangle	F	No	0	Inclination angle for a single inclined axis system. Ignored if the optimum angle should be calculated (parameter "inclined_optimum").
      # vertical_axis	I	No	0	Calculate a single vertical axis system. Value of 1 for "yes". All other values (or no value) mean "no".
      # vertical_optimum	I	No	0	Calculate optimum angle for a single vertical axis system. Value of 1 for "yes". All other values (or no value) mean "no".
      # verticalaxisangle	F	No	0	Inclination angle for a single vertical axis system. Ignored if the optimum angle should be calculated (parameter "vertical_optimum" set to 1).
      # twoaxis	I	No	0	Calculate a two axis tracking system. Value of 1 for "yes". All other values (or no value) mean "no".
      # pvprice	I	No	0	Calculate the PV electricity price [kwh/year] in the currency introduced by the user for the system cost.
      # systemcost	F	if pvprice	-	Total cost of installing the PV system [your currency].
      # interest	F	if pvprice	-	Interest in %/year
      # lifetime	I	No	25	Expected lifetime of the PV system in years.
  )
  if(arg %in% names(translations)){
    return(translations[[arg]])
  } else {
    return(arg)
  }
}

pvgis_get_hourly_data <- function (years=2019:2020, scenario) {
  nameField <- scenario[["NomCampFV"]]
  scenario <- scenario[!(names(scenario) %in% "NomCampFV")]
  url <- paste0(
    "https://re.jrc.ec.europa.eu/api/v5_2/seriescalc?",
    "outputformat=json&raddatabase=PVGIS-SARAH2&usehorizon=1&",
    "startyear=",min(years),"&endyear=",max(years),"&pvcalculation=1&",
    paste(mapply(function(i){
      paste0(args_pvgis(names(scenario)[i]),"=",scenario[[i]])},1:length(scenario)),
      collapse="&"))
  response <- httr::GET(url)
  content <- httr::content(response)
  timeseries <- as.data.frame(
    do.call(rbind,lapply(content$outputs$hourly,function(i){unlist(i)})))
  timeseries <- data.frame(
    "time" = as.POSIXct(
      timeseries$time, format = "%Y%m%d:%H%M", tz="UTC") - minutes(70),
    "generation" = as.numeric(timeseries$P)/1000)
  
  return(list("name"=nameField,"inputs"=content$inputs,"output"=timeseries))
}

pvgis_download_scenarios <- function(scenarios){
  
  total_generation <- do.call(rbind,
    lapply(scenarios,function(scenario){
      pvgis_results <- pvgis_get_hourly_data(2020, scenario)$output
      sun_position <- as.data.frame(do.call(cbind,
                                            oce::sunAngle(pvgis_results$time,scenario$Longitud,
                                                          scenario$Latitud,T)))[,c("time","azimuth","altitude")]
      sun_position$time <- as.POSIXct(sun_position$time,
                                      origin=as.POSIXct("1970-01-01 00:00:00",tz="UTC"),tz = "UTC")
      pvgis_results <- pvgis_results %>% left_join(sun_position, by="time")
      pvgis_results$NomCampFV <- scenario$NomCampFV
      pvgis_results
    }
    ))
  total_generation$time <- with_tz(total_generation$time,"Europe/Madrid")
  aggregated_generation <- total_generation %>% group_by(time) %>%
    summarise(generation = sum(generation,na.rm=T),
              azimuth = mean(azimuth,na.rm=T),
              altitude = mean(altitude,na.rm=T)) %>%
    ungroup() %>% mutate(NomCampFV="TotalFV")
  total_generation <- rbind(total_generation, aggregated_generation)
  
  return(total_generation)
}
