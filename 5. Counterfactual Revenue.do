 
*5  Counterfactual revenue calculations



*** 5.1 Calculating Counterfactual Values based on the coefficients for A/M from the Model w. CTRLS & NO REVIEWS (stored under olscoeff.dta)
use airbnb2.dta,replace
sort month
merge m:1 monthly using olscoeffs
gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr
save counterfactual.dta, replace


*** 5.1.1 Total Revenue and Losses 
*** Overall
**  Results in Table 11 - Total Revenue - Overall - Calc &CTRLS
use counterfactual, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Pre Attack
** Results in Table 11 - Total Revenue - Pre-Attacks - Calc & CTRLS
use counterfactual, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly<670, by(arab)  
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Post Attack
** Total Revenue and Losses  - Results in Table 11 - Total Revenue - Post-Attacks - Calc & CTRLS
use counterfactual, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)  
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po


*** 5.1.2 Monthly Revenue and Losses 
*** Overall
**  Results in Table 3 - Overall - Calc & CTRLS
use counterfactual.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Pre Attack
** Results in Table 3 - Pre-Attack - Calc & CTRLS
use counterfactual.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly<670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Post Attack
** Results in Table 3 - Post-Attack - Calc & CTRLS
use counterfactual.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** 5.1.3 Daily Revenue and Losses 

**** Creating new counterfactual dataset
use airbnb2.dta,replace
sort month
merge m:1 monthly using olscoeffs
gen daily_revenue=occupancy_rate*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_occup_rate*adr_usd
gen counterfactual_revenue_price=occupancy_rate*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_occup_rate*counterfactual_adr
save counterfactualdaily.dta, replace

*** Overall
**  Results in Table 11 - Average Listing Revenue per Day Listed - Overall - Calc &CTRLS
use counterfactualdaily.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po

**  Results in Table 11 - Average Listing Revenue per Day Listed - Pre-Attack - Calc &CTRLS
use counterfactualdaily.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1 & monthly <670, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po

**  Results in Table 11 - Average Listing Revenue per Day Listed - Post-Attack - Calc & CTRLS
use counterfactualdaily.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1 & monthly >670, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po







*** 5.2 Calculating Counterfactual Values based on the coefficients for A/M from the Model w. CTRLS & REVIEWS (stored under olscoeff2.dta)
use airbnb2.dta,replace
sort month
merge m:1 monthly using olscoeffs2
gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr
save counterfactual2.dta, replace


*** 5.2.1 Total Revenue and Losses 
*** Overall
**  Results in Table 11 - Total Revenue - Overall - CTRLS & Revs
use counterfactual2, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Pre Attack
**  Results in Table 11 - Total Revenue - Pre-Attacks - CTRLS & Revs
use counterfactual2.dta, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly<670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Post Attack
**  Results in Table 11 - Total Revenue - Post-Attacks - CTRLS & Revs
use counterfactual2.dta, replace
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po


*** 5.2.2 Monthly Revenue and Losses 
*** Overall
**  Results in Table 3 - Overall - CTRLS & Revs
use counterfactual2.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po


*** Pre Attack
**  Results in Table 3 - Pre-Attacks - CTRLS & Revs
use counterfactual2.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly<670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Post Attack
**  Results in Table 3 - Post-Attack - CTRLS & Revs
use counterfactual2.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1  & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po



*** 5.2.3 Daily Revenue and Losses 

**** Creating new counterfactual dataset

use airbnb2.dta,replace
sort month
merge m:1 monthly using olscoeffs2
gen daily_revenue=occupancy_rate*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_occup_rate*adr_usd
gen counterfactual_revenue_price=occupancy_rate*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_occup_rate*counterfactual_adr
save counterfactualdaily2.dta, replace

*** Overall
**  Results in Table 11 - Average Listing Revenue per Day Listed - Overall - CTRLS & Rev
use counterfactualdaily2.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po

**  Results in Table 11 - Average Listing Revenue per Day Listed - Pre-Attack - CTRLS & Rev
use counterfactualdaily2.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1 & monthly <670, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po


**  Results in Table 11 - Average Listing Revenue per Day Listed - Post-Attack - CTRLS & Rev
use counterfactualdaily2.dta, replace
collapse (mean) daily_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po  if samplemarker_occup==1 & monthly >670, by(arab)
gen losses_occup=daily_revenue - counterfactual_revenue_occup
gen losses_price=daily_revenue - counterfactual_revenue_price
gen losses_po=daily_revenue - counterfactual_revenue_po





*** 5.3 Counterfactual Calulations Putting a Price on Additional Losses Due to Terror (for table 12)

 ***running OLS models giving an Arab coefficient for every month (Controls Only)

use airbnb2.dta,replace
forvalues i=1(1)28{
local y=670+`i'
gen arab_m_`y'=0
replace arab_m_`y'=1 if arab==1 & monthly==`y'
gen month_`y'=0
replace month_`y'=1 if monthly==`y'
}
reg occupancy_rate arab arab_m_671 arab_m_672 arab_m_673 arab_m_674 arab_m_675 arab_m_676 arab_m_677 arab_m_678 arab_m_679 arab_m_68* arab_m_69* month_671 month_672 month_673 month_674 month_675 month_676 month_677 month_678 month_679 month_68* month_69*  guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_occup==1 & monthly!=670

