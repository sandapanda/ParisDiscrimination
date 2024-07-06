
*** 1. Setting up the data
cd "/Users/sander/Library/CloudStorage/GoogleDrive-sanderwagner@gmail.com/My Drive/Research/Projects/Airbnb/Datawork/empirics"

*cd "G:\My Drive\Research\Projects\Airbnb\Datawork\empirics"
use property_airbnb.dta, replace

*dropping variables
drop v1
drop id_row

*renaming and cleaning up variables
ren property_id id

*renaming and cleaning up variables
gen month=date(reporting_month,"YMD")
format month %td
drop reporting_month

ren max_guests_maj guests
replace guests="." if guests=="NA"
destring guests, replace

ren number_of_reviews_maj reviews
replace reviews="." if reviews=="NA"
destring reviews, replace

ren number_of_photos_maj photos
replace photos="." if photos=="NA"
destring photos, replace

ren instantbook_enabled_ma instantbook
replace instantbook="." if instantbook=="NA"
replace instantbook="1" if instantbook=="True"
replace instantbook="0" if instantbook=="False"
destring instantbook, replace
label define truefalse 0 "False" 1 "True"
label values instantbook truefalse

ren business_ready_maj business_ready
replace business_ready="." if business_ready=="NA"
replace business_ready="1" if business_ready=="True"
replace business_ready="0" if business_ready=="False"
destring business_ready, replace
label values business_ready truefalse

ren superhost_maj superhost
replace superhost="." if superhost=="NA"
replace superhost="1" if superhost=="True"
replace superhost="0" if superhost=="False"
destring superhost, replace
label values superhost truefalse

ren minimum_stay2_maj minstay
replace minstay="." if minstay=="NA"
destring minstay, replace

ren cancellation_policy_maj cancel_pol
replace cancel_pol="." if cancel_pol=="NA"
replace cancel_pol="0" if cancel_pol=="Flexible"
replace cancel_pol="1" if cancel_pol=="Moderate"
replace cancel_pol="2" if cancel_pol=="Strict"
replace cancel_pol="2" if cancel_pol=="Super Strict 30 Days"
destring cancel_pol,replace
label define cancel 0 "Flexible" 1 "Moderate" 2 "Strict" 
label values cancel_pol cancel
gen cancel_pol_flex=.
replace cancel_pol_flex=0 if cancel_pol!=.
replace cancel_pol_flex=1 if cancel_pol==0
gen cancel_pol_moderate=.
replace cancel_pol_moderate=0 if cancel_pol!=.
replace cancel_pol_moderate=1 if cancel_pol==1
gen cancel_pol_strict=.
replace cancel_pol_strict=0 if cancel_pol!=.
replace cancel_pol_strict=1 if cancel_pol==2


ren rating_overall_maj rating_overall
replace rating_overall="." if rating_overall=="NA"
destring rating_overall, replace
replace rating_communication="." if rating_communication=="NA"
destring rating_communication, replace
replace rating_accuracy="." if rating_accuracy=="NA"
destring rating_accuracy, replace
replace rating_cleanliness="." if rating_cleanliness=="NA"
destring rating_cleanliness, replace
replace rating_checkin="." if rating_checkin=="NA"
destring rating_checkin, replace
replace rating_location="." if rating_location=="NA"
destring rating_location, replace

replace active="." if active=="NA"
replace active="1" if active=="True"
replace active="0" if active=="False"
destring active, replace
label values active truefalse

ren arabe arab
ren francais french
ren genre female
replace female="." if female=="NA" | female=="m,f" | female=="f,m"
replace female="0" if female=="m"
replace female="1" if female=="f"
destring female, replace

replace bathrooms="." if bathrooms=="NA"
destring bathrooms, replace

ren listing_type listing
replace listing="." if listing=="NA"
replace listing="0" if listing=="Entire home/apt"
replace listing="1" if listing=="Private room"
replace listing="2" if listing=="Shared room"
destring listing, replace
label define room 0 "Entire home/apt" 1 "Private room" 2 "Shared room"
label values listing room

gen listing_entire=0 if listing!=.
replace listing_entire=1 if listing==0
gen listing_private=0 if listing!=.
replace listing_private=1 if listing==1
gen listing_shared=0 if listing!=.
replace listing_shared=1 if listing==2

