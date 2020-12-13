library(shiny)

shinyServer(function(input, output) {
    
    get.today.data <- reactive(
      filter(transaction.data,crt_dt > input$dateRange$start[1] & crt_dt < input$dateRange[2] )
    )
    
    get.today.flagged.data <- reactive(
        filter(transaction.data,crt_dt > input$dateRange$start[1] & crt_dt < input$dateRange[2] 
               & flagged == T )
    )
    
    get.count.by <- reactive(
        groupby(get.today.flagged.data(), input$type) %>% summarize(n=n())
    )
    
    get.sum.by <- reactive(
        groupby(get.today.flagged.data(), input$type) %>% summarize(sum=sum(Amount))
    )
    
    get.date.sum.by <- reactive(
        groupby(get.today.flagged.data(), crt_dt) %>% summarize(sum=sum(Amount))
    )
    
    get.date.count.by <- reactive(
        groupby(get.today.flagged.data(), crt_dt) %>% summarize(n=n())
    )
    

    
    output$requestsToday <- renderValueBox({
        valueBox(
            nrow(get.today.data()), "Volume Today", icon = icon("list"),
            color = "purple"
        ) 
    })
    
    output$flaggedToday <- renderValueBox({
        valueBox(
            nrow(get.today.flagged.data()), "Volume Flagged Today", icon = icon("list"),
            color = "yellow"
        ) 
    })
    
    output$percentageToday <- renderValueBox({
        valueBox(
            round(nrow(get.today.flagged.data())/nrow(get.today.data()),digits=4), "Flag % Today", icon = icon("list"),
            color = "blue"
        ) 
    })
    
    
    output$requestsAll <- renderValueBox({
        valueBox(
            sum(get.today.data()), "Value Today", icon = icon("list"),
            color = "purple"
        ) 
    })
    
    output$flaggedAll <- renderValueBox({
        valueBox(
            sum(get.today.flagged.data()), "Value Flagged Today", icon = icon("list"),
            color = "yellow"
        ) 
    })
    
    output$percentageAll <- renderValueBox({
        valueBox(
            round(sum(get.today.flagged.data())/sum(get.today.data()),digits=4), "Flag % Today", icon = icon("list"),
            color = "blue"
        ) 
    })
    
    
    output$typePlotValue <- renderPlot({
            ggplot(get.count.by(),aes(input$type,n)) +
            geom_bar() + labs(x=input$type,y="Frequency",title=paste('Flagged by ',input$type,sep =" "))
    })
    
    output$typePlotVolume <- renderPlot({
        ggplot(get.sum.by(),aes(input$type,sum)) +
            geom_bar() + labs(x=input$type,y="Amount",title=paste('Flagged by ',input$type,sep =" "))
    })
    
    
    output$trendValue <- renderPlot({
            ggplot(get.date.count.by(),aes(crt_dt,n)) +
            geom_line() +
            labs(x="date",y = "Frequency" ,title='Frequecncy of flagged transactions by date') 
    })
    
    output$trendVolume <- renderPlot({
        ggplot(get.date.sum.by(),aes(crt_dt,sum)) +
            geom_line() +
            labs(x="date",y = "Amount" ,title='Amount of flagged transactions by date') 
    })
    
    
    
})