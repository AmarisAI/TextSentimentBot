fluidPage(
    
    fluidRow(
        
        column(8,
               h4('Text Sentiment Bot Input'),
               textAreaInput("text", label = "", value = "The market is weak. Trade war is not ending anytime soon.", 
                             width = "1000px", height = "80px")
               ),
        column(4,img(src='Amaris Logo.png', align = "right"))
    ),
    fluidRow(
        column(10, h4(textOutput("total")))
        ),
    fluidRow(
        column(10, h5(textOutput("positive")))
    ),
    fluidRow(
        column(10, h5(textOutput("negative")))
    ),
    fluidRow(
        column(10, h5(textOutput("neutral")))
    ),
    hr(),
    fluidRow(
        column(10, dataTableOutput("table"))
    )

)