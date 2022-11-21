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

args_pvgis <- function(arg){
  list(
      "Latitud"="lat"
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
  )[[arg]]
  }