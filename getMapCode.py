from shapely.geometry import Point, shape
import fiona


def getMapCode(vector, scn='scn_100k.gpkg'):
    shapePath = scn
    map_code_list = []
    with fiona.open(shapePath) as shapefile:
        for feature in shapefile:
            if not feature.geometry:
                continue
            featureGeometry = shape(feature.geometry)
            if p1.within(featureGeometry):
                map_code = feature.properties.get('code')
                map_code_list.append(map_code)
        if len(map_code_list) == 1:
            return map_code_list[0]
        elif len(map_code_list)>1:
            print('ATTENTION\nVector fits in more than one polygon')
            return map_code_list
        else:
            print('No map code found, is the Vector inside the shapefile area')