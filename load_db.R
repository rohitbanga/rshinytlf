#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                      
# Name         :  load_db.R
# Description  :  Program to load Study Datasets and run TLF programs
# Input        :  Study Datasets
#                 selected_study variable from app.R
#               
# Usage notes  :  Called from main_program
#                 
#
#**********************************************************************************************************
# Programmer   :  Rohit Banga
# Date         :  17 Feb 2020 
# Change Log   :  
# Text         :  
#**********************************************************************************************************


###############################################################################################
########## Clear Environment ##########
###############################################################################################

# Clear all environment except selected_study and dataset list
data_list = c("adsl","adae","adqsadas","table_1","listing_1","figure_1")
rm(list=setdiff(ls(), c("selected_study","data_list")
                ))


###############################################################################################
########## Make list of objects to keep ##########
###############################################################################################

keep_important_item = c( "keep_important_item", "i"
                         ,data_list
                         ,"selected_study","legend"
                         ,"table_1_columns"
                         ,"legend_l1"
                         
                         )

###############################################################################################



###############################################################################################
########## Load datasets from study to R environment  ##########
###############################################################################################

for(i in data_list){
  if (exists(i)) { 
    print(paste("Deleting Dataset",i))
    remove(list=i) 
    }
}

print(paste("#Reading data for",selected_study))

adsl = sasxport.get(paste0(selected_study,"/adsl.xpt"))
adae = sasxport.get(paste0(selected_study,"/adae.xpt"))
adqsadas = sasxport.get(paste0(selected_study,"/adqsadas.xpt"))




########################################################################################
### Run Code for Tables 
########################################################################################




print("#Run Code for Table 1")
rm(list=setdiff(ls(), keep_important_item))
source("table_1.R",local = TRUE)

print("#Run Code for Listing 1")
rm(list=setdiff(ls(), keep_important_item))
source("listing_1.R",local = TRUE)

print("#Run Code for Figure 1")
rm(list=setdiff(ls(), keep_important_item))
source("figure_1.R",local = TRUE)



########################################################################################
### Save Image 
########################################################################################

rm(list=setdiff(ls(), keep_important_item))

save.image(file = paste0(selected_study,".RData"))

########################################################################################
### Make TLF dataframes
########################################################################################

print("#Run Code for saving TLF as RTF")
source("output_tlf_rtf.R")


