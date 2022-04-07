import json
from os.path import exists

""" Short script to easily create json files for new categories from the command-line
    Does not add avatarURLs
"""

class Category:
    def __init__(self, name, coverPicURL=""):
        self._name = name
        self._coverPicURL = coverPicURL
        self._competitors = []
    
    def add_competitor(self, name, avatarURL=""):
        new = {
            "name": name,
            "avatarURL": avatarURL
        }
        self._competitors.append(new)
    
    def toJson(self):
        return {
            "name": self._name,
            "coverPicURL": self._coverPicURL,
            "competitors": self._competitors
        }


while True:
    category_name = input("name: ")
    new_fp = "new_categories/{}.json".format(category_name)
    if exists(new_fp):
        print("Sorry, that category name already exists. Please use a unique name")
    else:
        break

new_category = Category(category_name)
while True:
    print("Add a new competitor")
    comp_name = input("name: ")
    new_category.add_competitor(comp_name)
    cont = input("Would you like to  add another competitor? (y/n): ").lower()
    if cont in ("n", "no", "no "):
        break

with open(new_fp, "w") as fp:
    json.dump(new_category.toJson(), fp)