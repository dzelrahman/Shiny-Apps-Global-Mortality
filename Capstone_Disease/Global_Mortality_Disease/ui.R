header <- dashboardHeader(
    title = "Global Mortality"
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(
            text = "Share of Death by Cause",
            tabName = "major_death",
            icon = icon("chart-bar")
        ),
        menuItem(
          text = "Socio-Demographic Index",
          tabName = "SDI",
          icon = icon("chart-line")
        ),
       
        menuItem(
            text = "Disease Rates Across The Globe",
            tabName = "Rates_Globe",
            icon = icon("globe-asia")
        ),
        menuItem(
            text = "Correlation with Life Expectancy",
            tabName = "Corr_LE",
            icon = icon("retweet")
        )
        
    )
)

body <- dashboardBody(
    tabItems(
        tabItem("major_death",
                fluidRow(
                    valueBoxOutput("death_rate"),
                    valueBoxOutput("death_percentage")
                ),
        fluidRow(
            box(
                "Filter",br(), "Select country and year",
                selectInput(
                    inputId = "major_options",
                    label = "Select Country:",
                    choices = levels(tidy_mortality$country),
                    multiple = FALSE 
                ),
                sliderInput(
                    "major_options_year",
                    label = h3("Year"),
                    min = 1990,
                    max = 2016,
                    value = 2016
                )
                
                ),
            column(width=12, plotlyOutput(outputId = "major_plot"))
            )
        ),
        tabItem("SDI",
                fluidRow(
                  box(
                    "Filter", br(), "Rates trend based on SDI",
                    selectInput(
                      inputId = "major_options_2",
                      label = "Select Disease:",
                      choices = levels(mortality_final$cause),
                      multiple = FALSE
                    )
                  ),
                  plotOutput(outputId = "major_plot_2")
                  
                )
                
        ),
      
        tabItem("Rates_Globe",
                fluidRow(
                    box(
                        "Filter", br(), "World proportion",
                        selectInput(
                            inputId = "major_options_3",
                            label = "Select Disease:",
                            choices = levels(tidy_mortality$cause),
                            multiple = FALSE
                        ),
                        sliderInput(
                            "major_options_year_2",
                            label = h3("Slider"),
                            min = 2000,
                            max = 2016,
                            value = 2016
                        )
                    ),
                    column(width=12, plotlyOutput(outputId = "major_plot_3"))
                )
        ),
        tabItem("Corr_LE",
                fluidRow(
                    box(
                        "Filter", br(), "Correlation",
                        selectInput(
                            inputId = "major_options_4",
                            label = "Select Disease:",
                            choices = levels(big_dat$cause),
                            multiple = FALSE
                        )
                    ),
                    column(width=12, plotlyOutput(outputId = "major_plot_4"))
                    
                )
                )
    
                )
            )


dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body,
    skin = "red"
    
)