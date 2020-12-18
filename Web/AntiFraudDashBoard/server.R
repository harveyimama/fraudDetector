library(shiny)
####################################
#Auther: Harvey Imama
#Server code for fets fraud detection project
#NYC data science academy project
######################################
shinyServer(function(input, output) {
    
    
    get.flagged.data <- reactive(
        filter(transaction.data, is_flagged == 'T' )
    )
    
    get.sum.by <- reactive(
      transaction.data %>% group_by(is_flagged) %>% summarise(.,sum(amount))
    )
    
   
    output$requestsVol <- renderInfoBox({
        infoBox(
            comma(nrow(transaction.data), digits = 2), "Total Volume", icon = icon("list"),
            color = "purple"
        ) 
    })
    
    output$flaggedVol <- renderInfoBox({
        infoBox(
            comma(nrow(get.flagged.data()), digits = 2), "Volume Flagged", icon = icon("list"),
            color = "yellow"
        ) 
    })
    
    output$percentageVol <- renderInfoBox({
        infoBox(
            comma(100*round(nrow(get.flagged.data())/nrow(transaction.data),digits=4), digits = 2), "Flag % ", icon = icon("list"),
            color = "blue"
        ) 
    })
    
    
    output$requestsVal <- renderInfoBox({
      infoBox(
        comma(sum(transaction.data$amount), digits = 2), "Total Value", icon = icon("list"),
            color = "purple"
        ) 
    })
    
    output$flaggedVal <- renderInfoBox({
      infoBox(
           comma(sum(get.flagged.data()$amount), digits = 2), "Value Flagged", icon = icon("list"),
            color = "yellow"
        ) 
    })
    
    output$percentageVal <- renderInfoBox({
      infoBox(
            comma(round(100*sum(get.flagged.data()$amount)/sum(transaction.data$amount),digits=4), digits = 2), "Flag % Total", icon = icon("list"),
            color = "blue"
        ) 
    })
    
    output$totalVolumes <- renderPlot({
      ggplot(transaction.data,aes(is_flagged)) +
        geom_bar(aes(fill=is_flagged)) + labs(x="Is Flagged",y="Volume",title='Transaction Volumes')
    })
    
    output$totalValues <- renderPlot({
      ggplot(get.sum.by(),aes(is_flagged)) +
        geom_bar(aes(fill=is_flagged)) + labs(x="Is Flagged",y="Value",title='Transaction Values')
    })
    
    output$allPlotValue <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(channel,sum)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(day_of_the_week,sum)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(week_of_the_month,sum)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(tier,sum)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(customer_type,sum)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,sum = sum(amount)) 
        ggplot(data,aes(has_bvn,sum)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Value",title=paste('Total by ',input$type,sep =" "))
        
      }
      
     
    })
    
    output$allPlotVolume <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,n = n()) 
        ggplot(data,aes(channel,n)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,n = n()) 
        ggplot(data,aes(day_of_the_week,n)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,n = n()) 
        ggplot(data,aes(week_of_the_month,n)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,n = n()) 
        ggplot(data,aes(tier,n)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,n = n()) 
        ggplot(data,aes(customer_type,n)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,n = n()) 
        ggplot(data,aes(has_bvn,n)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Volume",title=paste('Total by ',input$type,sep =" "))
        
      }
    })
    
    
    output$fraudPlotValue <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(channel,sum)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(day_of_the_week,sum)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(week_of_the_month,sum)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(tier,sum)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(customer_type,sum)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(has_bvn,sum)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Value",title=paste('Flagged by ',input$type,sep =" "))
        
      }
      
    })
    
    output$fraudPlotVolume <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(channel,n)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Volume",title=paste('Flagged by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(day_of_the_week,n)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Volumr",title=paste('Flagged by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(week_of_the_month,n)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Volume",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(tier,n)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Volume",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(customer_type,n)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Volume",title=paste('Flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='T')
        ggplot(data,aes(has_bvn,n)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Volume",title=paste('Flagged by ',input$type,sep =" "))
        
      }
    })
    
    output$nofraudPlotValue <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(channel,sum)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(day_of_the_week,sum)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(week_of_the_month,sum)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(tier,sum)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(customer_type,sum)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,sum = sum(amount)) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(has_bvn,sum)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Value",title=paste('Not flagged by ',input$type,sep =" "))
        
      }
    })
    
    output$nofraudPlotVolume <- renderPlot({
      if(input$type == 'channel')
      {
        data = transaction.data %>% group_by(is_flagged,channel) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(channel,n)) +
          geom_col(aes(fill=channel)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
      } else if  (input$type == 'day')
      {
        data = transaction.data %>% group_by(is_flagged,day_of_the_week) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(day_of_the_week,n)) +
          geom_col(aes(fill=day_of_the_week)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
        
      } else if  (input$type == 'week')
      {
        data = transaction.data %>% group_by(is_flagged,week_of_the_month) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(week_of_the_month,n)) +
          geom_col(aes(fill=week_of_the_month)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'tier')
      {
        data = transaction.data %>% group_by(is_flagged,tier) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(tier,n)) +
          geom_col(aes(fill=tier)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'cType')
      {
        data = transaction.data %>% group_by(is_flagged,customer_type) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(customer_type,n)) +
          geom_col(aes(fill=customer_type)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
        
      }else if  (input$type == 'bvn')
      {
        data = transaction.data %>% group_by(is_flagged,has_bvn) %>% summarise(.,n=n()) %>% filter(.,is_flagged=='F')
        ggplot(data,aes(has_bvn,n)) +
          geom_col(aes(fill=has_bvn)) + labs(x=input$type,y="Volume",title=paste('Not flagged by ',input$type,sep =" "))
        
      }
    })
    
    
    
})