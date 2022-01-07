# contains code from
# https://melaniewalsh.github.io/Intro-Cultural-Analytics/04-Data-Collection/09-Lyrics-Analysis.html

from pathlib import Path
from collections import Counter
import re
import pandas as pd
import os
import pprint
import csv
from rich import print


printBrands = True
directory_path = "Lyrics/"

# words that get ignored in wordcounting
stopwords = [
    "ich",
    "ich",
    "mein",
    "mich",
    "wir",
    "unser",
    "uns",
    "du",
    "dein",
    "dein",
    "du",
    "ihr",
    "er",
    "ihm",
    "sein",
    "sich",
    "sie",
    "sie",
    "ihr",
    "ihr",
    "sich",
    "es",
    "sein",
    "selbst",
    "sie",
    "sie",
    "ihre",
    "sich selbst",
    "was",
    "welches",
    "wer",
    "wen",
    "dies",
    "das",
    "diese",
    "jene",
    "bin",
    "ist",
    "sind",
    "war",
    "waren",
    "sein",
    "gewesen",
    "sein",
    "haben",
    "hat",
    "hatte",
    "haben",
    "tun",
    "tut",
    "tat",
    "tun",
    "ein",
    "an",
    "der",
    "und",
    "aber",
    "wenn",
    "oder",
    "weil",
    "als",
    "bis",
    "während",
    "von",
    "bei",
    "durch",
    "für",
    "mit",
    "über",
    "gegen",
    "zwischen",
    "in",
    "durch",
    "während",
    "vor",
    "nach",
    "oben",
    "unten",
    "nach",
    "von",
    "oben",
    "unten",
    "in",
    "out",
    "on",
    "off",
    "over",
    "under",
    "again",
    "further",
    "then",
    "once",
    "here",
    "dort",
    "wann",
    "wo",
    "warum",
    "wie",
    "alle",
    "irgendwelche",
    "beide",
    "jeder",
    "wenige",
    "mehr",
    "die meisten",
    "andere",
    "einige",
    "solche",
    "nein",
    "noch",
    "nicht",
    "nur",
    "eigene",
    "gleiche",
    "so",
    "als",
    "auch",
    "sehr",
    "s",
    "t",
    "kann",
    "wird",
    "nur",
    "don",
    "sollte",
    "jetzt",
    "dir",
    "bist",
    "die",
    "doch",
    "den",
    "auf",
    "da",
    "meine",
    "mir",
    "dich",
    "ja",
]
# brandnames and their synonyms, the original name has to be a value as well
# WRITE IN LOWERCASE
alternative_names = {
    "louis vuitton": ["louis", "lv", "luis", "louis vuitton"],
    "supreme": ["preme", "supreme"],
    "palace": ["palace"],
    "yves saint laurent": ["yves saint laurent", "yves", "ysl"],
    "chanel": ["chanel"],
    "gosha rubchinskiy": ["gosha"],
    "gucci": ["gucci"],
    "acne": ["acne"],
    "versace": ["versace"],
    "dior": ["dior"],
    "helmut lang": ["helmut"],
    "cav empt": ["cav"],
    "vetements": ["vetements"],
    "nike": ["nike"],
    "prada": ["prada"],
    "adidas": ["adidas"],
    "balenciaga": ["balenci", "balenciaga"],
    "bape": ["bape"],
    "mcm": ["mcm"],
    "jordan": ["jordans", "jordan"],
    "y3": ["yamamoto", "y3"],
    "fendi": ["fendi"],
    "montclair": ["montclair"],
    "ferragamo": ["ferragamo"],
    "dolce und gabbana": ["dolce und gabbana", "d&g", "gabbana"],
    "armani": ["armani"],
}

# invert dict
real_names = {}
for key, values in alternative_names.items():
    for alt_name in values:
        real_names[alt_name] = key

