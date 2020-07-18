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
    keyword = query_parameters.get('keyword')
    if not (country or lang or src or category or keyword):
        return page_not_found
    return country, lang, src, category, keyword


def object_creation():
    format = Format()
    storage = Storage()
    spidey = Crawler()
    return format, storage, spidey


@app.errorhandler(404)
def page_not_found(e):
    return "<h1>404</h1><p>The resource could not be found.</p>", 404


@app.route('/', methods=['GET'])
def home():
    print('hit home')
    return '<h1>Welcome to Abhay\'s repo.</h1><p>Take what you want :)</p>'


@app.route('/api/v1/news/topheadlines', methods=['GET'])  # country is a mandatory query parameter
def extract_top_headlines():  # Returns top headlines of a country
    print('extract top headlines')
    country, lang, src, category, keyword = setup(request)
    formatter, storage, spidey = object_creation()
    headlines = spidey.news_top_headlines(country)
    json_articles = formatter.extract_url(headlines)
    return jsonify(json_articles)


@app.route('/api/v1/news/category', methods=['GET'])  # country and category are mandatory query parameters
def extract_categorical():
    print('extract categorical')
    country, lang, src, category, keyword = setup(request)
    formatter, storage, spidey = object_creation()
    headlines = spidey.news_categories(country, category)
    json_articles = formatter.extract_url(headlines)
    return jsonify(json_articles)


@app.route('/api/v1/news/allsources', methods=['GET'])  # country and lang are mandatory query parameters
def extract_all_language_sources():  # Returns a list of all news sources for a given language and country
    print('extract sources based on languages')
    country, lang, src, category, keyword = setup(request)
    formatter, storage, spidey = object_creation()
    src_language = spidey.lang_sources(lang, country)
    return jsonify(src_language)


@app.route('/api/v1/news/source', methods=['GET'])  # src is a mandatory parameter
def extract_source_news():  # Returns news for a particular news source
    print('extract headlines of a news source')
    country, lang, src, category, keyword = setup(request)
    formatter, storage, spidey = object_creation()
    src_headlines = spidey.news_source_headlines(src)
    json_articles = formatter.extract_url(src_headlines)
    return jsonify(json_articles)


@app.route('/api/v1/news/query', methods=['GET'])  # keyword is a mandatory query parameter, lang is optional
def extract_keyword():  # Returns news data for a keyword
    print('extract keyword')
    country, lang, src, category, keyword = setup(request)
    formatter, storage, spidey = object_creation()
    if lang:
        headlines = spidey.keyword_based(keyword, lang)
    else:
        headlines = spidey.keyword_based(keyword)
    json_articles = formatter.extract_url(headlines)
    return jsonify(json_articles)


app.run()
