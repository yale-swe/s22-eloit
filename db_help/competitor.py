from item import Item

class Competitor:

    def __init__(self, item, cid, eloScore=1400):
        self._item = item
        self._item.add_category(cid)
        self._eloScore = 1400

    def set_id(self, id):
        self._id = id

    def get_id(self):
        return self._id

    def get_name(self):
        return self._item.get_name()

    def toMap(self):
        return {
            "item": self._item.toMap(),
            "eloScore": self._eloScore
        }
