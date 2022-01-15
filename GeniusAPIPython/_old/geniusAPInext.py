#Assign your Genius.com credentials and select your artist
import lyricsgenius as genius
import pandas as pd

apiKey = "vTnE8zaVa_XI40ubgX-zo3zz4GBSBsmbURIgyD07ebwoSaERF4-jh0iCCbcGIrdH"
api = genius.Genius(apiKey)

def download_lyrics_from_artist(artist_name, max_songs):
    artist = api.search_artist(artist_name, max_songs)
    #artist = api.search_artist(artist_name)
    for song in artist.songs:
        song.save_lyrics(extension = "txt")


download_lyrics_from_artist("Shindy", 5)
