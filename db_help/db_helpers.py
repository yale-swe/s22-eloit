import firebase_admin
from firebase_admin import credentials, firestore
from item import Item
from rivalry import Rivalry
from competitor import Competitor
import json

""" Several functions to help set up and manage the database

Most useful functions: 
        - create_category_from_json(path)
        - reset_all_rivalry_votes(cid)
        - delete_all_rivalries(cid)
"""

# These links not important. Only use elo_db and elo_URL when working w/ Eloit
test_db = "practice-9893e-firebase-adminsdk-24nzu-ac333cd9ad.json"
test_URL = "https://practice-9893e.firebaseio.com/"

elo_db = "eloit-c4540-firebase-adminsdk-ery03-a3130de872.json"
elo_URL = "https://eloit-c4540.firebaseio.com/"

cred = credentials.Certificate(elo_db) # test_db or elo_db here
firebase_admin.initialize_app(cred, 
{
"databaseURL": elo_db, #test_URL or elo_URL here
}) 
db = firestore.client()

def id_to_name(comp_id):
    """ Translates a competitor id (str) to a competitor name (str) """
    items_ref = db.collection("items")
    query_result = items_ref.where(u"iid", u"==", comp_id).get()[0]
    return query_result.get("name")


def reset_all_rivalry_votes(cid):
    """ Resets the votes to 0 for both competitors for all rivalries in a given category
    
    Arguments:
        cid (str): The category id
    """
    rivs_ref = db.collection("categories/{0}/rivalries".format(cid))
    rivalries = rivs_ref.get()
    for riv in rivalries:
        reset_riv_votes(cid, riv)

def reset_riv_votes(riv_doc):
    votes = riv_doc.get("votes")
    new_votes = {}
    for id in votes.keys():
        new_votes[id] = 0
    ref = riv_doc.reference
    update = {
        "votes": new_votes
    }
    ref.set(update, merge = True)



def delete_all_rivalries(cid):
    """ Deletes all of the rivalries from the given category. Use for resetting the database.
        
    Args:
        cid (str): The category ID
    """
    rivs_ref = db.collection("categories/{0}/rivalries".format(cid))
    rivalries = rivs_ref.get()
    for riv in rivalries:
        riv.reference.delete()

def cat_exists(cid):
    """ Checks if a cid already exists in the database """
    existing_cats = db.collection("categories").get()
    existing_cids = [x.id for x in existing_cats]
    if cid in existing_cids:
        return True
    else:
        return False

def initialize_matchups(lst, cid, images):
    """" Creates all of the possible rivalries given a list of the users
    Initializes the items, then initializes all Competitors
    and Rivalries in the database

    Arguments:
        lst (List[str]): The list of competitor names
        cid (str): The category id
        images (Dict[str, str]): list of the avatarURLs with the name as keys and URLs as values
    """
    items_ref = db.collection("items")
    rivs_ref = db.collection("categories/{0}/rivalries".format(cid))
    comps_ref = db.collection("categories/{0}/competitors".format(cid))
    # These lists are just for bookkeeping
    competitors = [] 
    rivalries = []

    if not cat_exists(cid):
        raise ValueError("Category ID does not already exist in the database.")

    for name in lst:
        new_it = None
        new_it_doc = None
        # If the item already exists in the database, just use the existing one
        query_result = items_ref.where("name", "==", name).get()
        if len(query_result) != 0:
            new_it = Item.fromDocumentSnapshot(query_result[0])
            new_it._avatarURL = images[name]
            doc_id = query_result[0].id
            new_it_doc = db.document("items/{}".format(doc_id))
            print("{0} Already existed".format(new_it._name))
        else:
            new_it = Item(name, avatarURL=images[name])
            new_it_doc = items_ref.document()
            new_it.set_id(new_it_doc.id)
        new_comp = Competitor(new_it, cid)
        new_comp_doc = comps_ref.document(new_it_doc.id)
        new_comp.set_id(new_comp_doc.id)

        for comp in competitors:
            new_rivalry = Rivalry(cid, comp.get_id(), new_comp.get_id(), comp.get_name(), new_comp.get_name())
            rivs_ref.add(new_rivalry.toMap())
            rivalries.append(new_rivalry)
        
        new_it_doc.set(new_it.toMap())
        new_comp_doc.set(new_comp.toMap())
        competitors.append(new_comp)


def initialize_matchups_from_json(obj, cid):
    """ Calls initialize_matchups (see above) but takes in only a json object and the cid

    Args:
        obj (json): A json object representing the category. Has 'name' (str), 'avatarURL' (str), and a 'competitors' array
        cid (str): The category ID

    """
    competitors = obj.get("competitors")
    images = {x.get("name"):x.get("avatarURL") for x in competitors}
    names = list(images.keys())
    initialize_matchups(names, cid, images)


def create_new_category_doc(name, coverPicURL=None):
    """ Inserts a new document into the categories collection in the database and returns its id """
    if coverPicURL is None:
        coverPicURL = ""
    
    cats_ref = db.collection("categories")
    new_data = {
        "name": name,
        "searchKey": name.lower(),
        "coverPicURL": coverPicURL
    }
    new_doc = cats_ref.document()
    new_doc.set(new_data)
    return new_doc.id


def create_category_from_json(path):
    """ Creates and initializes a new category fully given a json file

    Args: 
        path (str): The path to the json file which contains all of the necessary data to set up a category, its
        competitors and its rivalries--see some sample files in the 'new_categories' folder.
    """
    with open(path) as f:
        data_obj = json.load(f)
    name = data_obj.get("name")
    coverPicURL = data_obj.get("coverPicURL")
    new_cid = create_new_category_doc(name, coverPicURL=coverPicURL)
    initialize_matchups_from_json(data_obj, new_cid)


if __name__ == "__main__":
    # can call functions here
    create_category_from_json("./new_categories/test.json")
    #pass
