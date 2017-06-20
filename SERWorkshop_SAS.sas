*** CODE SET 1;
data a;
	call streaminit(123);
	do i = 1 to 1e6;
		confounder=rand("bernoulli",.5);
		smoking=rand("bernoulli",(1/(1+exp(-(-2+log(2)*confounder)))));
		CVD=rand("bernoulli",.1+.05*smoking+.05*confounder);
	output;
	end;
run;

proc means data=a mean;
var confounder smoking CVD;
run;

*OLS;
proc reg data=a;
model CVD = smoking confounder;
run;quit;run;

*ML1;
proc genmod data=a;
model CVD = smoking confounder / dist=poisson link=identity;
run;quit;run;

*ML2;
proc genmod data=a desc;
model CVD = smoking confounder / dist=binomial link=identity;
run;quit;run;
*** END CODE SET 1;



*** CODE SET 2;
* arrange into long data;
data a;
	input c a y n;
	datalines;
	0 0 94.3 344052
	0 1 119.2 154568
	1 0 130.6 154560
	1 1 155.7 346820
	;
run;
data a;
	set a;
	do i = 1 to n;
	output;
	end;
	drop i n;
run;
* take the mean of Y;
proc means data=a mean;
var y;
run;
*** END CODE SET 2;

*** CODE SET 3;
* fit models;
proc genmod data=a desc;
model c = / dist=bin link=logit;
output out=a pred=pC;
proc genmod data=a desc;
model a = c / dist=bin link=logit;
ods output ParameterEstimates=a_mod(keep=parameter estimate);
data _null_;
	set a_mod;
	if parameter="Intercept" then call symput("aInt",estimate);
	if parameter="c" then call symput("aC",estimate);
run;
proc genmod data=a desc;
model y = a c / dist=gaussian link=identity;
ods output ParameterEstimates=y_mod(keep=parameter estimate);run;
data _null_;
	set y_mod;
	if parameter="Intercept" then call symput("yInt",estimate);
	if parameter="a" then call symput("yA",estimate);
	if parameter="c" then call symput("yC",estimate);
run;quit;run;

* obtain predictions;
* C predictions already in dataset "a";
* use predicted C to obtain predicted A;
data a;
	set a;
	pA = (1/(1+exp(-(&aInt + &aC*pC))));
	pY = &yInt + &yA*pA + &yC*pC;
run;
proc print data=a (obs=20);run;

* compute marginal mean of predicted Y;
proc means data=a mean;
var pY;
run;
*** END CODE SET 3;

*** CODE SET 4;
data a;
	set a;
	*for A=1;
	pY_1=&yInt + &yA*1 + &yC*pC;
	*for A=0;
	pY_0=&yInt + &yA*0 + &yC*pC;
	diff = pY_1 - pY_0;
run;
proc means data=a mean;
var pY_1 pY_0 diff;
run;
*** END CODE SET 4;

*** CODE SET 5;
data a;
	input a0 z1 a1 y n;
	datalines;
	0 0 0  87.288 209271
	0 0 1 112.107 93779
	0 1 0 119.654 60657
	0 1 1 144.842 136293
	1 0 0 105.282 134781
	1 0 1 130.184 60789
	1 1 0 137.720 93903
	1 1 1 162.832 210527
	;
run;
data a;
	set a;
	do i = 1 to n;
	output;
	end;
	drop i n;
run;
proc means data=a mean;
var y;
run;
*** END CODE SET 5;


*** CODE SET 6;
proc genmod data=a desc; model a0 = / dist=bin link=logit;
output out=a pred=pA0;
proc genmod data=a desc; model z1 = a0 / dist=bin link=logit;
ods output ParameterEstimates=z1_mod(keep=parameter estimate);
data _null_;
	set z1_mod;
	if parameter="Intercept" then call symput("z1Int",estimate);
	if parameter="a0" then call symput("z1A0",estimate);
run; 
proc genmod data=a desc; model a1 = z1 / dist=bin link=logit; 
ods output ParameterEstimates=a1_mod(keep=parameter estimate);
data _null_;
	set a1_mod;
	if parameter="Intercept" then call symput("a1Int",estimate);
	if parameter="z1" then call symput("a1Z1",estimate);
run; 
proc genmod data=a; model y = a1 z1 a0 / dist=gaussian link=identity;
ods output ParameterEstimates=y_mod(keep=parameter estimate);
data _null_;
	set y_mod;
	if parameter="Intercept" then call symput("yInt",estimate);
	if parameter="a1" then call symput("yA1",estimate);
	if parameter="z1" then call symput("yZ1",estimate);
	if parameter="a0" then call symput("yA0",estimate);
run;quit;run;

data a;
	set a;
	pZ1 = 1/(1+exp(-(&z1Int+&z1A0*pA0)));
	pA1 = 1/(1+exp(-(&a1Int+&a1Z1*pZ1)));
	pY = &yInt + &yA1*pA1 + &yZ1*pZ1 + &yA0*pA0;
run;

proc means data=a mean;
title "Natural Course";
var pY;
run;
title;
*** END CODE SET 6;

*** CODE SET 7;

data a;
	set a;
	* for A=1;
	pZ1 = 1/(1+exp(-(&z1Int+&z1A0*1)));
	pY_1 = &yInt + &yA1*1 + &yZ1*pZ1 + &yA0*1;
	* for A=0;
	pZ1 = 1/(1+exp(-(&z1Int+&z1A0*0)));
	pY_0 = &yInt + &yA1*0 + &yZ1*pZ1 + &yA0*0;
	diff = pY_1 - pY_0;
run;

proc means data=a mean;
var pY_1 pY_0 diff;
run;

*** END CODE SET 7;