encode quartier, g(neighbourhood)
tab neighbourhood, gen(neighbourhood_)

encode zone_touristique, g(tourist_zone)
tab tourist_zone, g(zone_)

replace nightly_rate="." if nightly_rate=="NA"
destring nightly_rate, replace
replace weekly_rate="." if weekly_rate=="NA"
destring weekly_rate, replace
replace monthly_rate="." if monthly_rate=="NA"
destring monthly_rate, replace
replace security_deposit="." if security_deposit=="NA"
destring security_deposit, replace
replace cleaning_fee="." if cleaning_fee=="NA"
destring cleaning_fee, replace
replace adr_usd="." if adr_usd=="NA"
destring adr_usd, replace


sort month
tostring month, replace
destring month, replace
gen monthly=mofd(month)
format monthly %tm
format month %td



*Labelling
label variable guest "No. of Guests"
label variable reviews "No. of Reviews"
label variable photos "No. of Photos"
label variable instantbook "Instantbook"
label variable business_ready "Business Ready"
label variable superhost "Super Host"
label variable minstay "Minimum Stay"
label variable rating_overall "Rating: Overall"
label variable rating_communication "Rating: Communication"
label variable rating_accuracy "Rating: Accuracy"
label variable rating_cleanliness "Rating: Cleanliness"
label variable rating_checkin "Rating: Check In"
label variable rating_location "Rating: Location"
label variable occupancy_rate "Occupancy Rate"
label variable active "Instant Reservation"
label variable reservation_days "No. of Days Reserved"
label variable available_days "No. of Days Available"
label variable bedrooms "No. of Bedrooms"
label variable bathrooms "No. of Bathrooms"
label variable cancel_pol_flex "Cancellation: Flexible"
label variable cancel_pol_moderate "Cancellation: Moderate "
label variable cancel_pol_strict "Cancellation: Strict "
label variable listing_entire "Entire home/ appartement"
label variable listing_private "Private Room "
label variable listing_shared  "Shared Room "
label variable adr_usd "Avg. Daily Rate in USD"
label variable arab "Arab/Muslim"
label variable female "Female"


*generating revenue
gen revenue= reservation_days*adr_usd
label variable revenue "Monthly Revenue"
replace revenue=0 if occupancy_rate==0

*rescaling the rating variable
gen rating_overall2= rating_overall
replace rating_overall2=rating_overall2/10 if rating_overall2 >10
label variable rating_overall2 "Rating: Overall"

*generating log of average daily price
gen log_price= log(adr_usd)
label variable log_price "Log (Price)"

*generating samplemarker for in sample obs (listings that are declared as available on the website versus those without availability)
gen samplemarker_occup=0
replace samplemarker_occup=1 if available_days>0 & guests!=. & photos!=. & bedrooms!=. & bathrooms!=. & instantbook!=. & business_ready!=. & superhost!=. & minstay!=. & cancel_pol!=. & listing!=. & neighbourhood!=. & occupancy_rate!=. 
gen samplemarker_price=0
replace samplemarker_price=1 if available_days>0 & guests!=. & photos!=. & bedrooms!=. & bathrooms!=. & instantbook!=. & business_ready!=. & superhost!=. & minstay!=. & cancel_pol!=. & listing!=. & neighbourhood!=. & log_price!=. 
egen monthslisted = total(samplemarker_occup == 1), by(id)
egen monthslisted_price = total(samplemarker_price == 1), by(id)

*generating entry and exit variables
gen first_month=0
gen last_month=0

* set the first month in which a listing is observed to 1
bysort id (monthly): replace first_month=1 if _n==1

* a last month will be followed by a first month of another propoerty
sort id monthly
replace last_month=1 if first_month[_n+1]==1

*We create and entry dummy for first appearance of a listing in dataset. Listings present in the very first month of the data do not get coded as entries
gen entry=0
replace entry=1 if first_month==1
replace entry=. if monthly==658

*Same for exit variable and very last month of data
gen exit=0
replace exit=1 if last_month==1
replace exit=. if monthly==698

*Reentry captures when a listing has been there before but was not listed for a while and then returns
gen reentry=0
replace  reentry=1 if active==1 & active[_n-1]==0 & id==id[_n-1]

gen any_entry=0
replace any_entry=1 if reentry==1 | entry==1


