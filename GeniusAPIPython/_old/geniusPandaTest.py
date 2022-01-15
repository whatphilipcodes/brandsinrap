import requests
import pandas as pd

client_access_token = "vTnE8zaVa_XI40ubgX-zo3zz4GBSBsmbURIgyD07ebwoSaERF4-jh0iCCbcGIrdH"

search_term = "Shindy"
genius_search_url = f"http://api.genius.com/search?q={search_term}&access_token={client_access_token}"

response = requests.get(genius_search_url)
json_data = response.json()

missy_songs = []
for song in json_data['response']['hits']:
    missy_songs.append([song['result']['full_title'], song['result']['stats']['pageviews']])
    
#Make a Pandas dataframe from a list
missy_df = pd.DataFrame(missy_songs)
missy_df.columns = ['song_title', 'page_views']
missy_df