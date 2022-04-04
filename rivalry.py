
class Rivalry():
    def __init__(self, item1ID, item2ID):
        self._itemIDs = [item1ID, item2ID]
        self._votes = {}
        self._votes[item1ID] = 0
        self._votes[item2ID] = 0

    def set_id(self, id):
        self._rid = id

    def toMap(self):
        return {
            'itemIDs': self._itemIDs,
            'votes': self._votes
        }