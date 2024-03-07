import feedparser
import pprint

url = "https://lore.kernel.org/linux-pci/new.atom"
feed = feedparser.parse(url)

for entry in feed.entries:
    if 'thr_in-reply-to' in entry:
        continue

    print(entry.title)
    print(entry.link)
