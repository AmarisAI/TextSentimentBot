# TextSentimentBot
## using SentimentR
Reference: https://github.com/trinker/sentimentr

This bot takes in a passage and for every sentence, calculate the sentiment score using 14 different models as describe in the reference above.  The bot converts all positive scores to 1 and negative scores to -1.  The average score of all 14 scores are calculated for each sentence.  The average score of each sentence is then calculated to derive the sentiment of the whole passage.
