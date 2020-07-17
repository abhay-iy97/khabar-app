from __future__ import absolute_import
import flask
from flask import request, jsonify
from server.storage.store import Storage
from server.crawler.crawler import Crawler
from server.tools.format import Format

app = flask.Flask(__name__)
app.config['DEBUG'] = True


def setup(url_request):
    query_parameters = url_request.args
    country = query_parameters.get('country')
    lang = query_parameters.get('lang')
    src = query_parameters.get('source')
    category = query_parameters.get('category')
    if not (country or lang or src or category):
        return page_not_found
    return country, lang, src, category


@app.errorhandler(404)
def page_not_found(e):
    return "<h1>404</h1><p>The resource could not be found.</p>", 404


@app.route('/', methods=['GET'])
def home():
    print('hit home')
    return '<h1>Welcome to Abhay\'s repo.</h1><p>Take what you want :)</p>'


@app.route('/api/v1/news/topheadlines', methods=['GET'])
def extract_top_headlines():  # Country is a mandatory parameter
    print('extract top headlines')
    country, lang, src, category = setup(request)
    storage = Storage()  # DO I need so many objects? static?
    spidey = Crawler()
    formatter = Format()
    headlines = spidey.news_top_headlines(country)
    json_articles = formatter.extract_url(headlines)
    return jsonify(json_articles)


@app.route('/api/v1/news/category', methods=['GET'])
def extract_categorical():  # Country and category are mandatory parameters
    print('extract categorical')
    country, lang, src, category = setup(request)
    storage = Storage()  # DO I need so many objects? static?
    spidey = Crawler()
    formatter = Format()
    headlines = spidey.news_categories(country, category)
    json_articles = formatter.extract_url(headlines)
    return jsonify(json_articles)


@app.route('/api/v1/news/language', methods=['GET'])
def extract_language_sources():  # Will update.
    print('extract sources based on languages')
    country, lang, src, category = setup(request)
    spidey = Crawler()
    formatter = Format()
    src_language = spidey.lang_sources(lang, country)
    news_data = format.extract_source(src_language)
    # TO BE COMPLETED.


app.run()
