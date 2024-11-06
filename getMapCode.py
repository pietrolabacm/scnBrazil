from shapely.geometry import shape, Point
import fiona
import os

def getMapCode(lat:float,long:float, scn='scn_100k.gpkg'):
    '''Returns the map code of a point from given latitude and longitude 
    according to the Sistema Cartográfico Nacional Brasileiro.

    :param lat: Latitude
    :type lat: float
    :param long: Longitude
    :type long: float
    :param scn: Path to the file storing the codes polygons, defaults to 'scn_100k.gpkg'
    :type scn: str, optional
    :return: Map code according to the SCNB
    :rtype: string
    '''
    if not os.path.isfile(scn):
        if scn == 'scn_100k.gpkg':
            raise FileNotFoundError(
                "Map Code polygons file not found\nRun 'python createScn.py' to create the files needed to use the getMapCode function")
        else:
            raise FileNotFoundError('Map Code polygons file not found\nDoes the file %s exists?'%scn)
            
    point = Point(long,lat)
    map_code_list = []
    with fiona.open(scn) as shapefile:
        for feature in shapefile:
            if not feature.geometry:
                continue
            featureGeometry = shape(feature.geometry)
            if point.within(featureGeometry):
                map_code = feature.properties.get('code')
                map_code_list.append(map_code)
        if len(map_code_list) == 1:
            return map_code_list[0]
        elif len(map_code_list)>1:
            print('ATTENTION\nVector fits in more than one polygon')
            return map_code_list
        else:
            print('No map code found, is the Vector inside the shapefile area')