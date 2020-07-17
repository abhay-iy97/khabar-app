from server.scraper.scraper import Scraper


class Format:
    def __init__(self):
        pass

    def __extract_article(self, url):
        article = Scraper.scrape_article(url)
        return article

    def extract_url(self, jsons):  # Assuming it arrives in NEWSAPI json format
        url_list = list()
        articles = jsons['articles']  # list
        for article in articles:
            url = article['url']
            url_list.append(url)
            scraped_article = self.__extract_article(url)
            if len(scraped_article):
                article['content'] = scraped_article
        print(len(url_list))
        return jsons

    def extract_source(self, jsons):
        pass    # TO BE DONE.
