import sys
from db_helpers import create_category_from_json

""" Create a new category from a json file 

 Run with command-line argument of json file path
"""

create_category_from_json(sys.argv[1])