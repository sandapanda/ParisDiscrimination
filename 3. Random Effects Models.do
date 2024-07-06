***3. Random Effects Models


use airbnb2.dta,replace



gen male=.
replace male=1 if female==0
replace male=0 if female==1
gen arab_men=arab*male
gen arab_women=arab*female
gen french_women=french*female

* Labels
label variable arab_men "Arab/Muslim Men"
label variable arab_women "Arab/Muslim Women"
label variable french_women "French Women"
label variable photos "No. of photos (x10)"
label variable reviews "No. of Reviews (x10)"

*** adjusting variables for better scaling
replace photos=photos/10
replace reviews=reviews/10
replace rating_overall2=rating_overall2/2 
replace rating_communication=rating_communication/2
replace rating_accuracy=rating_accuracy/2
replace rating_cleanliness=rating_cleanliness/2
replace rating_checkin=rating_checkin/2
replace rating_location=rating_location/2 


** panel setup
xtset id monthly

**3.1 Price Model 

xtreg log_price arab i.monthly  if samplemarker_price==1,re cluster(id)
estimates sto m11
xtreg log_price arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto m12
xtreg log_price arab i.monthly guests arab_guests photos arab_photos bedrooms arab_bedrooms bathrooms arab_bathrooms instantbook arab_instantbook business_ready arab_business_ready superhost arab_superhost minstay arab_minstay cancel_pol_moderate arab_cancel_pol_moderate cancel_pol_strict arab_cancel_pol_strict listing_private arab_listing_private listing_shared arab_listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto m13
xtreg log_price arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_price==1, re cluster(id)
estimates sto m14
xtreg log_price arab i.monthly guests arab_guests photos arab_photos bedrooms arab_bedrooms bathrooms arab_bathrooms instantbook arab_instantbook business_ready arab_business_ready superhost arab_superhost minstay arab_minstay cancel_pol_moderate arab_cancel_pol_moderate cancel_pol_strict arab_cancel_pol_strict listing_private arab_listing_private listing_shared arab_listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location arab_reviews arab_rating_overall arab_rating_communication arab_rating_accuracy arab_rating_cleanliness arab_rating_checkin arab_rating_location  if samplemarker_price==1, re  cluster(id)
estimates sto m15



**3.2 Occupancy Rate Model 


xtreg occupancy_rate arab i.monthly  if samplemarker_occup==1,re cluster(id)
estimates sto m16
xtreg occupancy_rate arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_occup==1, re cluster(id)
estimates sto m17
xtreg occupancy_rate arab i.monthly guests arab_guests photos arab_photos bedrooms arab_bedrooms bathrooms arab_bathrooms instantbook arab_instantbook business_ready arab_business_ready superhost arab_superhost minstay arab_minstay cancel_pol_moderate arab_cancel_pol_moderate cancel_pol_strict arab_cancel_pol_strict listing_private arab_listing_private listing_shared arab_listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_occup==1, re cluster(id)
estimates sto m18
xtreg occupancy_rate arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1, re  cluster(id)
estimates sto m19
xtreg occupancy_rate arab i.monthly guests arab_guests photos arab_photos bedrooms arab_bedrooms bathrooms arab_bathrooms instantbook arab_instantbook business_ready arab_business_ready superhost arab_superhost minstay arab_minstay cancel_pol_moderate arab_cancel_pol_moderate cancel_pol_strict arab_cancel_pol_strict listing_private arab_listing_private listing_shared arab_listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location arab_reviews arab_rating_overall arab_rating_communication arab_rating_accuracy arab_rating_cleanliness arab_rating_checkin arab_rating_location  if samplemarker_occup==1, re cluster(id)
estimates sto m20





