
class Rivalry():
    def __init__(self, cid, item1ID, item2ID, item1Name, item2Name):
        self._cid = cid
        self._itemIDs = [item1ID, item2ID]
        self._votes = {}
        self._votes[item1ID] = 0
        self._votes[item2ID] = 0
        self._name = item1Name.lower() + 'vs.' + item2Name.lower()

    def set_id(self, id):
        self._rid = id

    def toMap(self):
        return {
            'cid': self._cid,
            'itemIDs': self._itemIDs,
            'name': self._name,
            'votes': self._votes
        }