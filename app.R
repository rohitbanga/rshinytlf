#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                       
# Name         :  app.R
# Description  :  Main app program
# Input        :  
#               
# Usage notes  :  
#                 
#
#**********************************************************************************************************
# Programmer   :  Rohit Banga
# Date         :  17 Feb 2020 
# Change Log   :  
# Text         :  
#**********************************************************************************************************



##Load Libraries

#install.packages("Hmisc", dependencies=TRUE)
#install.packages("sqldf", dependencies=TRUE)
#install.packages("plyr", dependencies=TRUE)
#install.packages("dplyr", dependencies=TRUE)
#install.packages("reshape2", dependencies=TRUE)
#install.packages("expss", dependencies=TRUE)
#install.packages("shiny", dependencies=TRUE)
#install.packages("shinydashboard", dependencies=TRUE)
#install.packages("shinyWidgets", dependencies=TRUE)
#install.packages("shinyjs", dependencies=TRUE)
#install.packages("shinycssloaders", dependencies=TRUE)
#install.packages("ggplot2", dependencies=TRUE)
#install.packages("rtf", dependencies=TRUE)


library(Hmisc)
library(sqldf)
library(plyr)
library(dplyr)
library(reshape2)
library(expss)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(shinycssloaders)
library(ggplot2)
library(rtf)


study_list = c("Demo Study 1", "Demo Study 2" )
figure_1_param = "none"

ui = fluidPage(
  shinyjs::useShinyjs()
  ,includeCSS("styles.css")
  ,dashboardPage(
    dashboardHeader(titleWidth  = 350, title = "R Shiny TLF Demo")
    
    ,dashboardSidebar(
      width = 350,
      sidebarMenu(
         selectInput("study", "Study Name:", study_list)
        ,menuItem("Table 1 - Demographic Information"  , tabName = "table1"       , icon = icon("angle-right")) 
        ,menuItem("Listing 1 - Adverse Events"         , tabName = "listing1"     , icon = icon("angle-right")) 
        ,menuItem("Figure 1 - Cog Analysis "            , tabName = "figure1"     , icon = icon("angle-right")) 
        ,menuItem(actionButton("refresh_btn", "Refresh Database")) 
        ,menuItem(downloadButton("all_rep", "Download All Files"))
      )
    )
    ,dashboardBody(
      tabItems(
        tabItem(tabName = "table1"    , h2("Table 1 - Demographic Information")  ,div(style = 'overflow-x: scroll;white-space: nowrap;', DT::dataTableOutput("table_1")%>% withSpinner(color="#0dc5c1")))
       ,tabItem(tabName = "listing1"  , h2("Listing 1 - Adverse Event")          ,div(style = 'overflow-x: scroll;white-space: nowrap;', DT::dataTableOutput("listing_1")%>% withSpinner(color="#0dc5c1"))
                                      , h2("Listing 1 - Legend")                 ,div(width = 'overflow-x: scroll;white-space: nowrap;', DT::dataTableOutput('legend_l1')%>% withSpinner(color="#0dc5c1"))
                )
       ,tabItem(tabName = "figure1"    , h2("Figure 1 - Cog Analysis - Mean change for baseline by visit")  ,div(style = 'overflow-x: scroll;white-space: nowrap;', selectInput("param", "Parameter Name:", figure_1_param)                                                                                         ,plotOutput("figure_1")%>% withSpinner(color="#0dc5c1") ))
      )
    )
  )
)



