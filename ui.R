shinyUI(pageWithSidebar(
headerPanel("Twitter Sentiment Analysis"),
sidebarPanel(
sliderInput(inputId="numberOfTweets", label = "Number of tweets", value = 30, min = 25, max = 1000),
textInput(inputId="textsearch",label = "Enter the Text" ,value = ""),
textInput(inputId="minwordFreq",label = "Min Word Freq." ,value = "10"),
textInput(inputId="maxwordFreq",label = "Max Words" ,value = "100"),
actionButton(inputId ="submit", label = "SEARCH")
),
mainPanel(
plotOutput("distPlot"),
sidebarPanel(
plotOutput("wordcloud_of_pos")
),
sidebarPanel(
plotOutput("wordcloud_of_neg")
),
sidebarPanel(
plotOutput("wordcloud_of_neu")
))
))
