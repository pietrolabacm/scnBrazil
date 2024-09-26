from getMapCode import getMapCode
from shapely.geometry import Point

p1 = Point(-39.24,-18.26)
expected_code = 'SE-24-Y-B'

map_code = getMapCode(p1,'scn_250k.gpkg')
assert map_code == expected_code