mat COEFF=J(28,3,.)
forvalues i=1(1)28{
local y=670+`i'
mat COEFF[`i',1]=`y'
mat COEFF[`i',2]=_b[arab_m_`y']
}

reg log_price arab arab_m_671 arab_m_672 arab_m_673 arab_m_674 arab_m_675 arab_m_676 arab_m_677 arab_m_678 arab_m_679 arab_m_68* arab_m_69* month_671 month_672 month_673 month_674 month_675 month_676 month_677 month_678 month_679 month_68* month_69*  guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_occup==1 & monthly!=670
forvalues i=1(1)28{
local y=670+`i'

mat COEFF[`i',3]=_b[arab_m_`y']
}
clear
svmat COEFF
ren COEFF1 month
format month %tm
ren COEFF2 arab_occup
ren COEFF3 arab_log_price
keep month arab_occup arab_log_price
ren month monthly
sort monthly
save olsterror.dta, replace


 ***running OLS models giving an Arab coefficient for every month (Controls & Reviews)
use airbnb2.dta,replace
forvalues i=1(1)28{
local y=670+`i'
gen arab_m_`y'=0
replace arab_m_`y'=1 if arab==1 & monthly==`y'
gen month_`y'=0
replace month_`y'=1 if monthly==`y'
}
reg occupancy_rate arab arab_m_671 arab_m_672 arab_m_673 arab_m_674 arab_m_675 arab_m_676 arab_m_677 arab_m_678 arab_m_679 arab_m_68* arab_m_69* month_671 month_672 month_673 month_674 month_675 month_676 month_677 month_678 month_679 month_68* month_69*  guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1 & monthly!=670
mat COEFF=J(28,3,.)
forvalues i=1(1)28{
local y=670+`i'
mat COEFF[`i',1]=`y'
mat COEFF[`i',2]=_b[arab_m_`y']
}
reg log_price arab arab_m_671 arab_m_672 arab_m_673 arab_m_674 arab_m_675 arab_m_676 arab_m_677 arab_m_678 arab_m_679 arab_m_68* arab_m_69* month_671 month_672 month_673 month_674 month_675 month_676 month_677 month_678 month_679 month_68* month_69*  guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1 & monthly!=670
forvalues i=1(1)28{
local y=670+`i'
mat COEFF[`i',3]=_b[arab_m_`y']
}
clear
svmat COEFF
ren COEFF1 month
format month %tm
ren COEFF2 arab_occup
ren COEFF3 arab_log_price
 keep month arab_occup arab_log_price
ren month monthly
sort monthly
save olsterror2.dta, replace





use airbnb2.dta,replace

sort month
** now counterfactual revenue is calculated to reflect what it would have been without the drop due to the terror attacks (based on moodel with controls no reviews)
merge m:1 monthly using olsterror
gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr

save counterfactual3.dta, replace


** Loss in Total revenue: This features in Table 12 column CTRLS for Total Ad. Revenue

collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po



** Loss in monthly revenue: This features in Table 12 column CTRLS for AVG Monthly Revenue
use counterfactual3.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po



** counterfactual revenue without the drop due to the terror attacks (based on moodel with controls and reviews)
use airbnb2.dta,replace
sort month
merge m:1 monthly using olsterror2
gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr
save counterfactual4.dta, replace

*** results in table 12 Total Additional Revenue CTRLS & REV
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** results in table 12 Avg Monththly Revenue CTRLS & REV
use counterfactual4.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po


** Fixed Effect Models Controls no Reviews for Table 12 Terror Counterfactuals 

 use airbnb2.dta,replace
gen arab_occup=.
replace arab_occup=-0.0228 if arab==1 & monthly>670
gen arab_log_price=.
replace arab_log_price=-0.0184 if arab==1 & monthly>670
 gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr
save counterfactual5.dta, replace

*** Results for Fixed Effect- Total Add. Revenue - Ctrls Column Table 12
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po

*** Results for Fixed Effect- Add. Avg. Monthly Revenue - Ctrls Column Table 12
use counterfactual5.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po



** Fixed Effect Models Controls &o Reviews for Table 12 Terror Counterfactuals 

 use airbnb2.dta,replace
gen arab_occup=.
replace arab_occup=-0.0261 if arab==1 & monthly>670
gen arab_log_price=.
replace arab_log_price=-0.0227 if arab==1 & monthly>670
 gen monthly_revenue=reservation_days*adr_usd
gen occupancy_rate2=reservation_days/listed_days
gen counterfactual_occup_rate= occupancy_rate-arab_occup if arab==1
gen counterfactual_res_days=counterfactual_occup_rate*listed_days
gen counterfactual_adr=adr_usd*(1-arab_log_price)  if arab==1
gen counterfactual_revenue_occup=counterfactual_res_days*adr_usd
gen counterfactual_revenue_price=reservation_days*counterfactual_adr
gen counterfactual_revenue_po=counterfactual_res_days*counterfactual_adr
save counterfactual6.dta, replace

*** Results for Fixed Effect- Total Add. Revenue - Ctrls & Revs Column Table 12
collapse (sum) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po



*** Results for Fixed Effect- Add. Avg. Monthly Revenue - Ctrls & Revs Column Table 12
use counterfactual6.dta, replace
collapse (mean) monthly_revenue counterfactual_revenue_occup counterfactual_revenue_price counterfactual_revenue_po if samplemarker_occup==1 & monthly>670, by(arab)
gen losses_occup=monthly_revenue - counterfactual_revenue_occup
gen losses_price=monthly_revenue - counterfactual_revenue_price
gen losses_po=monthly_revenue - counterfactual_revenue_po


 
