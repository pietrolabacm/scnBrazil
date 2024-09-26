from shapely.geometry import Point
from getMapCode import getMapCode

p1 = Point(-39.24,-18.26)
expected_code = 'SE-24-Y-B-III'

map_code = getMapCode(p1)
assert map_code == expected_code