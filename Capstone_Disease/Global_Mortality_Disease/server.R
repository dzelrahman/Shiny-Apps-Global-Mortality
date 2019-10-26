
options(shiny.maxRequestSize=30*1024^2) 


function(input, output){
    
    output$death_rate <- renderValueBox({
        data_input <- major_react()
        valueBox(
            value = head(data_input$cause, 1),
            "Top Cause of Death",
            icon = icon("skull"),
            color = "red")
    })
    
    output$death_percentage <- renderValueBox({
      data_input <- major_react()
      valueBox(
        value = head(data_input$rates, 1),
        "Percentage",
        icon = icon("percentage"),
        color = "red")
    })
    
    major_react <- reactive({
        major_options <- input$major_options
        major_options_year <- input$major_options_year
        
        data_output <- tidy_mortality %>% 
            filter(country == major_options, year == major_options_year) %>% 
            group_by(cause, year, country) %>% 
            summarise(rates=mean(percent_mortality)) %>% 
            arrange(desc(rates))
        
        return(data_output)
    }) 
    
   output$major_plot <- renderPlotly({
        data_input <- major_react()
    
    
    plot_major <- ggplot(data_input, aes(x= reorder(cause, rates), y=rates, fill=cause)) +
            geom_bar(show.legend = FALSE, stat = "identity") +
            coord_flip() +
            geom_text(aes(label=paste0(round(rates,1), '%')), position = position_dodge(width = .9), hjust = 'left', vjust = 'center', size = 2.5)+
            xlab("") +
            ylab("") +
      theme_minimal()+
      theme(legend.position = "none",
            plot.title = element_text(hjust=1, face="bold"),
            plot.subtitle = element_text(hjust=1),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            panel.grid.major.y = element_blank(),
            panel.grid.minor = element_blank())+
      scale_y_continuous(breaks=c(0,5,10,15,20,25,30),
                         labels=c("0%","5%","10%","15%","20%","25%","30%")) +
      labs(title = "Mortality Cause in Each Country",
           caption="Source: Institute for Health Metrics and Evaluation; Amnesty International")
        
        ggplotly(plot_major)
    })
    
   major_react_2 <- reactive({
     major_options_2 <- input$major_options_2
     
     mortality_final$year <- as.factor(mortality_final$year)
     
     
     data_output_2 <- mortality_final %>% 
       filter(cause == "major_options_2")
     
     return(data_output_2)
   })
   
   output$major_plot_2 <- renderPlot({
     data_input_2 <- major_react_2()
     
     
     plot_major_2 <- ggplot(data_input_2, aes_string(x=year,y=percent_mortality/100)) + 
       geom_line(size=1.2) +
       scale_color_ptol("Socio-Demographic Index") +
       theme_minimal() +
       scale_y_continuous(labels=scales::percent) +
       scale_x_continuous(breaks = c(1990, 1995, 2000, 2005, 2010, 2015)) +
       labs(x=NULL, y=NULL, title="Percentage of Deaths Attributed to Disease") 
     
     ggplot(plot_major_2)
   })
   
   major_react_3 <- reactive({
       major_options_3 <- input$major_options_3
       major_options_year_2 <- input$major_options_year_2
       
       world <- map_data("world") %>% 
           rename(country = region)
       
       data_output_3 <- tidy_mortality %>% 
           inner_join(world, by = "country") %>% 
           filter(year == major_options_year_2, cause == major_options_3) %>% 
           mutate(z_score = ave(percent_mortality, cause, FUN = scale))
       
       return(data_output_3)
   
   })
   
   output$major_plot_3 <- renderPlotly({
       data_input_3 <- major_react_3()
       
       
       plot_major_3 <- ggplot(data_input_3, aes(x=long, y=lat, group=group)) +
           geom_polygon(aes(fill=percent_mortality), color = "black") +
           coord_fixed(1.3) +
           scale_fill_gradient(high="red", low="yellow") +
           labs(title="Cardiovascular Disease Rates Across The Globe in 2015")
       
       ggplotly(plot_major_3)
   })
   
   major_react_4 <- reactive({
       major_options_4 <- input$major_options_4
       
       data_output_4 <- big_dat %>% 
           filter(!is.na(code), cause == major_options_4)
       
       return(data_output_4)
       
   })
   
   output$major_plot_4 <- renderPlotly({
       data_input_4 <- major_react_4()
       
       
       plot_major_4 <- ggplot(data_input_4, aes(x = percent_mortality/100, y = life_expectancy)) + 
           geom_point(alpha = .5) + 
           geom_smooth(aes(color = cause)) + 
           scale_color_viridis_d() +
           labs(title = "Percent of Deaths to Life Expectancy Worldwide",
                y = "Life Expectancy", x = "Percent") +
           guides(color = FALSE) 
       
       ggplotly(plot_major_4)
   })
    
}
