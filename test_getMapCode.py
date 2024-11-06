from getMapCode import getMapCode
import unittest
import os

class TestGetMapCode(unittest.TestCase):

    def test_returnsCorrectCode(self):
        lat = -18.26
        long = -39.24
        expected_code = 'SE-24-Y-B'
        map_code = getMapCode(lat,long,'scn_250k.gpkg')

        errorMessage = 'getMapCode returned incorrect code:\n%s was expected, \
            returned %s instead'%(expected_code,map_code)
        self.assertEqual(map_code,expected_code,errorMessage)
      

if __name__ == '__main__':
    unittest.main()