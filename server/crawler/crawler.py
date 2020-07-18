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
            self.logger.error('news_top_headlines failure: ' + str(e))
        # outfile = open('data//topHeadlines//' + country + '.json', 'w') // PUT IN DB
        # json.dump(data, outfile)

    def news_categories(self, country, category):
        try:
            category_url = self.newsapi.get_top_headlines(country=country, category=category)
            return category_url
        except Exception as e:
            self.logger.error('news_categories failure: ' + str(e))
        # INSERT IN DB

    def news_sources(self, source, country):
        try:
            news_source_url = self.newsapi.get_top_headlines(country=country, sources=source)
            return news_source_url
            # outfile = open(location + '//' + source + '.json', 'w')   //INSERT in DB or cache
            # json.dump(data, outfile)
        except Exception as e:
            self.logger.error('news_sources failure: ' + str(e))

    def lang_sources(self, language, country):
        try:
            lang_url = self.newsapi.get_sources(country=country, language=language)  # Gives all sources for the params.
            return lang_url
        except Exception as e:
            self.logger.error('lang_sources failure: ' + str(e))

    def keyword_based(self, keyword, language='en'):
        try:
            all_articles = self.newsapi.get_everything(q=keyword, sort_by='relevancy', language=language)
            return all_articles
        except Exception as e:
            self.logger.error('keyword_based failure: ' + str(e))

    def news_source_headlines(self, source):
        try:
            src_articles = self.newsapi.get_top_headlines(sources=source)
            return src_articles
        except Exception as e:
            self.logger.error('news_source_headlines failure: ' + str(e))