# print("real_names contains: ")
# print(real_names)
# create a dict with the original names and values of 0
brands_counted = {}
for key in alternative_names.keys():
    brands_counted[key] = 0


def split_into_words(any_chunk_of_text):
    lowercase_text = any_chunk_of_text.lower()
    split_words = re.split("\W+", lowercase_text)
    # print(split_words)
    return split_words


def count_many(needles, haystack):
    count = Counter(haystack)
    return {key: count[key] for key in count if key in needles}


def get_most_frequent_words_directory(directory_path):

    number_of_desired_words = 20
    meaningful_words_tally = Counter()
    release_year_old = ""

    # for filepath in Path(directory_path).glob('*.txt'):

    #         full_text = open(filepath, encoding="utf-8").read()
    #         all_the_words = split_into_words(full_text)
    #         meaningful_words = [word for word in all_the_words if word not in stopwords]
    #         meaningful_words_tally.update(meaningful_words)

    # join all txt files in subfolders to a single txt file
    for root, dirs, files in os.walk(directory_path):
        # print(*files, sep = "\n")
        if root != "Lyrics/":
            print("[bold magenta]*** [/bold magenta]" + root)
        # get first four characters of folder name
        release_year = root.split("/")[-1]
        release_year = release_year[:4]
        # print(release_year)

        # reset brands_counted if release year is different
        if release_year != release_year_old and root != "Lyrics/":
            print(
                "Resetting brands_counted: "
                + "release_year_old: "
                + release_year_old
                + " release_year: "
                + release_year
            )
            for key in alternative_names.keys():
                brands_counted[key] = 0

        # create csv file for each folder
        csv_file_name = release_year + ".csv"
        csv_file_path = os.path.join(directory_path, csv_file_name)
        csv_file = open(csv_file_path, "w", encoding="utf-8")

        text = ""
        for file in files:
            if file.endswith(".txt"):
                with open(os.path.join(root, file), "r", encoding="utf8") as f:
                    text += f.read()

        full_text = text
        all_the_words = split_into_words(full_text)

        meaningful_words = [word for word in all_the_words if word not in stopwords]
        meaningful_words_tally.update(meaningful_words)

        words_counted_synonyms_year = count_many(real_names, meaningful_words)
        if printBrands and root != "Lyrics/":
            print("brands in album: ")
            print(words_counted_synonyms_year)
        # add the frequency of synonyms to real brand name
        for brand in words_counted_synonyms_year:
            brands_counted[real_names[brand]] += words_counted_synonyms_year.get(brand)

        # if printBrands:
        #     print("brands_counted")
        #     pprint.pprint(brands_counted)
        # sort dict by value
        sorted_brands_counted = sorted(
            brands_counted.items(), key=lambda x: x[1], reverse=True
        )
        # if printBrands and root != "Lyrics/":
        #     print("sorted_brands_counted")
        #     pprint.pprint(sorted_brands_counted)

        # print sorted_brands_counted if value is not 0
        for brand, count in sorted_brands_counted:
            if count != 0:
                csv_file.write(brand + "," + str(count) + "\n")

        # write csv file
        with open(csv_file_path, "w", encoding="utf8", newline="") as csv_file:
            csv_writer = csv.writer(csv_file, delimiter=",")
            csv_writer.writerow(["Brand", "Count"])
            for brand, count in sorted_brands_counted:
                csv_writer.writerow([brand, count])

        release_year_old = release_year

    most_frequent_meaningful_words = meaningful_words_tally.most_common(
        number_of_desired_words
    )
    return most_frequent_meaningful_words


# print(get_most_frequent_words_directory(directory_path))
frequencies = get_most_frequent_words_directory(directory_path)

# Make Counter dictionary into a Pandas DataFrame
word_frequency_df = pd.DataFrame(frequencies, columns=["word", "word_count"])
# Plot word counts
word_frequency_df.sort_values(by="word_count").plot(
    x="word", kind="barh", title="CountedWords:\n Most Frequent Words"
)

