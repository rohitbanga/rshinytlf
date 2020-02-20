#**********************************************************************************************************
# Project      :  RShiny TLF Demo                                                                       
# Name         :  output_tlf_rtf.R
# Description  :  Output TLF in RTF Format
# Input        :  
#               
# Usage notes  :  
#                 
#
#**********************************************************************************************************
# Programmer   :  Rohit Banga
# Date         :  20 Feb 2020 
# Change Log   :  
# Text         :  
#**********************************************************************************************************

library(rtf)

outfile = paste0("outputs_",selected_study,".rtf")

#Make Example plot 
fig_1 = ggplot(figure_1 %>% filter(avisitn != 0 & paramcd == "ACITM01") %>% group_by(trtp,trtpn, avisit,avisitn,paramcd) %>% summarise(mean_chg=mean(chg))
                , aes(x=avisitn, y=mean_chg, group=trtp,color = trtp)) +
  geom_line() +
  geom_point() + 
  theme_classic() + 
  theme(legend.position="bottom") + 
  labs(x = "Visit Number", y = "Mean change from baseline for ACITM01")


rtf <- RTF(outfile)  
addHeader(rtf,title="Section 1 - Tables", subtitle="This Section contains all tables")
addParagraph(rtf, "Table 1 - Demographic Data:\n")
addTable(rtf, table_1)

addPageBreak(rtf, width=8.5, height=11, omi=c(1,1,1,1))
addHeader(rtf,title="Section 2 - Figures", subtitle="This Section contains all figures")
addParagraph(rtf, "Figure 1 - Cog Analysis - Mean change for baseline by visit:\n")
addPlot(rtf,plot.fun=print,width=5,height=4,res=300, fig_1)

addPageBreak(rtf, width=8.5, height=11, omi=c(1,1,1,1))
addHeader(rtf,title="Section 3 - Listings", subtitle="This Section contains all listings")
addParagraph(rtf, "\n\nListings 1 - Adverse Event Data:\n")
addTable(rtf, listing_1,font.size=6,row.names=FALSE,NA.string="", col.widths=c(0.6,0.5,0.3,0.3,0.3,0.5,0.5,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.6,0.3,0.6,0.3))
done(rtf)

