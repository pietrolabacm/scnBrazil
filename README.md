#SCN Brazil
This is a collection of scripts to create vectors that display the Sistema Cartográfico Nacional Brasileiro (SCN) and identify in which of the Map Sheets a geometry is located.

To create the vectors use:
```
python createScn.py
```
Six geopackages containing the different scales of the SCN will be created

To find the map code of a geometry use the function getMapCode; Example:
```
from getMapCode import getMapCode
from shapely.geometry import Point
p1 = Point(-39.24,-18.26)
#Here we will provide the 250k scn as the 100k is selected by default
map_code = getMapCode(p1,scn='scn_250k.gpkg')
print(map_code)
#'SE-24-Y-B'
```
