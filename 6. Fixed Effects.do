
 
 
* 6.  Fixed Effects Models
use airbnb2, replace
gen post_attack=0
replace post_attack=1 if monthly>670
replace post_attack=. if monthly==670
gen arab_attack=arab*post_attack
*** adjusting variables for better scaling
replace photos=photos/10
replace reviews=reviews/10
replace rating_overall2=rating_overall2/2 
replace rating_communication=rating_communication/2
replace rating_accuracy=rating_accuracy/2
replace rating_cleanliness=rating_cleanliness/2
replace rating_checkin=rating_checkin/2
replace rating_location=rating_location/2 
**labelling
label variable photos "No. of photos (x10)"
label variable reviews "No. of Reviews (x10)"

**6.1. Fixed Effects and Random Effects, Post Attack Estimaees: Table 2 in Paper

xtset id monthly
xtreg log_price post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_price==1, cluster(id)
estimates sto fecomp1

xtreg occupancy_rate post_attack arab_attack  arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_occup==1, cluster(id)
estimates sto fecomp2

xtreg log_price post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict  if samplemarker_price==1, fe
estimates sto fecomp3

xtreg occupancy_rate post_attack arab_attack photos  instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict  if samplemarker_occup==1, fe
estimates sto fecomp4

xtreg log_price arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly  if samplemarker_price==1, fe
estimates sto fecomp5

xtreg occupancy_rate arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly  if samplemarker_occup==1, fe
estimates sto fecomp6

 esttab fecomp1 fecomp3 fecomp5 fecomp2 fecomp4 fecomp6 using fecomp.tex, replace keep(arab post_attack arab_attack )  label  title("Fixed-Effects Regressions")  mtitles("(1)""(2)" "(3)" "(1)""(2)" "(3)" ) mgroups("Occupancy" "Price" , pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) nonumbers stats(N N_g r2_o r2) 

 
 
 **6.2. Fixed Effects (Longer Annex Tables)
 **6.2.1 Price (Table 8)


xtreg log_price post_attack arab_attack arab  if samplemarker_price==1, cluster(id)
estimates sto feprice1 
 
xtreg log_price post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_price==1, cluster(id)
estimates sto feprice2

xtreg log_price post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, cluster(id)
estimates sto feprice3

xtreg log_price post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict  if samplemarker_price==1,fe
estimates sto feprice4

xtreg log_price post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, fe
estimates sto feprice5

xtreg log_price arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly  if samplemarker_occup==1, fe
estimates sto feprice6

xtreg log_price arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1, fe
estimates sto feprice7

 esttab feprice1 feprice2 feprice3 feprice4 feprice5 feprice6 feprice7 using feprice.tex, replace keep(arab post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests photos bedrooms bathrooms rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location)  label  title("Fixed-Effects Regressions")  mtitles("(1)""(2)" "(3)" "(4)""(5)" "(6)" "(7)")  nonumbers stats(N N_g r2_o) 
 
 
 
 
 
 **6.2.2 Occupancy Rate (Table 9)

xtreg occupancy_rate post_attack arab_attack arab  if samplemarker_price==1, cluster(id)
estimates sto feoccup1 
 
xtreg occupancy_rate post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_price==1, cluster(id)
estimates sto feoccup2

xtreg occupancy_rate post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, cluster(id)
estimates sto feoccup3

xtreg occupancy_rate post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict  if samplemarker_price==1,fe
estimates sto feoccup4

xtreg occupancy_rate post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, fe
estimates sto feoccup5

xtreg occupancy_rate arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly  if samplemarker_occup==1, fe
estimates sto feoccup6

xtreg occupancy_rate arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1, fe
estimates sto feoccup7

 esttab feoccup1 feoccup2 feoccup3 feoccup4 feoccup5 feoccup6 feoccup7 using feoccup.tex, replace keep(arab post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests photos bedrooms bathrooms rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location)  label  title("Fixed-Effects Regressions")  mtitles("(1)""(2)" "(3)" "(4)""(5)" "(6)" "(7)")  nonumbers stats(N N_g r2_o) 
 

  **6.2.3 Revenue (Table 10)

xtreg revenue post_attack arab_attack arab  if samplemarker_price==1, cluster(id)
estimates sto ferev1 
 
xtreg revenue post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12 if samplemarker_price==1, cluster(id)
estimates sto ferev2

xtreg revenue post_attack arab_attack arab photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests bedrooms bathrooms listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, cluster(id)
estimates sto ferev3

xtreg revenue post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict  if samplemarker_price==1,fe
estimates sto ferev4

xtreg revenue post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location if samplemarker_price==1, fe
estimates sto ferev5

xtreg revenue arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly  if samplemarker_occup==1, fe
estimates sto ferev6

xtreg revenue arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict i.monthly rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1, fe
estimates sto ferev7

 esttab ferev1 ferev2 ferev3 ferev4 ferev5 ferev6 ferev7 using ferev.tex, replace keep(arab post_attack arab_attack photos instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict guests photos bedrooms bathrooms rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location)  label  title("Fixed-Effects Regressions")  mtitles("(1)""(2)" "(3)" "(4)""(5)" "(6)" "(7)")  nonumbers stats(N N_g r2_o) 
 
 
 
 
 
 
  

use airbnb2.dta,replace
 
forvalues i=658(1)698{
gen arab_month_`i'=0
replace arab_month_`i'=arab if monthly==`i'
}

forvalues i=658(1)698{
gen month_`i'=0
replace month_`i'=1 if monthly==`i'
}
  
save airbnbpanel.dta, replace



