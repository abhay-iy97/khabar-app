import logging
from newsapi import NewsApiClient


class Crawler:
    def __init__(self):
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger()
        f = open('server\\crawler\\key.txt', 'r')
        key = eval(f.read())
        self.newsapi = NewsApiClient(api_key=key['NewsAPIKey'])

    def news_top_headlines(self, country):  # HIDE API KEY.
        try:
            top_headlines = self.newsapi.get_top_headlines(country=country)
            return top_headlines
        except Exception as e:
            self.logger.error(e.message)
        # outfile = open('data//topHeadlines//' + country + '.json', 'w') // PUT IN DB
        # json.dump(data, outfile)

    def news_categories(self, country, category):
        try:
            category_url = self.newsapi.get_top_headlines(country=country, category=category)
            return category_url
        except Exception as e:
            self.logger.error(e.message)
        # INSERT IN DB

    def news_sources(self, source, country):
        try:
            news_source_url = self.newsapi.get_top_headlines(country=country, sources=source)
            return news_source_url
            # outfile = open(location + '//' + source + '.json', 'w')   //INSERT in DB or cache
            # json.dump(data, outfile)
        except Exception as e:
            self.logger.error(e.message)

    def lang_sources(self, language, country):
        try:
            lang_url = self.newsapi.get_sources(country=country, language=language)  # Gives all sources for the params.
            return lang_url
        except Exception as e:
            self.logger.error(e.message)

    def keyword_based(self, keyword):
        try:
            all_articles = self.newsapi.get_everything(q=keyword)
            return all_articles
        except Exception as e:
            self.logger.error(e.message)
