library(shinydashboard)

shinyUI(
    dashboardPage( 
        dashboardHeader(title = "FraudDetectionDashBoard"), 
        dashboardSidebar(
            sidebarUserPanel("Dashboard", image = 'https://online.nycdatascience.com/assets/icons/nycdsa-logo-horizonal.png'), 
            sidebarMenu(
                menuItem("Home", tabName = "home", icon = icon("home")),
                menuItem("Flagged Transactions", tabName = "flaggedTransactions", icon = icon("database")),
                menuItem("Trend", tabName = "trend", icon = icon("database")),
            )
        ), 
        dashboardBody(
            tabItems(
                
                tabItem(
                    tabName = "home",
                    fluidRow(
                        box(dateRangeInput('dateRange',
                                           label = 'Date range input: yyyy-mm-dd',
                                           start = Sys.Date() - 2, end = Sys.Date() + 2)
                        )
                    ),
                    fluidRow(
                        box(ValueBoxOutput('requestsToday')),
                        box(ValueBoxOutput('flaggedToday')),
                        box(ValueBoxOutput('percentageToday'))),
                    fluidRow(
                        box(ValueBoxOutput('requestsAll')),
                        box(ValueBoxOutput('flaggedAll')),
                        box(ValueBoxOutput('percentageAll')))
                ),
                tabItem(
                    tabName = "flaggedTransactions",
                    fluidRow(
                        box(selectizeInput(inputId = "type",
                                           label = "feature",
                                           choices = c('Channel'='channel','Day'='day','Week'='week'
                                                       ,'Tier'='tier','Customer Type'='cType',
                                                       'BVN Status'='bvn') ),
                            dateRangeInput('dateRange',
                                           label = 'Date range input: yyyy-mm-dd',
                                           start = Sys.Date() - 2, end = Sys.Date() + 2)
                            
                            )
                    ),
                    fluidRow(
                        box(plotOutput('typePlotValue'),width=12) ,
                        box(plotOutput('typePlotVolume'),width=12) 
                    )
                ),
                tabItem(
                    tabName = "trend",
                    fluidRow(
                        box(
                            dateRangeInput('dateRange',
                                           label = 'Date range input: yyyy-mm-dd',
                                           start = Sys.Date() - 2, end = Sys.Date() + 2)
                        )
                    ),
                    fluidRow(
                        box(plotOutput('trendValue'),width=12)  
                    ),
                    fluidRow(
                        box(plotOutput('trendVolume'),width=12) 
                    )
                )
            ))
    ))