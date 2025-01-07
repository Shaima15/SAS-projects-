/* DSCI 519- Airbnb analysis- Oakland, California */ 

/*Import listings file*/

options validvarname=v7;                          
proc import datafile='/home/u63735961/Sheyma/DSCI 519/listings.xlsx'
     dbms=xlsx                                    
     out=work.listings
     replace;
     Getnames = Yes;                                     
run;

/* Data Analysis 

linear regression 

2 

a. i*/ 
PROC UNIVARIATE DATA=work.Listings;
VAR Price;
Histogram;
RUN;

/* Yes, there are missing values. The results show that there are 139 observations
for which there are missing price values*/

/*ii. 

There is a large difference between the mean and the median caused by the presence
of outliers and these affect the mean. Also, the 99% cutoff value is $787 and the 100% 
value is $4000. This shows a large difference between them, meaning
that the top 1% of the observations are extreme outlier points. These extreme values 
will be removed.*/

DATA Price;
SET listings;
WHERE Price <= 787;
run;

/*iii 

The Price variable's distribution is not normal since the skewness is approximately 10 
and the histogram shows that the variable is right-skewed. This necessitates a
transformation to make it normally distributed. The chart shows that the outliers lie
towards the higher price values.*/

/* iv. create log-transformed price variable */

DATA Price;
SET Price;
Price_Log = LOG(Price);
RUN;

/*Now check if the log-transformed price variable is normally distributed*/

PROC UNIVARIATE DATA=work.Price;
VAR Price_Log;
Histogram;
RUN;

/* The histogram and the skewness show that the variable is normally distributed because
the chart shows a bell curve and the skewness is between -1 and 1. */ 

/*b 

Numeric Predictors 

*/ 

DATA Price;
SET Price;
drop id Host_ID
longitude latitude Number_of_reviews Review_scores_rating Review_scores_accuracy
Review_scores_cleanliness Review_scores_checkin Review_scores_communication
Review_scores_location Review_scores_value Reviews_per_month First_review
Last_review Host_since number_of_reviews_ltm number_of_reviews_l30d 
calculated_host_listings_count calculated_host_listings_count_e 
calculated_host_listings_count_p calculated_host_listings_count_s;
RUN;

/* i. 1

a. 
Create global numeric variables remove dependent variable.*/

PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;
/* Create correlation analysis */
PROC CORR DATA=Price;
VAR &varx.;
RUN;

/* b. 
build regression model and include VIF score to check multicollinearity */ 

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/* Now address multicollinearity iteratively by removing those with high VIF and building
a regression model with the remaining variables */

/*Remove host_total_listings_count check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log 
host_total_listings_count)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove maximum_nights_avg_ntm check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove minimum_nights_avg_ntm check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove availability_60 check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm availability_60)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove maximum_maximum_nights check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm availability_60 maximum_maximum_nights)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove minimum_nights check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm availability_60 maximum_maximum_nights
minimum_nights)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*Remove maximum_minimum_nights check VIF score and build regression model*/
PROC CONTENTS NOPRINT DATA=Price (KEEP=_NUMERIC_ drop = Price_Log maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm availability_60 maximum_maximum_nights
minimum_nights maximum_minimum_nights)
OUT=var1 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO:varx separated by " " FROM var1;
QUIT;
%PUT &varx;

PROC REG DATA=Price PLOTS=ALL;
model Price_Log= &varx /
selection=forward VIF COLLIN;
RUN;

/*now remove these variables. Also, since there are many unnecessary character variables, 
remove those so only the necessary ones can be shown in proc freq results below.
Moreover variables that are either empty or show redundant info will be removed*/

DATA Price_updated;
SET Price;
drop maximum_nights_avg_ntm
host_total_listings_count minimum_nights_avg_ntm availability_60 maximum_maximum_nights
minimum_nights maximum_minimum_nights
scrape_id listing_url name description neighborhood_overview picture_url host_url
host_name host_about host_thumbnail_url host_picture_url neighbourhood_group_cleansed
amenities license calendar_updated bathrooms_text neighbourhood host_neighbourhood
neighbourhood_cleansed host_response_rate host_response_time host_acceptance_rate
host_verifications; 
run; 

/*2 
Categorization */ 

