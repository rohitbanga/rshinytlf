#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                      
# Name         :  listing_1.R
# Description  :  Program to make Adverse Event Listing 1
# Input        :  Study Dataset - adae
#                 
#               
# Usage notes  :  Called from load_db.R program
#                 
#
#**********************************************************************************************************
# Programmer   :  Rohit Banga
# Date         :  19 Feb 2020 
# Change Log   :  
# Text         :  
#**********************************************************************************************************



########################################################################
###         Select Required Columns        ###
########################################################################

listing_1 = adae %>%
                 select(usubjid,trta,sex,agegr1,saffl,aeterm,aedecod,aesev,aeser,aescan,aescong,aesdisab,aesdth,aeshosp,aeslife,aerel,aeacn,aeout,trtemfl)

########################################################################
###         Make Legend Df        ###
########################################################################

legend_l1 = data.frame("Color" = 0, "Description" = c("AESER = Y"))





