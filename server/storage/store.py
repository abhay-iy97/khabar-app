from pymongo import MongoClient
from pprint import pprint
from bson.objectid import ObjectId


class Storage:
    def __init__(self):
        self.client = MongoClient('localhost', 27017)
        self.db = self.client.news_collection

    def insert_json(self, news_json):
        db_id = self.db.insert_one(news_json).inserted_id
        print(db_id)
        print(self.db.list_collection_names())

    def retrieve_url(self, url):
        pprint.pprint(self.db.find_one({'url': ObjectId(url)}))

    def bulk_insert(self, list_of_jsons):
        result = self.db.insert_many(list_of_jsons)

    @staticmethod
    def retrieve_many(self, items):
        for item in items.find():  # Cursor instance
            pprint.pprint(item)

    @staticmethod
    def index_url(self, url):  # Indexing Create it for urls so that they're not inserted multiple times into the db.
        result = 2
