
class Item():
    
    def __init__(self, name, avatarURL="", catIDs = None):
        self._name = name
        self._avatarURL = avatarURL
        if catIDs is not None:
            self._categoryIDs = catIDs
        else:
            self._categoryIDs = []

    def add_category(self, cid):
        self._categoryIDs.append(cid)

    def set_id(self, id):
        self._id = id

    def get_id(self):
        return self._id
    

    def fromDocumentSnapshot(doc):
        new = Item(doc.get("name"), doc.get("avatarURL"), doc.get("categoryIDs"))
        new.set_id(doc.id)
        return new

    def toMap(self):
        return {
            "iid": self._id,
            "name": self._name,
            "avatarURL": self._avatarURL,
            "categoryIDs": self._categoryIDs
        }