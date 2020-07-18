from newspaper import Article
from newsplease import NewsPlease
import logging


class Scraper:

    def __init__(self):
        pass

    @staticmethod
    def scrape_article(url):
        try:
            article = Article(url)
            article.download()
            article.parse()
            print('Done by newspaper')
            return article.text
            # Storage to be done
        except Exception as e:
            try:
                article = NewsPlease.from_url(url)
                print('Done by newsplease')
                return article.maintext
                # Storage to be done
            except Exception as e:
                print(e.messsage)
                return 'null'