*creating a second exit variable capturing last active month of appartments that disappear later (sometimes appartements remain on the platform but are inactive in last months)
sort id month
 gen exit2=0
 replace exit2=exit if active==1
replace exit2=1 if exit[_n+1]==1 & active[_n+1]==0 & active==1 & id[_n+1]==id
replace exit2=1 if exit[_n+2]==1 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+2]==id
replace exit2=1 if exit[_n+3]==1 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+3]==id
replace exit2=1 if exit[_n+4]==1 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+4]==id
replace exit2=1 if exit[_n+5]==1 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+5]==id
replace exit2=1 if exit[_n+6]==1 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+6]==id
replace exit2=1 if exit[_n+7]==1 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+7]==id
replace exit2=1 if exit[_n+8]==1 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+8]==id
replace exit2=1 if exit[_n+9]==1 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+9]==id
replace exit2=1 if exit[_n+10]==1 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+10]==id
replace exit2=1 if exit[_n+11]==1 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+11]==id
replace exit2=1 if exit[_n+12]==1 & active[_n+12]==0 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+12]==id
replace exit2=1 if exit[_n+13]==1 & active[_n+13]==0 & active[_n+12]==0 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+13]==id
replace exit2=1 if exit[_n+14]==1 & active[_n+14]==0 & active[_n+13]==0  & active[_n+12]==0 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+14]==id
replace exit2=1 if exit[_n+15]==1 & active[_n+15]==0 & active[_n+14]==0 & active[_n+13]==0  & active[_n+12]==0 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+15]==id
replace exit2=1 if exit[_n+16]==1 & active[_n+16]==0 & active[_n+15]==0 & active[_n+14]==0 & active[_n+13]==0  & active[_n+12]==0 & active[_n+11]==0 & active[_n+10]==0 & active[_n+9]==0 & active[_n+8]==0 & active[_n+7]==0 & active[_n+6]==0 & active[_n+5]==0 & active[_n+4]==0 & active[_n+3]==0 & active[_n+2]==0 &  active[_n+1]==0 & active==1 & id[_n+16]==id


*capturing listings that temporarily become inactive
gen temp_exit=0
replace temp_exit=1 if active==1 & active[_n+1]==0 & id==id[_n+1] & exit2==0

*both temporary and final market exits combined
gen any_exit=0
replace any_exit=1 if temp_exit==1 | exit==1

*create variable on how many days a listing was listed (available days are available but unreserved here)
gen listed_days=available_days+reservation_days
label variable listed_days "No. of Days Listed"


*generating interactions of host ethnicity (arab) with relevant variables
 local varlist female guests photos reviews bedrooms bathrooms instantbook business_ready superhost minstay cancel_pol_moderate cancel_pol_strict listing_private listing_shared  rating_overall2 rating_communication rating_accuracy rating_cleanliness rating_checkin rating_location 
foreach i of local varlist{
gen arab_`i'=arab*`i'
}
*label interactions of host ethnicity (arab) with relevant variables
label variable arab_female "A/M x Woman"
label variable arab_guests "A/M x No. of Guests"
label variable arab_photos "A/M x No. of Photos"
label variable arab_bedrooms "A/M x No. of Bedrooms"
label variable arab_bathrooms "A/M x No. of Bathrooms"
label variable arab_instantbook "A/M x Instantbook"
label variable arab_business_ready "A/M x Business Ready"
label variable arab_superhost "A/M x Super Host"
label variable arab_minstay "A/M x Minimum Stay"
label variable arab_cancel_pol_moderate "A/M x Cancellation Moderate "
label variable arab_cancel_pol_strict "A/M x Cancellation Strict"
label variable arab_listing_private "A/M x Private Room"
label variable arab_listing_shared "A/M x Shared Room"
label variable arab_rating_overall2 "A/M x Rating: Overall"
label variable arab_rating_communication "A/M x Rating: Communication"
label variable arab_rating_accuracy "A/M x Rating: Accuracy"
label variable arab_rating_cleanliness "A/M x Rating: Cleanliness"
label variable arab_rating_checkin "A/M x Rating: Check In"
label variable arab_rating_location "A/M x Rating: Location"
label variable arab_reviews "A/M x Reviews"

*Saving the dataset with all the data preparation done
save airbnb2.dta, replace



