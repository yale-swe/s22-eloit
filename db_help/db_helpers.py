import firebase_admin
from firebase_admin import credentials, firestore
from item import Item
from rivalry import Rivalry
from competitor import Competitor

""" Key functions: 
        - reset_all_rivalry_votes(cat_id)
        - delete_all_rivalries(cat_id)
        - initialize_matchups(lst, cat_id, images)
"""

cred = credentials.Certificate("eloit-c4540-firebase-adminsdk-ery03-a3130de872.json")
firebase_admin.initialize_app(cred, 
{
"databaseURL": "https://eloit-c4540.firebaseio.com/",
}) 
db = firestore.client()

def find_rivalry(cat_id, c1, c2):
    #TODO
    rivs_ref = db.collection("categories/{0}/rivalries".format(cat_id))
    query_result = rivs_ref.where(u"itemIDs", u"array_contains", c1).where(u"itemIDs", u"array_contains", c2)
    print(query_result.get())

""" Translates a competitor id to a competitor name """
def id_to_name(comp_id):
    items_ref = db.collection("items")
    query_result = items_ref.where(u"iid", u"==", comp_id).get()[0]
    return query_result.get("name")

""" For each rivalry, reset the votes to 0 for both competitors
parameters: 
    - cat_id : String (the category id)
"""
def reset_all_rivalry_votes(cat_id):
    rivs_ref = db.collection("categories/{0}/rivalries".format(cat_id))
    rivalries = rivs_ref.get()
    for riv in rivalries:
        reset_riv_votes(cat_id, riv)

def reset_riv_votes(cat_id, riv_doc):
    votes = riv_doc.get("votes")
    new_votes = {}
    for id in votes.keys():
        new_votes[id] = 0
    ref = riv_doc.reference
    update = {
        "votes": new_votes
    }
    ref.set(update, merge = True)


""" Deletes all of the rivalries from the given category. Use for resetting the database 
parameters: 
    - cat_id : String (The category ID)
"""
def delete_all_rivalries(cat_id):
    rivs_ref = db.collection("categories/{0}/rivalries".format(cat_id))
    rivalries = rivs_ref.get()
    for riv in rivalries:
        riv.reference.delete()

"""" Creates all of the possible rivalries given a list of the users
Initializes the items if they do not already exist, then initializes all Competitors (also if they do not exist)
and Rivalries (creates new rivalries even if they already exist) in the database
parameters:
    - lst : List<String> (list of competitor names)
    - cat_id : String (category id)
    - images : dict (list of the avatarURLs with the name as keys and URLs as values)
"""
def initialize_matchups(lst, cat_id, images):
    items_ref = db.collection("items")
    rivs_ref = db.collection("categories/{0}/rivalries".format(cat_id))
    comps_ref = db.collection("categories/{0}/competitors".format(cat_id))
    competitors = []
    rivalries = [] # just for bookkeeping

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
        new_comp = Competitor(new_it, cat_id)
        new_comp_doc = comps_ref.document(new_it_doc.id)
        new_comp.set_id(new_comp_doc.id)

        for comp in competitors:
            new_rivalry = Rivalry(comp.get_id(), new_comp.get_id())
            rivs_ref.add(new_rivalry.toMap())
            rivalries.append(new_rivalry)
        
        new_it_doc.set(new_it.toMap())
        new_comp_doc.set(new_comp.toMap())
        competitors.append(new_comp)


if __name__ == "__main__":
    # full_lst = ["Iron Man", "Captain America", "Hulk", "Hawkeye", "Black Widow", "Thor"]
    # images = {
    #     "Iron Man": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Firon_man.png?alt=media&token=d34ae294-ded4-414e-9843-978f524e0d13",
    #     "Captain America": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Fcaptain_america.png?alt=media&token=7e8850b2-b6da-444f-8453-d4afaf490fea",
    #     "Hulk": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Fhulk.png?alt=media&token=ded32566-7e73-47b9-aba0-204f9bec2e84",
    #     "Hawkeye": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Fhawkeye.png?alt=media&token=4bf9c79c-e0ae-48a7-aab0-2150243f6f44",
    #     "Black Widow": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Fblack_widow.png?alt=media&token=cee2182f-ab5d-4765-849a-cd546a9bb171",
    #     "Thor": r"https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Fthor.png?alt=media&token=00e8d0da-6ea3-4468-9340-6fb71100363e"
    # }
    # cat_id = "9A7IO38o2kHDRXDgSIhb" 
    # initialize_matchups(full_lst, cat_id, images)
    comp_id = "1iFXUfSk9J8wLI8oE5QZ"
    print(id_to_name(comp_id))
