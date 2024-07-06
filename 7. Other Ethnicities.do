
**** 7. Analysing Other Ethnicities
*** 7.1. Appending dataset including names from other ethnicities and preparing data
clear


use airbnb2, replace
append using othernamepanel2


local varlist  origin_other mediterranean anglosaxon easteurope origin_mix
foreach i of local varlist{
replace `i'=0 if `i'==.
}

drop if first_name=="ben"
duplicates tag id monthly, gen(dup)

tab first_name if dup==1

ren zone_t* touristz

drop zone_*  neighbourhood_*

drop if quartier=="NA"

tab quartier, gen(neighbourhood_)
tab touristz, gen(zone_)
save airbnbother2, replace

*** 7.2 Plotting Trends with Multiple Ethnicities

use airbnbother2.dta,replace
 gen ethnicity=.
 replace ethnicity=1 if french==1
  replace ethnicity=2 if arab==1
  replace ethnicity=3 if mediterranean==1
  replace ethnicity=4 if anglosaxon==1
  replace ethnicity=5 if easteurope==1
 
collapse adr_usd occupancy_rate log_price revenue listed_days (sum) samplemarker_occup if samplemarker_occup==1, by(monthly ethnicity)

 local varlist adr_usd occupancy_rate samplemarker_occup log_price revenue listed_days
 
foreach i of local varlist{
separate `i' , by(ethnicity) 
label variable `i'1 "French"
label variable `i'2 "Arab/Muslim"
label variable `i'4 "Anglo/German"
label variable `i'3 "S. European/Latin"
label variable `i'5 "Eastern European"

}

set scheme cleanplots
*** Paper Fig.18 Price Trends over Time for More Ethnicities
twoway line  adr_usd1 adr_usd2 adr_usd3 adr_usd4 adr_usd5 monthly, lwidth(medthick medthick medium medium medium) lpattern(solid solid dash dash dash) title("Avg. Daily Price over Time") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Price in USD") saving(pricecol, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Pricetrendother.eps", as(eps) preview(on) replace

