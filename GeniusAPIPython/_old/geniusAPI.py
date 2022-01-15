client_access_token = "vTnE8zaVa_XI40ubgX-zo3zz4GBSBsmbURIgyD07ebwoSaERF4-jh0iCCbcGIrdH"
import lyricsgenius
LyricsGenius = lyricsgenius.Genius(client_access_token)
    
#artist = LyricsGenius.search_artist("Future", max_songs=5)
artist = LyricsGenius.search_artist("Future")
artist.songs

for song in artist.songs:
    print(song.lyrics)
    song.save_lyrics(extension='txt')

""" from requests.exceptions import Timeout

lyrics = []


def get_lyrics():
    # while len(lyrics) != len(end_df): #1
    genius = lyricsgenius.Genius(client_access_token)
    genius.timeout = 15
    genius.sleep_time = 40  # 2
    # or: Genius(token, timeout=15, sleep_time=40)
    for track in end_df.values:
        retries = 0
        while retries < 3:
            try:
                song = genius.search_song(track[2], track[0])
            except Timeout as e:
                retries += 1
                continue
            if song is not None:
                lyrics.append(song.lyrics)
            else:
                lyrics.append(np.NAN)
            break """
