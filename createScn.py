import csv
from shapely.geometry import Polygon
import geopandas as gpd
import enum

class Scale(enum.Enum):
    scale1m = {'depth':2,'name':'1m'}
    scale500 = {'depth':3,'name':'500k'}
    scale250 = {'depth':4,'name':'250k'}
    scale100 = {'depth':5,'name':'100k'}
    scale50 = {'depth':6,'name':'50k'}
    scale25 = {'depth':7,'name':'25k'}

for scale in Scale:
    depth = scale.value['depth']
    name = scale.value['name']

    geom_dict = {}
    with open('scn_list.txt') as file:
        reader = csv.reader(file,)
        for row in reader:
            if row[0][0] == '#':
                continue
            map_code = row[1].strip()
            code_depth = len(map_code.split('-'))
            coords = (float(row[2]),float(row[3]))
            #print('map_code = %s; depth = %s'%(map_code,code_depth))
            if code_depth == depth:
                if not geom_dict.get(map_code):
                    geom_dict[map_code] = []
                geom_dict[map_code].append(coords)

    data = {'code':[],'geometry':[]}
    for map_code in geom_dict.keys():
        polygon = Polygon(geom_dict[map_code])
        data['code'].append(map_code)
        data['geometry'].append(polygon)

    geodf = gpd.GeoDataFrame(data, crs='EPSG:4326')
    geodf.to_file('scn_%s.gpkg'%name)