*** Paper Fig.19 Price Trends over Time for More Ethnicities 
twoway line occupancy_rate1 occupancy_rate2 occupancy_rate3 occupancy_rate4 occupancy_rate5  monthly, lwidth(medthick medthick medium medium medium) lpattern(solid solid dash dash dash) title("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") tline(670) xtitle("") ytitle("Occupancy Rate") saving(occupcol, replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\Occupancytrendother.eps", as(eps) preview(on) replace


*** 7.3 Random-Effects with multiple ethnicities


use airbnbother2,replace


xtset id monthly

 
**7.3.1 Price Model 
xtreg log_price arab mediterranean anglosaxon easteurope  i.monthly  if samplemarker_price==1,re cluster(id)
estimates sto multi_e1
xtreg log_price arab mediterranean anglosaxon easteurope i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto multi_e2
xtreg log_price arab mediterranean anglosaxon easteurope i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto multi_e3


**7.3.2 Occupancy Rate Model 

xtreg occupancy_rate arab mediterranean anglosaxon easteurope i.monthly  if samplemarker_occup==1,re cluster(id)
estimates sto multi_e4
xtreg occupancy_rate arab mediterranean anglosaxon easteurope i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_occup==1, re cluster(id)
estimates sto multi_e5
xtreg occupancy_rate arab mediterranean anglosaxon easteurope i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_occup==1, re cluster(id)
estimates sto multi_e6

 
 *RE model multiple ethnicities - Table 14 in Paper
 esttab multi_e4 multi_e5 multi_e6 multi_e1 multi_e2 multi_e3  using remulti2.tex, replace keep(arab mediterranean anglosaxon easteurope)  label  title("Random-Effects Regression for Occupancy Rate and Log(Price)")  mtitles("(1)""(2)" "(3)" "(1)""(2)" "(3)" ) mgroups("Occupancy" "Price" , pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) nonumbers stats(N N_g r2_o r2) 


  

 
 
***OLS Controls
use airbnbother2.dta,replace




mat COEFF=J(41,25,.)
forvalues i=1(1)41{
local y=657+`i'
mat COEFF[`i',1]=`y'
reg log_price arab mediterranean anglosaxon easteurope origin_mix  guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if monthly==`y' & available_days>0

mat COEFF[`i',2]=_b[arab]
mat COEFF[`i',3]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',4]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',5]=_b[mediterranean]
mat COEFF[`i',6]=_b[mediterranean] - invttail(e(df_r),0.025)*_se[mediterranean]
mat COEFF[`i',7]=_b[mediterranean] + invttail(e(df_r),0.025)*_se[mediterranean]
mat COEFF[`i',8]=_b[anglosaxon]
mat COEFF[`i',9]=_b[anglosaxon] - invttail(e(df_r),0.025)*_se[anglosaxon]
mat COEFF[`i',10]=_b[anglosaxon] + invttail(e(df_r),0.025)*_se[anglosaxon]
mat COEFF[`i',11]=_b[easteurope]
mat COEFF[`i',12]=_b[easteurope] - invttail(e(df_r),0.025)*_se[easteurope]
mat COEFF[`i',13]=_b[easteurope] + invttail(e(df_r),0.025)*_se[easteurope]
reg occupancy_rate arab mediterranean anglosaxon easteurope origin_mix guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8* zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if  monthly==`y' & available_days>0
mat COEFF[`i',14]=_b[arab]
mat COEFF[`i',15]=_b[arab] - invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',16]=_b[arab] + invttail(e(df_r),0.025)*_se[arab]
mat COEFF[`i',17]=_b[mediterranean]
mat COEFF[`i',18]=_b[mediterranean] - invttail(e(df_r),0.025)*_se[mediterranean]
mat COEFF[`i',19]=_b[mediterranean] + invttail(e(df_r),0.025)*_se[mediterranean]
mat COEFF[`i',20]=_b[anglosaxon]
mat COEFF[`i',21]=_b[anglosaxon] - invttail(e(df_r),0.025)*_se[anglosaxon]
mat COEFF[`i',22]=_b[anglosaxon] + invttail(e(df_r),0.025)*_se[anglosaxon]
mat COEFF[`i',23]=_b[easteurope]
mat COEFF[`i',24]=_b[easteurope] - invttail(e(df_r),0.025)*_se[easteurope]
mat COEFF[`i',25]=_b[easteurope] + invttail(e(df_r),0.025)*_se[easteurope]

}




clear
svmat COEFF
ren COEFF1 month
format month %tm

ren COEFF2 arab_price
ren COEFF3 lb_arab_price
ren COEFF4 ub_arab_price
ren COEFF5 mediterranean_price
ren COEFF6 lb_mediterranean_price
ren COEFF7 ub_mediterranean_price
ren COEFF8 anglosaxon_price
ren COEFF9 lb_anglosaxon_price
ren COEFF10 ub_anglosaxon_price
ren COEFF11 easteurope_price
ren COEFF12 lb_easteurope_price
ren COEFF13 ub_easteurope_price
ren COEFF14 arab_occup
ren COEFF15 lb_arab_occup
ren COEFF16 ub_arab_occup
ren COEFF17 mediterranean_occup
ren COEFF18 lb_mediterranean_occup
ren COEFF19 ub_mediterranean_occup
ren COEFF20 anglosaxon_occup
ren COEFF21 lb_anglosaxon_occup
ren COEFF22 ub_anglosaxon_occup
ren COEFF23 easteurope_occup
ren COEFF24 lb_easteurope_occup
ren COEFF25 ub_easteurope_occup









twoway rcap ub_arab_price lb_arab_price month, lcolor(black) || scatter arab_price month,  mcolor (black) msize(vsmall) ||   (lfit arab_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Arab/Muslim) ytitle("") xtitle("") xlabel( "") xscale(r(658 698)) legend(off) saving(arabprice,replace) ytitle(, height(1)) 
twoway rcap ub_arab_occup lb_arab_occup month, lcolor(black) || scatter arab_occup month,  mcolor (black)  msize(vsmall) ||   (lfit arab_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit arab_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Arab/Muslim)  xtitle("") xlabel( "")  xscale(r(658 698)) legend(off) saving(araboccup,replace) ytitle(, height(1))
 
twoway rcap ub_mediterranean_price lb_mediterranean_price month, lcolor(black) || scatter mediterranean_price month,  mcolor (black)  msize(vsmall) ||   (lfit mediterranean_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit mediterranean_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Mediterranean)  xtitle("") xlabel( "") ytitle("") xscale(r(658 698)) legend(off) saving(medprice,replace) ytitle(, height(1)) 
twoway rcap ub_mediterranean_occup lb_mediterranean_occup month, lcolor(black) || scatter mediterranean_occup month,  mcolor (black)  msize(vsmall) ||   (lfit mediterranean_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit mediterranean_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title( Mediterranean ) ytitle(mediterranean) xtitle("") xlabel( "") ytitle("") xscale(r(658 698)) legend(off) saving(medoccup,replace) ytitle(, height(1))

twoway rcap ub_anglosaxon_price lb_anglosaxon_price month, lcolor(black) || scatter anglosaxon_price month,  mcolor (black) msize(vsmall)  ||   (lfit anglosaxon_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit anglosaxon_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Anglo-Saxon)  xtitle("")  xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018")  ytitle("") xscale(r(658 698)) legend(off) saving(angloprice,replace) ytitle(, height(1)) 
twoway rcap ub_anglosaxon_occup lb_anglosaxon_occup month, lcolor(black) || scatter anglosaxon_occup month,  mcolor (black) msize(vsmall)  ||   (lfit anglosaxon_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit anglosaxon_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Anglo-Saxon) ytitle("") xtitle("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") ytitle("") xscale(r(658 698)) legend(off) saving(anglooccup,replace) ytitle(, height(1))

twoway rcap ub_easteurope_price lb_easteurope_price month, lcolor(black) || scatter easteurope_price month,  mcolor (black) msize(vsmall)  ||   (lfit easteurope_price month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit easteurope_price month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Eastern European) xtitle("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") ytitle("") xscale(r(658 698)) legend(off) saving(eeprice,replace) ytitle(, height(1)) 
twoway rcap ub_easteurope_occup lb_easteurope_occup month, lcolor(black) || scatter easteurope_occup month,  mcolor (black) msize(vsmall)  ||   (lfit easteurope_occup month if month<670, lwidth(medthick)  lcolor(midblue)) ||  (lfit easteurope_occup month if month>670, lwidth(medthick) lcolor(maroon) ), tline(2015m11, lp(dash) lc(black)) yline(0, lcolor(gray)) graphregion(color(white)) title(Eastern European) xtitle("") xlabel( 658 "Nov 2014" 670 "Nov 2015" 684 "Jan 2017" 698 "Mar 2018") ytitle("") xscale(r(658 698)) legend(off) saving(eeoccup,replace) ytitle(, height(1))

***  Figure 20
 graph combine arabprice.gph medprice.gph angloprice.gph eeprice.gph,  col(2) ycommon title(Coefficients for Log(Price)) graphregion(color(white))
   graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\priceethnic1.eps", as(eps) preview(on) replace

*** Figure 21
  graph combine araboccup.gph medoccup.gph anglooccup.gph eeoccup.gph,  col(2)  title(Coefficients for Occupancy Rate) graphregion(color(white)) ycommon
   graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\occupethnic1.eps", as(eps) preview(on) replace   

   
   
   
   
*** Name Frequency Table
  
use airbnb2, replace
append using othernamepanel
local varlist  origin_other mediterranean anglosaxon easteurope origin_mix
foreach i of local varlist{
replace `i'=0 if `i'==.
}

drop if first_name=="jérémy"
duplicates report id monthly

drop neighbourhood*
drop neighborhood
ren id property_id
sort property_id
merge m:1 property_id using neighborhood.dta
ren property_id id

drop _merge

tostring neighborhood, replace
tab neighborhood, gen(neighbourhood_)

replace quartier=neighborhood if quartier==""

drop neighborhood*

tab quartier, gen(neighborhood_)

sort id

merge m:1 id using namedata

drop if _merge==1
 drop if french==.
 gen ethnicity=.
 replace ethnicity=1 if french==1
  replace ethnicity=2 if arab==1
  replace ethnicity=3 if mediterranean==1
  replace ethnicity=4 if anglosaxon==1
  replace ethnicity=5 if easteurope==1
  replace ethnicity=6 if origin_mix==1

  drop if ethnicity==6
save allnamesfinal.dta, replace
 bysort id: gen x= _n
 keep if x == 1
 sort ethnicity
by ethnicity: groups name , order(h) select(15)
save namecountdata, replace