**coefplot (figure 1, hand changes, make labels horizontal and box white)
 
 coefplot (m11, offset(.2) label (Time Fixed Effects) xscale(range(-.2 .3)) xlabel(-.2(.1).2)) (m12, offset(.1) label (Time & Neighbourhood & Listing Controls) xscale(range(-.2 .3))) (m14, offset(-.2) xscale(range(-.2 .3))), bylabel(Price) || (m16, offset(.2) xscale(range(-.2 .2))) (m17) (m19, offset(-.2) label (Time & Neighbourhood & Listing & Review Controls)) , byopts(title("Discrimination against Hosts")) bylabel(Occupancy Rate) keep(arab guests photos bedrooms bathrooms instantbook ///
business_ready superhost   reviews ///
rating_overall2 ) ///
 xline(0, lcolor(black) lwidth(thin) lpattern(dash)) ///
 groups(arab="{bf:Hosts}" guests photos bedrooms bathrooms instantbook business_ready superhost ="{bf:Appartment}"  ///
 rating_overall2  reviews="{bf:Reviews}")   saving(coeffs2.gph,replace)
 graph export "C:\Users\sande\Google Drive\Research\Projects\Airbnb\new_empirics\coefplot2.eps", as(eps) preview(on) replace
 
 
save coefficientsremodel, replace
 
 *RE model (table4)
 esttab m16 m17 m19 m11 m12 m14 using re22.tex, replace keep(arab guests photos bedrooms bathrooms instantbook  business_ready superhost minstay  cancel_pol_moderate cancel_pol_strict listing_private  listing_shared rating_overall2  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location reviews)  label  title("Random-Effects Regression for Occupancy Rate and Log(Price)")  mtitles("(1)""(2)" "(3)" "(1)""(2)" "(3)" ) mgroups("Occupancy" "Price" , pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) nonumbers stats(N N_g r2_o r2) 

 
 **3.3 Price Levels Model
  
  xtreg adr_usd arab i.monthly  if samplemarker_price==1,re cluster(id)
estimates sto pl1a
xtreg adr_usd arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto pl2a
xtreg adr_usd arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_price==1, re cluster(id)
estimates sto pl3a

 
 **3.4 Revenue Model


 xtreg revenue arab i.monthly  if samplemarker_occup==1,re cluster(id)
estimates sto rev1a
xtreg revenue arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_occup==1, re cluster(id)
estimates sto rev2a
xtreg revenue arab  i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_occup==1, re cluster(id)
estimates sto rev3a


 *RE model revenue (table5)
 esttab pl1a pl2a pl3a rev1a rev2a rev3a using reva2.tex, replace keep(arab guests photos bedrooms bathrooms instantbook  business_ready superhost minstay  cancel_pol_moderate cancel_pol_strict listing_private  listing_shared rating_overall2  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location reviews)  label  title("Random-Effects Regression for Price and Revenue in USD")  mtitles("(1)""(2)" "(3)" "(1)""(2)" "(3)" ) mgroups("Occupancy Rate" "Revenue" , pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) nonumbers stats(N N_g r2_o r2) 

 


 **3.5 Model Occupancy Rate on Price Sample

 xtreg occupancy_rate arab i.monthly  if samplemarker_price==1,re cluster(id)
estimates sto orp1a
xtreg occupancy_rate arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  if samplemarker_price==1, re cluster(id)
estimates sto orp2a
xtreg occupancy_rate arab i.monthly guests photos bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared neighbourhood_1* neighbourhood_2* neighbourhood_3* neighbourhood_4* neighbourhood_5* neighbourhood_6* neighbourhood_7* neighbourhood_8*  zone_1 zone_2 zone_3 zone_4 zone_5 zone_6 zone_7 zone_8 zone_9 zone_10 zone_11 zone_12  reviews rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location  if samplemarker_price==1, re cluster(id)
estimates sto orp3a


  *RE model OR (table6)
 esttab orp1a orp2a orp3a using orp2.tex, replace keep(arab guests photos bedrooms bathrooms instantbook  business_ready superhost minstay  cancel_pol_moderate cancel_pol_strict listing_private  listing_shared rating_overall2  rating_communication reviews  rating_accuracy rating_cleanliness rating_checkin rating_location reviews)  label  title("Random-Effects Regression for Occupancy Rate (Price Sample)")  mtitles("(1)""(2)" "(3)" ) nonumbers stats(N N_g r2_o r2) 

 