# Define server logic ----
server <- function(input, output, session){
  
  selected_study <<- 'none'
  selected_figure_1_param <<- 'none'

  observe({
    if (exists("figure_1")) {
      updateSelectInput(session, "param", choices = levels(factor(figure_1$paramcd)))
    }
  })
  
  observeEvent(input$refresh_btn, {
    
    showModal(modalDialog("Refreshing Database. Please wait 2-3 minutes until the process finishes.", footer=NULL))
    source("load_db.R") 
    removeModal()
    updateSelectInput(session, "study", choices = "none")
    session$reload()
  })
  
  output$all_rep = 
    downloadHandler(
      filename = function(){ 
      paste0("outputs_",selected_study,".rtf")},
      content = function(file){ 
        print(paste0("Selected Report -","outputs_",selected_study,".rtf"))
        file.copy(paste0("outputs_",selected_study,".rtf"),file)}
    )
  
  observeEvent(input$param, {
    
    print("Setting selected_figure_1_param")
    selected_figure_1_param <<- input$param
    
    output$figure_1 <- renderPlot({
      
      tmp_fig_1 = figure_1 %>% filter(avisitn != 0 & paramcd == selected_figure_1_param) %>% group_by(trtp,trtpn, avisit,avisitn,paramcd) %>% summarise(mean_chg=mean(chg))
      
      ggplot(tmp_fig_1, aes(x=avisitn, y=mean_chg, group=trtp,color = trtp)) +
        geom_line() +
        geom_point() + 
        theme_classic() + 
        theme(legend.position="bottom") + 
        labs(x = "Visit Number", y = paste0("Mean change from baseline for ",selected_figure_1_param))
      
    })
  
  })
  

  observeEvent(input$study, {
    
    print("Setting selected_study")
    selected_study <<- input$study
    
    if (selected_study!= "none"){
      
      if (!file.exists(paste0(selected_study,".RData"))) { 
        showModal(modalDialog("Refreshing Database. Please wait 2-3 minutes until the process finishes.", footer=NULL))
        source("load_db.R")
        removeModal()
      }
      
      load(paste0(selected_study,".RData"))
      

      output$table_1 <<- DT::renderDataTable({
        as.datatable_widget(table_1
                            ,colnames = table_1_columns
                            ,escape = FALSE
                            ,class = 'cell-border stripe dt-center nowrap'
                            ,extensions = list('Buttons' = NULL
                                               ,'FixedColumns' = NULL)
                            ,rownames = FALSE
                            ,options = list(dom = 'Bfrtip'
                                            ,buttons = list(list(extend = 'copy')
                                                            ,list(extend = 'csv',filename= 'Table 1 - Demographic Information')
                                                            ,list(extend = 'pdf',filename= 'Table 1 - Demographic Information')
                                                            ,list(extend = 'print')
                                                            ,list(extend = 'excel',filename= 'Table 1 - Demographic Information'))
                                            ,paging = FALSE
                                            ,scrollX = TRUE
                                            ,fixedColumns = list(leftColumns = 3))
        )})

            
      output$listing_1 <<- DT::renderDataTable({
        options(DT.options = list(dom = 'Bfrtip'
                                  ,class = 'cell-border stripe dt-center nowrap' 
                                  ,extensions = list('Buttons' = NULL
                                                     ,'FixedColumns' = NULL)
                                  ,buttons = list(list(extend = 'copy')
                                                  ,list(extend = 'csv',filename= 'Listing 1 - Adverse Events')
                                                  ,list(extend = 'pdf',filename= 'Listing 1 - Adverse Events')
                                                  ,list(extend = 'print')
                                                  ,list(extend = 'excel',filename= 'Listing 1 - Adverse Events'))
                                  ,paging = TRUE
                                  ,pageLength = 50
                                  ,scrollX = TRUE
                                  ,fixedColumns = list(leftColumns = 5)
        ))
        dat = DT::datatable(listing_1
                            ,rownames = FALSE) %>%
          DT::formatStyle("aeser"
                          ,target = "row"
                          ,backgroundColor = DT::styleEqual(c('Y'), c('red'))
          )
        return(dat)
      })
      
      output$legend_l1 <<- DT::renderDataTable({
        options(DT.options = list(class = 'cell-border stripe dt-center nowrap'
                                 ,paging = FALSE
                                 ,columnDefs = list(list(visible=FALSE, targets=c(0)))))
        
        dat = DT::datatable(legend_l1
                            ,rownames = FALSE) %>%
          DT::formatStyle("Color"
                         ,target = "row"
                         ,backgroundColor = DT::styleEqual(c(0), c('red'))
          )
        return(dat)
      })
      
    }
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)




