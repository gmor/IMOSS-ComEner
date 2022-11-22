# IMOSS-ComEner
Curs de gestió de comunitats energètiques 2022 a l'Institut Municipal de l'Ocupació Salvador Seguí de Lleida.

## Com instal·lar-ho?

### Programari necessari

El primer pas és instal·lar els seguents programes al vostre ordinador (en els links trobareu l'accés directe a la descàrrega del programa en Windows, en cas d'utilitzar Mac o Linux, busqueu l'equivalent adient que podeu trobar a les mateixes webs):

- [R](https://cran.r-project.org/bin/windows/base/R-4.2.2-win.exe)
- [Rstudio](https://download1.rstudio.org/desktop/windows/RStudio-2022.07.2-576.exe)
- [Pandoc](https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-windows-x86_64.msi)
- [SAM](https://sam.nrel.gov/download/66-sam-2021-12-02-for-windows/file.html)


### Instal·lar les llibreries

Un cop tingueu instal·lat el programari al vostre sistema, heu d'obrir Rstudio i executar les seguents comandes:
```
install.packages( c("devtools","ggplot2", "data.table", "lubridate", "plotly", "dygraphs", "tidyr", "htmltools", "xts", "viridis", "ggExtra") )
devtools::install_github("mcanigueral/dutils")
```
Aquest codi només l'heu d'executar un cop. A partir de que ho tingueu tot instal·lat, ja us funcionarà l'execució de la llibreta d'anàlisi.

## Utilització de la llibreta d'anàlisi

S'ha de descarregar el repositori a través del botó verd "Clone..." d'aquesta web (en la part superior dreta) i descarregar el zip. Un cop tingueu en el vostre ordinador el fitxer, descomprimir-lo a la carpeta que desitjeu i executar la llibreta utilitzant els executadors depenent del vostre sistema operatiu. Per exemple, en el cas de Windows 7/10/11, fer doble click a sobre de *executar_windows.cmd*.

Aquest executable generarà un fitxer anomenat Veure_Resultats.nb.html que es totalment portable i podeu moure i compartir amb qui vulgueu. Per exemple, el podeu compartir amb un disc portable, correu electrònic o emmagatzematge al núvol. El motiu d'instal·lació de tot el programari i les llibreries és que pogueu analitzar i visualitzar els resultats específics de la comunitat energètica del vostre interés. Els vostres fitxers de dades els heu de col·locar dins de la carpeta Dades d'aquest repositori en local.

