library(shinydashboard)
####################################
#Auther: Harvey Imama
#Client code for fets fraud detection project
#NYC data science academy project
######################################
shinyUI(
    dashboardPage( 
        dashboardHeader(title = "FraudDashBoard"), 
        dashboardSidebar(
            sidebarUserPanel("Dashboard", image = 'https://online.nycdatascience.com/assets/icons/nycdsa-logo-horizonal.png'), 
            sidebarMenu(
                menuItem("Home", tabName = "home", icon = icon("home")),
                menuItem("Fraud Analysis", tabName = "analysis", icon = icon("database"))
            )
        ), 
        dashboardBody(
           
            tabItems(
                tabItem(
                    tabName = "home",
                    fluidRow(
                        infoBoxOutput('requestsVol'),
                        infoBoxOutput('flaggedVol'),
                        infoBoxOutput('percentageVol')
                        ),
                    fluidRow(
                        infoBoxOutput('requestsVal'),
                        infoBoxOutput('flaggedVal'),
                        infoBoxOutput('percentageVal')),
                    fluidRow(
                        box( plotOutput('totalVolumes') ,width=6) ,
                        box( plotOutput('totalValues') ,width=6) 
                    )
                ),
                tabItem(
                    tabName = "analysis",
                    fluidRow(
                        box(selectizeInput(inputId = "type",
                                           label = "feature",
                                           choices = c('Channel'='channel','Day'='day','Week'='week'
                                                       ,'Tier'='tier','Customer Type'='cType',
                                                       'BVN Status'='bvn') )
                            
                            )
                    ),
                    fluidRow(
                        box(plotOutput('allPlotValue'),width=6) ,
                        box(plotOutput('allPlotVolume'),width=6) ,
                        box(plotOutput('fraudPlotValue'),width=6) ,
                        box(plotOutput('fraudPlotVolume'),width=6) ,
                        box(plotOutput('nofraudPlotValue'),width=6) ,
                        box(plotOutput('nofraudPlotVolume'),width=6) ,
                    )
                )
            ))
    ))