PROC FREQ DATA=Price_updated (KEEP= _CHARACTER_) 
ORDER=FREQ; 
RUN;

/* Distribution and histogram of maximum_nights minimum_minimum_nights
 minimum_maximum_nights.  */
proc univariate data=Price_updated;
    var maximum_nights minimum_minimum_nights minimum_maximum_nights;
    histogram maximum_nights minimum_minimum_nights minimum_maximum_nights;
    inset n mean std min max / position=ne;
run;

/* I capped the minimum_minimum_nights at 99% to remove the high skewness value */
DATA Price_updated;
SET Price_updated;
WHERE minimum_minimum_nights <= 90;
run;

/* Distribution and histogram of beds bathrooms bedrooms */
proc univariate data=Price_updated;
    var beds bathrooms bedrooms;
    histogram beds bathrooms bedrooms;
    inset n mean std min max / position=ne;
run;

/* Each of the three variables are skewed so I capped them. 
Beds and bedrooms were caped at 95% and bathrooms were capped at 90% */ 
DATA Price_updated;
SET Price_updated;
WHERE beds <= 4 and bathrooms < 2.0 and bedrooms <= 3;
run;

/* Distribution and histogram of accommodates */
proc univariate data=Price_updated;
    var accommodates;
    histogram accommodates  ;
    inset n mean std min max / position=ne;
run;

/* For accommodates the data is slightly skewed, we see that there is a large difference 
between the 99% and 100% quartile so I will cap it at 99% to remove the effect of
extreme values*/
DATA Price_updated;
SET Price_updated;
WHERE accommodates <= 7;
run;

/*3*/
/* Use proc means to check summary stats of the variables and whether they have missing
values for price*/ 
PROC MEANS DATA=Price_updated (KEEP = _NUMERIC_) N NMISS MIN MAX MEAN MEDIAN STD;
RUN;

/* Only bedrooms will imputed because it has less than 5% missing values. */ 
proc stdize data=Price_updated out=Price_updated 
      reponly               /* only replaces the missing values*/
      method=MEAN;          
     var bedrooms;            
run;

/*4. To do feature engineering, first create matrix plot 
of the variables. Results show that each independent variable
either has linear or no relationship with the dependent
variable */ 
PROC SGSCATTER DATA=Price_updated;
 TITLE 'Scatter Plot Matrix';
 MATRIX Price_Log accommodates minimum_maximum_nights  minimum_minimum_nights 
maximum_nights beds bedrooms availability_30 availability_365 availability_90
bathrooms / 
START=TOPLEFT ELLIPSE = (ALPHA=0.05 TYPE=PREDICTED) NOLEGEND;
RUN;

/* This helps to see “beds per accommodates” and the “bathrooms per 
accommodates” rates which can be helpful when predicting price*/
Data Price_updated;
set Price_updated;
IF beds not in (., 0) then
beds_per_accom = accommodates / beds;
else
 beds_per_accom = 0;
IF bathrooms not in (., 0) then
bath_per_accom = accommodates / bathrooms;
else
 bath_per_accom = 0;
run;


/* Standardize the numeric variables using log transformation*/ 
data Price_updated;
set Price_updated;
log_accom = log(accommodates +1);
log_bath = log(bathrooms +1);
log_bedrooms = log(bedrooms +1);
log_beds = log(beds +1);
log_minmax = log(minimum_maximum_nights +1);
log_minmin = log(minimum_minimum_nights +1);
log_max = log(maximum_nights +1);
log_avail_30 = log(availability_30 +1);
log_avail_365 = log(availability_365 +1);
log_avail_90 = log(availability_90 +1);
log_bed_per = log(beds_per_accom +1);
log_bath_per = log(bath_per_accom +1);
run;


/* ii. Character (categorical variable) 

i. */ 

PROC FREQ DATA=Price_updated (KEEP= _CHARACTER_) 
ORDER=FREQ; 
RUN;

/* ii. 
There are various location based variables in the listings table. I will use host 
location when building regression model since it is easier to categorize compared 
to the neighborhood ones */

data Price_updated_cat; 
set Price_updated; 
length host_reside $10;

if host_location = 'Oakland, CA' then host_reside = 'Oakland';
else host_reside = 'Other';
run;

