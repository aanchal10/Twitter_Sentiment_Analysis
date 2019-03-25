library(shiny)
library(tm)
library(wordcloud)
library(twitteR)
dictpositive <- c("good", "freedom", "boost", "most", "must","promises")
dictnegative <- c("warns", "pain", "hit", "bad","abandoned")
api_key <- "Your API Key"
api_secret <- "Your API Key Secret"
access_token <- "Your access token"
access_token_secret <- "Your access token secret"
positivecheck <- function(text)
{
for(i in 1 : length(dictpositive))
{
if(grepl(dictpositive[i], text, ignore.case = TRUE) == TRUE)
{return(TRUE)
break}
}
return(FALSE)
}
negativecheck <- function(text)
{
for(i in 1 : length(dictnegative))
{
if(grepl(dictnegative[i], text, ignore.case = TRUE) == TRUE)
{return(TRUE)
break}
}
return(FALSE)
}
shinyServer(function(input, output) {
options(httr_oauth_cache = T)
print("Called")
ntext <- eventReactive(input$submit, {
print(input$numberOfTweets)
print(input$textsearch)
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
tweets_result = searchTwitter(input$textsearch, lang = "en", n = input$numberOfTweets)
positive_counter = 0
negative_counter = 0
neutral_counter = 0
postext <- vector()
negtext <- vector()
neutext <- vector()
vector_users <- vector()
vector_sentiments <- vector()
for (tweet in tweets_result){
print(paste(tweet$screenName, ":", tweet$text))
vector_users <- c(vector_users, as.character(tweet$screenName));
if (positivecheck(tweet$text) == TRUE){
positive_counter = positive_counter + 1 # Inc the positive counts
vector_sentiments <- c(vector_sentiments, "Positive") #Add the positive sentiment
postext <- c(postext, as.character(tweet$text)) # Add the positive text
} else if ( negativecheck(tweet$text) == TRUE) {
negative_counter = negative_counter + 1
vector_sentiments <- c(vector_sentiments, "Negative")
negtext <- c(negtext, as.character(tweet$text))
} else
{ neutral_counter = neutral_counter + 1
print("neutral")
vector_sentiments <- c(vector_sentiments, "Neutral")
neutext <- c(neutext, as.character(tweet$text))
}
}
df_sentimentsusers <- data.frame(vector_users, vector_sentiments)
output$tweets_table = renderDataTable({
df_sentimentsusers
})
print(positive_counter)
print(negative_counter)
print(neutral_counter)
results = data.frame(tweets = c("Positive", "Negative", "Neutral"), numbers = c(positive_counter,negative_counter,neutral_counter))
barplot(results$numbers, names = results$tweets, xlab = "Sentiment Of Public", ylab = "Count of Tweets", col = c("Orange","Black","Pink"))
if (length(postext) > 0){
output$wordcloud_of_pos <- renderPlot({ wordcloud(paste(postext, collapse=" "), min.freq = 0, random.color=TRUE, max.words=100 ,colors=brewer.pal(8, "Dark2")) })
}
if (length(negtext) > 0) {
output$wordcloud_of_neg <- renderPlot({ wordcloud(paste(negtext, collapse=" "),min.freq = 0, random.color=TRUE, max.words=100 ,colors=brewer.pal(8,"Dark2")) })
}
if (length(neutext) > 0){
output$wordcloud_of_neu <- renderPlot({ wordcloud(paste(neutext, collapse=" "), min.freq = 0, random.color=TRUE , max.words=100 ,colors=brewer.pal(8, "Dark2")) })
}
})
output$distPlot <- renderPlot({
ntext()
})
})
