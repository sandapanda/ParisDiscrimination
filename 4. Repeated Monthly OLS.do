
 
** 4. Repeated Monthly OLS MODELS

 * 4.1 OLS No Controls
 
use airbnb2.dta,replace

** Looping over 41 months running monthly regressions and storing estimates
mat COEFF=J(41,13,.)
forvalues i=1(1)41{
local y=657+`i'
mat COEFF[`i',1]=`y'
reg occupancy_rate arab  if monthly==`y' & samplemarker_occup==1
mat COEFF[`i',2]=_b[arab]
mat COEFF[`i',3]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',4]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg adr_usd arab if monthly==`y' & samplemarker_price==1
mat COEFF[`i',5]=_b[arab]
mat COEFF[`i',6]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',7]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg log_price arab if monthly==`y'  & samplemarker_price==1
mat COEFF[`i',8]=_b[arab]
mat COEFF[`i',9]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',10]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

capture reg exit arab  if monthly==`y' 
capture mat COEFF[`i',11]=_b[arab]
capture mat COEFF[`i',12]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
capture mat COEFF[`i',13]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

} 

clear
svmat COEFF
ren COEFF1 month
format month %tm

ren COEFF2 arab_occup
ren COEFF3 lb_occup
ren COEFF4 ub_occup
ren COEFF5 arab_price
ren COEFF6 lb_price
ren COEFF7 ub_price
ren COEFF8 arab_log_price
ren COEFF9 lb_log_price
ren COEFF10 ub_log_price
ren COEFF11 arab_exit
ren COEFF12 lb_exit
ren COEFF13 ub_exit


tsset month


set scheme cleanplots

*Graph of monthly effects on occupany rate no control (Figure 11)
twoway rcap ub_occup lb_occup month, lcolor(black) || scatter arab_occup month,  mcolor (black)  ||  (lfit arab_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Monthly OLS (No Controls):  Arab/Muslim Coefficients) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Occupancy Rate") xscale(r(658 698)) legend(off) saving(occupmonthly,replace) ytitle(, height(1))
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\occup_month_no_controls.eps", as(eps) preview(on) replace

 *Graph of monthly effects on price no control (Figure 12)
 twoway rcap ub_log_price lb_log_price month, lcolor(black) || scatter arab_log_price month, mcolor(black) ||  (lfit arab_log_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_log_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") title(Monthly OLS (No Controls):  Arab/Muslim Coefficients)  ytitle("Log (Price)", margin(0 -6 0 0)) legend(off) xscale(r(658 698))  saving(pricemonthly,replace) ytitle(, height(1))
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\price_month_no_controls.eps", as(eps) preview(on) replace

 
* 4.2 Monthly OLS with Controls

use airbnb2.dta,replace

mat COEFF=J(41,19,.)
forvalues i=1(1)41{
local y=657+`i'
mat COEFF[`i',1]=`y'
reg occupancy_rate arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y' & samplemarker_occup==1
mat COEFF[`i',2]=_b[arab]
mat COEFF[`i',3]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',4]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg adr_usd arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y' & samplemarker_price==1 
mat COEFF[`i',5]=_b[arab]
mat COEFF[`i',6]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',7]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg log_price arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y'  & samplemarker_price==1
mat COEFF[`i',8]=_b[arab]
mat COEFF[`i',9]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',10]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

capture reg exit2 arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y' 
mat COEFF[`i',11]=_b[arab]
mat COEFF[`i',12]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',13]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

capture reg revenue arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y' 
mat COEFF[`i',14]=_b[arab]
mat COEFF[`i',15]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',16]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg occupancy_rate arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if monthly==`y' & samplemarker_price==1
mat COEFF[`i',17]=_b[arab]
mat COEFF[`i',18]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',19]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

}


clear
svmat COEFF
ren COEFF1 month
format month %tm

ren COEFF2 arab_occup
ren COEFF3 lb_occup
ren COEFF4 ub_occup
ren COEFF5 arab_price
ren COEFF6 lb_price
ren COEFF7 ub_price
ren COEFF8 arab_log_price
ren COEFF9 lb_log_price
ren COEFF10 ub_log_price
ren COEFF11 arab_exit
ren COEFF12 lb_exit
ren COEFF13 ub_exit
ren COEFF14 arab_revenue
ren COEFF15 lb_revenue
ren COEFF16 ub_revenue
ren COEFF17 arab_occup_p
ren COEFF18 lb_occup_p
ren COEFF19 ub_occup_p
tsset month


 set scheme cleanplots
*** Revenue (controls no reviews) - Fig. 15
 twoway rcap ub_revenue lb_revenue month, lcolor(black) || scatter arab_revenue month,  mcolor (black)  ||  (lfit arab_revenue month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_revenue month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Monthly OLS (Full Controls w/o Reviews): Arab/Muslim Coefficients) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Monthly Revenue in USD") xscale(r(658 698)) legend(off) saving(revenuemonthly,replace) ytitle(, height(1)) 
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\revenue_month_controls.eps", as(eps) preview(on) replace
 
 *** Occupancy (controls no reviews) - Enters Fig. 2
twoway rcap ub_occup lb_occup month, lcolor(black) || scatter arab_occup month,  mcolor (black)  ||  (lfit arab_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Arab/Muslim Coefficients) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Occupany Rate") xscale(r(658 698)) legend(off) saving(occupmonthly,replace) ytitle(, height(1))  
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\occup_month_controls.eps", as(eps) preview(on) replace

 *** Occupancy - Price Sample (controls no reviews) - Fig. 17
twoway rcap ub_occup_p lb_occup_p month, lcolor(black) || scatter arab_occup_p month,  mcolor (black)  ||  (lfit arab_occup_p month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Arab/Muslim Coefficients (Price Sample, Controls, No Reviews)) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Occupany Rate") xscale(r(658 698)) legend(off) ytitle(, height(1))
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\occup_month_controls_pricesample.eps", as(eps) preview(on) replace


 *** Price (controls no reviews) - Enters Fig. 2
twoway rcap ub_log_price lb_log_price month, lcolor(black) || scatter arab_log_price month, mcolor(black) ||  (lfit arab_log_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_log_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) ytitle(Arab) xtitle("") xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Log (Price)", margin(0 -6 0 0)) legend(off) xscale(r(658 698))  saving(pricemonthly,replace) ytitle(, height(1))
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\price_month_controls.eps", as(eps) preview(on) replace

 
* Putting together all the elements for Fig. 2

 graph combine occupmonthly.gph pricemonthly.gph, xcommon col(1) saving(coefficients, replace) 
 grc1leg occupcol.gph pricecol.gph, xcommon  col(1) saving(trends, replace) 
 graph combine trends.gph coefficients.gph, graphregion(color(white)) 
   graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\graph2.eps", as(eps) preview(on) replace

*saving coefficients for counterfactual calculationbs in Section 5
keep month arab_occup arab_log_price
ren month monthly
sort monthly
save olscoeffs.dta, replace
   
   
* 4.3 Monthly OLS with Controls & Reviews

use airbnb2.dta,replace

mat COEFF=J(41,16,.)
forvalues i=1(1)41{
local y=657+`i'
mat COEFF[`i',1]=`y'
reg occupancy_rate arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if monthly==`y' & samplemarker_occup==1
mat COEFF[`i',2]=_b[arab]
mat COEFF[`i',3]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',4]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg adr_usd arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if monthly==`y' & samplemarker_price==1
mat COEFF[`i',5]=_b[arab]
mat COEFF[`i',6]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',7]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

reg log_price arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  zone_12 if monthly==`y'  & samplemarker_price==1
mat COEFF[`i',8]=_b[arab]
mat COEFF[`i',9]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',10]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

capture reg exit2 arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if monthly==`y' 
capture mat COEFF[`i',11]=_b[arab]
capture mat COEFF[`i',12]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
capture mat COEFF[`i',13]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

capture reg revenue arab guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if monthly==`y' 
capture mat COEFF[`i',14]=_b[arab]
capture mat COEFF[`i',15]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
capture mat COEFF[`i',16]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]

}


clear
svmat COEFF
ren COEFF1 month
format month %tm

ren COEFF2 arab_occup
ren COEFF3 lb_occup
ren COEFF4 ub_occup
ren COEFF5 arab_price
ren COEFF6 lb_price
ren COEFF7 ub_price
ren COEFF8 arab_log_price
ren COEFF9 lb_log_price
ren COEFF10 ub_log_price
ren COEFF11 arab_exit
ren COEFF12 lb_exit
ren COEFF13 ub_exit
ren COEFF14 arab_revenue
ren COEFF15 lb_revenue
ren COEFF16 ub_revenue

tsset month

* set scheme plottig
* set scheme plotplain
*set scheme cleanplots
set scheme s2color

 
tsset month
*** Revenue (full controls) - Fig. 16
 set scheme cleanplots
 twoway rcap ub_revenue lb_revenue month, lcolor(black) || scatter arab_revenue month,  mcolor (black)  ||  (lfit arab_revenue month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_revenue month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Monthly OLS (Full Controls): Arab/Muslim Coefficients) ytitle(Monthly Revenue in USD) xtitle("")  xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") xscale(r(658 698)) legend(off) saving(revenuemonthly,replace) ytitle(, height(1))
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\revenue_month_reviews.eps", as(eps) preview(on) replace

 *** Occupancy (full controls) - Fig. 13
set scheme cleanplots
twoway rcap ub_occup lb_occup month, lcolor(black) || scatter arab_occup month,  mcolor (black)  ||  (lfit arab_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Monthly OLS (Full Controls):  Arab/Muslim Coefficients) ytitle(Arab) xtitle("")  xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") ytitle("Occupancy Rate") xscale(r(658 698)) legend(off) saving(occupmonthly,replace) ytitle(, height(1))
graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\occup_month_reviews.eps", as(eps) preview(on) replace

 *** price (full controls) - Fig. 14
twoway rcap ub_log_price lb_log_price month, lcolor(black) || scatter arab_log_price month, mcolor(black) ||  (lfit arab_log_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_log_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) ytitle(Arab) xtitle("")  xlabel(658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 697 "Feb 2018") title(Monthly OLS (Full Controls):  Arab/Muslim Coefficients)  ytitle("Log (Price)", margin(0 -6 0 0)) legend(off) xscale(r(658 698))  saving(pricemonthly,replace) ytitle(, height(1))
graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\price_month_reviews.eps", as(eps) preview(on) replace



*saving regression coefficients for counterfactual revenue calculations
 keep month arab_occup arab_log_price
ren month monthly
sort monthly
save olscoeffs2.dta, replace