/* The below code helps in seeing the price for each property along with some statistical
measures*/ 
PROC MEANS DATA=Price_updated_cat;
CLASS Property_Type;
VAR Price;
RUN;

/*The property_type column has 40 levels, hence collapse the levels into lower levels. 
Also, the host_identity_verified column has only one level which is t and has some
missing values.For this we can impute f for the missing values so we can use this
predictor correctly. */
DATA Price_updated_cat;
SET Price_updated_cat;
length Property_CAT $6;
IF Property_Type in ('Boat', 'Camper/RV', 'Room in boutique hotel',
'Private room in yurt', 'Private room in townhouse', 'Private room in serviced apartment',
'Private room in rental unit','Private room in home', 'Private room in guest suite ',
'Private room in cottage', 'Private room in condo','Private room in casa particular',
'Private room in camper/rv','Private room in bunglaw', 'Private room','Shared
room in guesthouse','Shared room in home','Shared room in rental unit','Tiny home')
THEN Property_CAT = 'low';
ELSE
IF Property_Type in ('Room in hotel', 'Private room in loft') THEN Property_CAT = 
'high';
ELSE Property_CAT = 'medium';
IF has_availability = ' ' then has_availability = 'f';
run;

/* host_listings_count is a numeric variable but I will convert it into character.
Show distribution and histogram of host_listings_count.  */
proc univariate data=Price_updated_cat;
    var host_listings_count;
    histogram host_listings_count;
    inset n mean std min max / position=ne;
run;

/*created a new categorical variable that categorized host_listings_count.The variable
has high skewness. Most hosts are small and there are some with large listings counts
which explains the high skewness.  */ 

data Price_updated_cat; 
set Price_updated_cat; 

length host_count_cat $20;
if host_listings_count = 1 then host_count_cat = 'Single Property';
else if 2 <= host_listings_count <= 6 then host_count_cat = 'Small Host';
else if 7 <= host_listings_count <= 10 then host_count_cat = 'Medium Host'; 
else if host_listings_count > 10 then host_count_cat = 'Large host';
drop host_listings_count;
run;

/*Dummy variable creation */ 
Data Price_updated_cat;
set Price_updated_cat;
IF source = 'city scrape' then source_bin= 1; 
else source_bin = 0; 
If host_reside ='Oakland' then host_reside_bin = 1;
else host_reside_bin = 0;
if host_is_superhost = 'f' then host_super_bin= 1; 
else host_super_bin = 0;
if host_has_profile_pic = 't' then host_ppic_bin= 1;
else host_ppic_bin = 0;
if host_identity_verified = 't' then host_verif_bin = 1;
else host_verif_bin = 0;
IF room_type = 'Entire home/apt' then room_entire = 1; 
else room_entire = 0; 
IF room_type = 'Private room' then room_private = 1; 
else room_private = 0; 
IF room_type = 'Shared room' then room_shared = 1; 
else room_shared = 0; 
IF instant_bookable = 'f' then instant_book_bin = 1; 
else instant_book_bin = 0; 
IF Property_CAT = 'medium' then Property_med = 1; 
else Property_med = 0;
IF Property_CAT = 'high' then Property_high = 1; 
else Property_high = 0;
IF Property_CAT = 'low' then Property_low = 1; 
else Property_low = 0;
IF host_count_cat = 'Single Property' then host_count_sin = 1; 
else host_count_sin = 0; 
IF host_count_cat = 'Small Host' then host_count_small = 1; 
else host_count_small = 0;
IF host_count_cat = 'Large host' then host_count_large = 1; 
else host_count_large = 0;
IF host_count_cat = 'Medium Host' then host_count_med = 1; 
else host_count_med = 0;
IF has_availability = 'f' then has_avail_bin = 1; 
else has_avail_bin = 0;
run;

/* c. *Split data into TRAIN and TEST datasets at an 80/20 split*/
PROC SURVEYSELECT DATA=work.Price_updated_cat SAMPRATE=0.20 SEED=42
OUT=Full OUTALL METHOD=SRS;
RUN;

/*Create the TRAIN and TEST Data Sets*/
DATA TRAIN TEST;
 SET Full;
IF Selected=0 THEN OUTPUT TRAIN; ELSE OUTPUT TEST;
DROP Selected;
RUN;

/* d. i. Build a linear regression model */

/*First create Macro Variable to store the variables that will be used in 
the linear regression with lasso selection*/ 

%let lasso_var = Property_high Property_low Property_med room_shared room_private
room_entire log_minmin log_minmax log_max log_beds log_bedrooms log_bath log_avail_365
log_avail_90 log_avail_30 log_accom host_count_small host_count_sin host_count_med
host_count_large log_bath_per log_bed_per has_avail_bin instant_book_bin
host_verif_bin host_ppic_bin host_super_bin host_reside_bin
source_bin;

/* The below proc glmselect will score the TEST data set and output the
predictions and residuals */

proc glmselect data=TRAIN plots(unpack)=all;
	class has_availability;
	model Price_Log = &lasso_var.
		/ selection=lasso(choose=cp steps=10) stats=all;
	score data=TEST out=test_pred predicted residual;
run;

/* Use the data step to create a table called eval that includes the value for residual 
and square residual */

data eval;
  set test_pred;
  residual = (p_Price_Log-Price_Log)**2;
  sqrt_residual = sqrt(residual);
  keep Price_Log residual sqrt_residual;
run;

/* The below code will find the mean of the square residuals which will result in RMSE */

proc means data=eval n mean;
  var residual sqrt_residual;
run;

/*e. */ 
/*Since I will be using tree based models
I will make another train test split using the table that also has the uncollapsed 
variables*/

PROC SURVEYSELECT DATA=work.Price_updated SAMPRATE=0.20 SEED=42
OUT=Full2 OUTALL METHOD=SRS;
RUN;

/*Create the TRAIN and TEST Data Sets*/
DATA TRAIN2 TEST2;
 SET Full2;
IF Selected=0 THEN OUTPUT TRAIN2; ELSE OUTPUT TEST2;
DROP Selected;
RUN;

/*Create macro variable for numeric variables. */ 
PROC CONTENTS NOPRINT DATA=TRAIN2 (KEEP=_NUMERIC_ DROP= price price_log)
OUT=VAR3 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO: tree_num separated by " " FROM VAR3;
QUIT;
%PUT &tree_num;
/*Create macro variable for character variables*/
PROC CONTENTS NOPRINT DATA=TRAIN2 (KEEP=_CHARACTER_)
OUT=VAR4 (KEEP=name);
RUN;
PROC SQL NOPRINT;
SELECT name INTO: tree_char separated by " " FROM VAR4;
QUIT;
%PUT &tree_char;

ODS GRAPHICS ON;
%let path=/home/u63735961/Sheyma/DSCI 519/Assignments;
proc hpsplit data=TRAIN2 seed=66;
	class &tree_char.;
	model Price_Log = &tree_char. &tree_num.;
	partition fraction(validate=0.3 seed=66);
	output out=hpsplout;
	code file="&path./hpsplexc.sas";
run;

/*i. 

Apply Decision Tree Model to Hold-out TEST Data Set */

data score;
	set TEST2;
	%include "&path./hpsplexc.sas";
run;

/*ii. Check RMSE values */

data eval;
  set score;
  residual = (P_Price_Log-Price_Log)**2;
  sqrt_residual = sqrt(residual);
  keep Price_Log residual sqrt_residual;
run;

proc means data=eval n mean;
  var residual sqrt_residual;
run;

/* f. random forest

The code below develops a random forest that consists of 500 randomly
sampled trees, each with seven randomly sampled predictor variables.*/

ods graphics on;
proc hpforest data=TRAIN2
	maxtrees=500 vars_to_try=7
	seed=66 trainfraction=0.6
	maxdepth=20 leafsize=6
	alpha=0.1;
	target Price_Log / level=interval;
	input &tree_num. / level=interval;
	input &tree_char. / level=nominal;
	ods output fitstatistics=fit;
	save file="&path./rfmodel_fit.bin";
run;

proc hp4score data=score;
	id Price_Log;
	score file="&path./rfmodel_fit.bin"
	out=score;
run;

data eval;
  set score;
  residual = (p_Price_Log-Price_Log)**2;
  sqrt_residual = sqrt(residual);
  keep Price_Log residual sqrt_residual;
run;


proc means data=eval n mean;
  var residual sqrt_residual;
run;









