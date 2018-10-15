function(input, output, session) {
    
    dtData <- reactive({
        
        
        #myData <- unlist(strsplit(str_squish(input$text), "(?<=\\.)\\s(?=[A-Z])", perl = T))
        myData <- get_sentences(input$text)
        myData <- data.frame(Sentence = myData, stringsAsFactors = FALSE)
        
        ase <- myData$Sentence
        
        ## EXTRACT TERMS DETAILS
        myTerms <- extract_sentiment_terms(ase)
        colnames(myTerms) <- capitalize(colnames(myTerms))
        myTerms <- subset(myTerms, select = -c(Element_id, Sentence_id))

        ## RUN SENTIMENT
        syuzhet <- setNames(as.data.frame(lapply(c("syuzhet", "bing", "afinn", "nrc"),
                                                 function(x) get_sentiment(ase, method=x))), c("jockers", "bing", "afinn", "nrc"))
        
        SentimentAnalysis <- apply(analyzeSentiment(ase)[c('SentimentGI', 'SentimentLM', 'SentimentQDAP') ], 2, round, 2)
        colnames(SentimentAnalysis) <- gsub('^Sentiment', "SA_", colnames(SentimentAnalysis))
        
        myScore <- data.frame(
            #sentences = ase,
            stanford = sentiment_stanford(ase)[["sentiment"]],
            sentimentr_jockers_rinker = round(sentiment(ase, question.weight = 0)[["sentiment"]], 2),
            sentimentr_jockers = round(sentiment(ase, lexicon::hash_sentiment_jockers, question.weight = 0)[["sentiment"]], 2),    
            sentimentr_huliu = round(sentiment(ase, lexicon::hash_sentiment_huliu, question.weight = 0)[["sentiment"]], 2),    
            sentimentr_sentiword = round(sentiment(ase, lexicon::hash_sentiment_sentiword, question.weight = 0)[["sentiment"]], 2),    
            RSentiment = calculate_score(ase), 
            SentimentAnalysis,
            meanr = score(ase)[['score']],
            syuzhet,
            stringsAsFactors = FALSE
        )
        
        myScore <- apply(myScore, 2, sign)
        myScore[is.na(myScore)] <- 0
        Amaris.Sentiment <- apply(myScore, 1, sum)
        Amaris.Sentiment <- round(as.numeric(Amaris.Sentiment)/14, digits = 3)
        
        mySentence <- data.frame(Sentence = ase, stringsAsFactors = FALSE)
        
        out <- cbind(mySentence, Amaris.Sentiment)
        out <- out %>% left_join(myTerms)
        #out <- left_just(out, "Sentences")
        
        #colnames(out) <- c('Sentences',paste('Model',1:14))
        out
        
    })    
    
    
    # You can access the value of the widget with input$text, e.g.
    output$table <- renderDataTable({ 
        
        out <- dtData()
        subset(out, select=c(Sentence, Amaris.Sentiment))

        },
        options = list(
            autoWidth = FALSE,
            columnDefs = list(list(width = '1200px', targets = c(0)))
        ))
    
    output$total <- renderText({ 
        
        myData <- dtData()
        myScore <- mean(myData$Amaris.Sentiment,na.rm = TRUE)
        out <- 'Neutral'
        if (myScore >= 1/3) { out <- 'Positive' }
        else if (myScore <= -1/3) {out <- 'Negative'}
        else out <- 'Neutral'
        
        print(out)
        paste('Sentiment is',out,'with an Amaris.AI score of', round(myScore,3))
        
    })
    
    output$positive <- renderText({ 
        
        myData <- dtData()
        out <- unique(unlist(myData$Positive))
        out <- paste('Positive Words :', paste(out, sep = ', ', collapse = ', '))
        
    })

    output$negative <- renderText({ 
        
        myData <- dtData()
        out <- unique(unlist(myData$Negative))
        out <- paste('Negative Words :', paste(out, sep = ', ', collapse = ', '))
        
    })

    output$neutral <- renderText({ 
        
        myData <- dtData()
        out <- unique(unlist(myData$Neutral))
        out <- paste('Neutral Words :', paste(out, sep = ', ', collapse = ', '))
        
    })
    
}