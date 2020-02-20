#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                      
# Name         :  table_1.R
# Description  :  Program to make Demographic Table 1
# Input        :  Study Dataset - adsl
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
###         Count of Gender       ###
########################################################################
table_1a = sqldf("select 'Gender' as category
                         ,trt01a
                         ,sex as type
                         ,count(distinct usubjid) as count
                         ,1 as sort
                     from adsl
                 group by trt01a
                         ,sex"
                 )

########################################################################
###         Count of Age Group       ###
########################################################################

table_1b = sqldf("select 'Age Group' as category
                         ,trt01a
                         ,agegr1 as type
                         ,count(distinct usubjid) as count
                         ,2 as sort
                     from adsl
                 group by trt01a
                         ,agegr1"
                )

########################################################################
###         Count of Race       ###
########################################################################

table_1c = sqldf("select 'Race' as category
                         ,trt01a
                         ,race as type
                         ,count(distinct usubjid) as count
                         ,3 as sort
                     from adsl
                 group by trt01a
                         ,race"
                )

########################################################################
###         Count of Ethnicity       ###
########################################################################

table_1d = sqldf("select 'Ethnicity' as category
                        ,trt01a
                        ,ethnic as type
                        ,count(distinct usubjid) as count
                        ,4 as sort
                    from adsl
                group by trt01a
                        ,ethnic"
)



table1_a = rbind.fill(table_1a,table_1b,table_1c,table_1d)


table_1 = dcast(table1_a, sort+category+type~ trt01a,value.var = "count")


table_1_columns = colnames(table_1)



