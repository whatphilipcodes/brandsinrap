#contains code from 
#https://melaniewalsh.github.io/Intro-Cultural-Analytics/04-Data-Collection/09-Lyrics-Analysis.html

from bs4 import BeautifulSoup
import re
import lyricsgenius
import requests
from pathlib import Path
import csv

#genius key
# GET /artists/:id/albums


def clean_up(song_title):

    if "Ft" in song_title:
        before_ft_pattern = re.compile(".*(?=\(Ft)")
        song_title_before_ft = before_ft_pattern.search(song_title).group(0)
        clean_song_title = song_title_before_ft.strip()
        clean_song_title = clean_song_title.replace("/", "-")

    else:
        song_title_no_lyrics = song_title.replace("Lyrics", "")
        clean_song_title = song_title_no_lyrics.strip()
        clean_song_title = clean_song_title.replace("/", "-")

    return clean_song_title


def get_all_songs_from_album(artist, album_name):

    artist = artist.replace(" ", "-")
    album_name = album_name.replace(" ", "-")

    response = requests.get(f"https://genius.com/albums/{artist}/{album_name}")
    html_string = response.text
    document = BeautifulSoup(html_string, "html.parser")
    song_title_tags = document.find_all(
        "h3", attrs={"class": "chart_row-content-title"}
    )
    song_titles = [song_title.text for song_title in song_title_tags]

    clean_songs = []
    for song_title in song_titles:
        clean_song = clean_up(song_title)
        clean_songs.append(clean_song)

    return clean_songs


def download_album_lyrics(artist, album_name, album_release_year):

    # Set up LyricsGenius with your Genius API client access token
    # client_access_token = Your-Client-Access-Token
    LyricsGenius = lyricsgenius.Genius(
        "vTnE8zaVa_XI40ubgX-zo3zz4GBSBsmbURIgyD07ebwoSaERF4-jh0iCCbcGIrdH"
    )
    LyricsGenius.remove_section_headers = True

    # With the function that we previously created, go to Genius.com and get all song titles for a particular artist's album
    clean_songs = get_all_songs_from_album(artist, album_name)

    for song in clean_songs:

        # For each song in the list, search for that song with LyricsGenius
        song_object = LyricsGenius.search_song(song, artist)

        # If the song is not empty
        if song_object != None:

            # Do some cleaning and prep for the filename of the song
            artist_title = artist.replace(" ", "-")
            album_title = album_name.replace(" ", "-")
            song_title = song.replace("/", "-")
            song_title = song.replace(" ", "-")
            release_year = album_release_year

            # Establish the filename for each song inside a directory that begins with the artist's name and album title
            # custom_filename=f"{artist_title}_{album_title}/{song_title}"
            custom_filename = (
                f"Lyrics/{release_year}_{artist_title}_{album_title}/{song_title}"
            )

            # A line of code that we need to create a directory
            # os.makedirs(os.path.dirname(filename), exist_ok=True)
            #Path(f"{release_year}_{artist_title}_{album_title}").mkdir(parents=True, exist_ok=True)
            Path(f"Lyrics/{release_year}_{artist_title}_{album_title}").mkdir(parents=True, exist_ok=True)


            # Save the lyrics for the song as a text file
            song_object.save_lyrics(
                filename=custom_filename, extension="txt", sanitize=False
            )

        # If the song doesn't contain lyrics
        else:
            print("No lyrics")


def print_csv(csv_name):
    with open(csv_name) as csvdatei:
        csv_reader_object = csv.reader(csvdatei)
        rownr = 0
        print("*** albums to download:")
        for row in csv_reader_object:
            print(row[0] + " " + row[1] + " " + row[2]) 
        rownr += 1

def download_lyrics(csv_name):
    with open(csv_name) as csvdatei:
        csv_reader_object = csv.reader(csvdatei)
        rownr = 0

        for row in csv_reader_object:
            # print(f'- Nachname: {row[0]} \t| Vorname: {row[1]} \t| Geburtstag: {row[2]}.')
            print("")
            print("*** downloading lyrics from: " + row[0] + " " + row[1] + " " + row[2]) 
            print("")
            download_album_lyrics(row[0], row[1], row[2])
        rownr += 1

#artist+album+song name from URL work
print_csv("albums.csv")
download_lyrics("albums.csv")


