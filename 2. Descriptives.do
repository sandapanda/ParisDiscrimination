
**** 2. Descriptive Statistcs
eststo clear
use airbnb2.dta,replace

**** 2.1. descriptive table (Paper Table 1) - code outputs a latex file integrateable into paper

local varlist female adr_usd occupancy_rate reservation_days listed_days revenue guest bedrooms bathrooms listing_shared listing_private listing_entire cancel_pol_strict cancel_pol_moderate cancel_pol_flex  photos  minstay instantbook business_read superhost reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location 
estpost sum `varlist' if arab==0 & samplemarker_occup==1 
est store a
estpost sum `varlist' if arab==1 & samplemarker_occup==1 
est store b
quietly estpost sum `varlist' if arab==0 & samplemarker_occup==1 & monthly==660
est store c
quietly estpost sum `varlist' if arab==1 & samplemarker_occup==1 & monthly==660
est store d
quietly estpost sum `varlist' if arab==0 & samplemarker_occup==1 & monthly==696
est store e
quietly estpost sum `varlist' if arab==1 & samplemarker_occup==1 & monthly==696
est store f

esttab a b c d e f using desc.tex, replace ///
mtitles("\textbf{\emph{French}}" "\textbf{\emph{Arab}}" "\textbf{\emph{French}} " "\textbf{\emph{Arab}}" "\textbf{\emph{French}} " "\textbf{\emph{Arab}}")  ///
cells(mean(fmt(2)) sd(par fmt(2))) label nonumber f alignment(S) booktabs




** 2.2 Descriptive Graphs 
eststo clear
use airbnb2.dta,replace
collapse adr_usd occupancy_rate log_price revenue listed_days (sum) samplemarker_occup if samplemarker_occup==1, by(monthly arab)

 local varlist adr_usd occupancy_rate samplemarker_occup log_price revenue listed_days
foreach i of local varlist{
separate `i' , by(arab) 
label variable `i'0 "French"
label variable `i'1 "Arab/Muslim"
}


gen arab_share =samplemarker_occup1/(samplemarker_occup0[_n-1]+samplemarker_occup1)
label variable arab_share "Share of Arab Appartments"

***  PRICE (enters into Fig. 2)

set scheme cleanplots
twoway line adr_usd0 adr_usd1 monthly,  xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Price in USD") saving(pricecol, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Pricetrendcolor.eps", as(eps) preview(on) replace

set scheme plotplain
 twoway line adr_usd0 adr_usd1 monthly,  xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Price in USD") saving(pricebw, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Pricetrendbw.eps", as(eps) preview(on) replace
 
 
  ***OCCUPANCY RATE (enters into Fig. 2)
 
  set scheme cleanplots
twoway line occupancy_rate0 occupancy_rate1 monthly, title("Avg. Monthly Occupancy Rate and Price over Time") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Occupancy Rate") saving(occupcol, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Occuptrendscolor.eps", as(eps) preview(on) replace
 
 set scheme plotplain
twoway line occupancy_rate0 occupancy_rate1 monthly, title("Monthly Occupancy Rate and Price over Time") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Occupancy Rate") saving(occupbw, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Occuptrendsbw.eps", as(eps) preview(on) replace


 
  ***Number of Listings (Fig. 6)

   set scheme cleanplots
twoway line samplemarker_occup0 samplemarker_occup1 monthly, title("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Number of Active Listings") 
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Numbercol.eps", as(eps) preview(on) replace

   set scheme plotplain
twoway line samplemarker_occup0 samplemarker_occup1 monthly, title("Number of Airbnb Listings") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") xtitle("") ytitle("Listings") 
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Numberbw.eps", as(eps) preview(on) replace
 
 
 
 
 ***LOG PRICE (Fig. 8)
 
 set scheme cleanplots
 twoway line log_price0 log_price1 monthly, title("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Average log (Price)")
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\logPricetrendscolor.eps", as(eps) preview(on) replace
 
  set scheme plotplain
 twoway line log_price0 log_price1 monthly, title("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Average log (Price)")
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\logPricetrendsbw.eps", as(eps) preview(on) replace

 
    ***Days Listed (Fig.9 )
 
 set scheme cleanplots
 twoway line listed_days0 listed_days1 monthly, xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Average Number of Days Listed") yscale(r(0 30)) ylabel( 0 5 10 15 20 25 30)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Daystrend.eps", as(eps) preview(on) replace
 
  set scheme plotplain
 twoway line revenue0 revenue1 monthly, title("Revenue") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Monthly Revenue in USD")
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Daystrendbw.eps", as(eps) preview(on) replace
 
 
  ***Revenue (Fig. 10)
 
 set scheme cleanplots
 twoway line revenue0 revenue1 monthly, title() xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Average Monthly Revenue in USD")
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Revenuetrend.eps", as(eps) preview(on) replace
 
  set scheme plotplain
 twoway line revenue0 revenue1 monthly, title("Monthly Average Revenue") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Monthly Revenue in USD")
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Revenuetrendbw.eps", as(eps) preview(on) replace
 
 
  ***Exit Rate(Fig. 7)

 
eststo clear
use airbnb2.dta,replace


collapse  entry reentry any_entry exit2 temp_exit any_exit, by(monthly arab)


 local varlist   entry reentry any_entry exit2 temp_exit any_exit
foreach i of local varlist{
separate `i' , by(arab) 
label variable `i'0 "French"
label variable `i'1 "Arab/Muslim"
}


set scheme cleanplots
twoway line exit20 exit21 monthly if monthly<698, title("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") tline(670) xtitle("Month") ytitle("Proportion of Exits")
graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Exitcolor.eps", as(eps) preview(on) replace 

set scheme plotplain
twoway line exit20 exit21 monthly if monthly<698, title("Apartment Exit Rate") xlabel( 658 "Jan 2015" 670 "Nov 2015 (Paris Attack)" 684 "Jan 2017" 696 "Jan 2018") tline(670) xtitle("Month") ytitle("Share of Appartments Exiting Market")
graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Exitbw.eps", as(eps) preview(on) replace 
