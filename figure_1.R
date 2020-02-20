#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                      
# Name         :  figure_1.R
# Description  :  Program to make Cog Analysis Figure 1
# Input        :  Study Dataset - adqsadas
#                 
#               
# Usage notes  :  Called from load_db.R program
#                 
#
#**********************************************************************************************************
# Programmer   :  Rohit Banga
# Date         :  17 Feb 2020 
# Change Log   :  
# Text         :  
#**********************************************************************************************************



########################################################################
###         Select Variables        ###
########################################################################

figure_1a = adqsadas %>%
  select(usubjid,trtp,trtpn,agegr1,sex,avisitn,avisit,param,paramcd,aval,base,chg,pchg)

figure_1a$trtpn<-as.factor(figure_1a$trtpn)
figure_1a$avisitn<-as.factor(figure_1a$avisitn)


figure_1 =figure_1a