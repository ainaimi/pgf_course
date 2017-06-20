
%inc "C:\ain\header2.txt";
libname a "W:\Documents\Research\Presentations\SER 2017\SER Workshop\pgf_course-master";

* STEP 0: EXPLORE NSFG DATA;
proc print data=a.n2 (obs=20);run;

/*data a.n2;*/
/*	set a.n2;*/
/*	if _imputation_ = 1;*/
/*	ptb = (prglngth<37);*/
/*	pay_d = 1-pay_d;*/
/*	keep _id ptb hisprace pay_d mage_c1 mage_c2 mage_c3 educ_d marit_d pnc_d20 wksg_d want_d;*/
/*run;*/

proc freq data=a.n2;
table hisprace;
table ptb;
table pay_d;
run;

* racial disparity in preterm birth;
proc genmod data=a.n2 desc;
model ptb = hisprace / link=identity dist=bin;
proc genmod data=a.n2 desc;
model ptb = hisprace / link=log dist=bin;
run;quit;run;

* association between delivery payment and preterm birth;
proc genmod data=a.n2 desc;
model ptb = pay_d / link=identity dist=bin;
proc genmod data=a.n2 desc;
model ptb = pay_d / link=log dist=bin;
run;quit;run;

data a;set a.n2;
xm=hisprace*pay_d;
keep ptb pay_d hisprace mage_c1 mage_c2 
mage_c3 educ_d marit_d pnc_d20 wksg_d want_d xm;
run;

*STEP 1: ORDER VARIABLES AND MODEL EACH COMPONENT OF THE LIKELIHOOD;
* order variables;
* ptb pay_d pnc_d20 want_d wksg_d marit_d educ_d hisprace mage_c1 mage_c2 mage_c3 ;
proc genmod data=a desc;
model ptb = pay_d pnc_d20 want_d wksg_d 
marit_d educ_d hisprace xm mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=ptb_mod(keep=parameter estimate);run;
data _null_;
	set ptb_mod;
	if parameter="Intercept" then call symput("ptbInt",estimate);
	if parameter="pay_d" then call symput("ptbPay",estimate);
	if parameter="pnc_d20" then call symput("ptbPNC",estimate);
	if parameter="want_d" then call symput("ptbWant",estimate);
	if parameter="wksg_d" then call symput("ptbWksg",estimate);
	if parameter="marit_d" then call symput("ptbMarit",estimate);
	if parameter="educ_d" then call symput("ptbEduc",estimate);
	if parameter="HISPRACE" then call symput("ptbHisprace",estimate);
	if parameter="mage_c1" then call symput("ptbMage1",estimate);
	if parameter="mage_c2" then call symput("ptbMage2",estimate);
	if parameter="mage_c3" then call symput("ptbMage3",estimate);
	if parameter="xm" then call symput("ptbXM",estimate);
run;
proc genmod data=a desc;
model pay_d = pnc_d20 want_d wksg_d 
marit_d educ_d hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=pay_mod(keep=parameter estimate);run;
data _null_;
	set pay_mod;
	if parameter="Intercept" then call symput("payInt",estimate);
	if parameter="pnc_d20" then call symput("payPNC",estimate);
	if parameter="want_d" then call symput("payWant",estimate);
	if parameter="wksg_d" then call symput("payWksg",estimate);
	if parameter="marit_d" then call symput("payMarit",estimate);
	if parameter="educ_d" then call symput("payEduc",estimate);
	if parameter="HISPRACE" then call symput("payHisprace",estimate);
	if parameter="mage_c1" then call symput("payMage1",estimate);
	if parameter="mage_c2" then call symput("payMage2",estimate);
	if parameter="mage_c3" then call symput("payMage3",estimate);
run;
proc genmod data=a desc;
model pnc_d20 = want_d wksg_d 
marit_d educ_d hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=pnc_mod(keep=parameter estimate);run;
data _null_;
	set pnc_mod;
	if parameter="Intercept" then call symput("pncInt",estimate);
	if parameter="want_d" then call symput("pncWant",estimate);
	if parameter="wksg_d" then call symput("pncWksg",estimate);
	if parameter="marit_d" then call symput("pncMarit",estimate);
	if parameter="educ_d" then call symput("pncEduc",estimate);
	if parameter="HISPRACE" then call symput("pncHisprace",estimate);
	if parameter="mage_c1" then call symput("pncMage1",estimate);
	if parameter="mage_c2" then call symput("pncMage2",estimate);
	if parameter="mage_c3" then call symput("pncMage3",estimate);
run;
proc genmod data=a desc;
model want_d = wksg_d 
marit_d educ_d hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=want_mod(keep=parameter estimate);run;
data _null_;
	set want_mod;
	if parameter="Intercept" then call symput("wantInt",estimate);
	if parameter="wksg_d" then call symput("wantWksg",estimate);
	if parameter="marit_d" then call symput("wantMarit",estimate);
	if parameter="educ_d" then call symput("wantEduc",estimate);
	if parameter="HISPRACE" then call symput("wantHisprace",estimate);
	if parameter="mage_c1" then call symput("wantMage1",estimate);
	if parameter="mage_c2" then call symput("wantMage2",estimate);
	if parameter="mage_c3" then call symput("wantMage3",estimate);
run;
proc genmod data=a desc;
model wksg_d = marit_d educ_d 
hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=wksg_mod(keep=parameter estimate);run;
data _null_;
	set wksg_mod;
	if parameter="Intercept" then call symput("wksgInt",estimate);
	if parameter="marit_d" then call symput("wksgMarit",estimate);
	if parameter="educ_d" then call symput("wksgEduc",estimate);
	if parameter="HISPRACE" then call symput("wksgHisprace",estimate);
	if parameter="mage_c1" then call symput("wksgMage1",estimate);
	if parameter="mage_c2" then call symput("wksgMage2",estimate);
	if parameter="mage_c3" then call symput("wksgMage3",estimate);
run;
proc genmod data=a desc;
model marit_d = educ_d 
hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=marit_mod(keep=parameter estimate);run;
data _null_;
	set marit_mod;
	if parameter="Intercept" then call symput("maritInt",estimate);
	if parameter="educ_d" then call symput("maritEduc",estimate);
	if parameter="HISPRACE" then call symput("maritHisprace",estimate);
	if parameter="mage_c1" then call symput("maritMage1",estimate);
	if parameter="mage_c2" then call symput("maritMage2",estimate);
	if parameter="mage_c3" then call symput("maritMage3",estimate);
run;
proc genmod data=a desc;
model educ_d = hisprace mage_c1 mage_c2 mage_c3 / link=logit dist=bin;
ods output ParameterEstimates=educ_mod(keep=parameter estimate);run;
data _null_;
	set educ_mod;
	if parameter="Intercept" then call symput("educInt",estimate);
	if parameter="HISPRACE" then call symput("educHisprace",estimate);
	if parameter="mage_c1" then call symput("educMage1",estimate);
	if parameter="mage_c2" then call symput("educMage2",estimate);
	if parameter="mage_c3" then call symput("educMage3",estimate);
run;

*STEP 2: SELECT RANDOM SAMPLE OF OBSERVED DATA AND KEEP ONLY BASELINE COVARIATES;
proc surveyselect data=a out=mc0(keep= hisprace mage_c1 mage_c2 mage_c3) method=urs seed=123 sampsize=50000 outhits;run;
%macro gform(run=, exposure=, mediator=); 
data mc&run;
	set mc0;

	id=_N_;

	call streaminit(123);

	educP = rand("bernoulli",1/(1+exp(-(&educInt + &educHisprace*&exposure + &educMage1*mage_c1 + &educMage2*mage_c2 + &educMage3*mage_c3))));

	maritP = rand("bernoulli",1/(1+exp(-(&maritInt + &maritEduc*educP + &maritHisprace*&exposure + 
					&maritMage1*mage_c1 + &maritMage2*mage_c2 + &maritMage3*mage_c3))));

	wksgP = rand("bernoulli",1/(1+exp(-(&wksgInt + &wksgEduc*educP + &wksgMarit*maritP + &wksgHisprace*&exposure + 
					&wksgMage1*mage_c1 + &wksgMage2*mage_c2 + &wksgMage3*mage_c3))));

	wantP = rand("bernoulli",1/(1+exp(-(&wantInt + &wantWksg*wksgP + &wantEduc*educP + &wantMarit*maritP + &wantHisprace*&exposure + 
					&wantMage1*mage_c1 + &wantMage2*mage_c2 + &wantMage3*mage_c3))));

	pncP = rand("bernoulli",1/(1+exp(-(&pncInt + &pncWant*wantP + &pncWksg*wksgP + &pncEduc*educP + &pncMarit*maritP + &pncHisprace*&exposure + 
					&pncMage1*mage_c1 + &pncMage2*mage_c2 + &pncMage3*mage_c3))));

	payP = rand("bernoulli",1/(1+exp(-(&payInt + &payPNC*pncP + &payWant*wantP + &payWksg*wksgP + &payEduc*educP + &payMarit*maritP + &payHisprace*&exposure + 
					&payMage1*mage_c1 + &payMage2*mage_c2 + &payMage3*mage_c3))));

	** notice the need to generate alternative payP;
	payP0 = rand("bernoulli",1/(1+exp(-(&payInt + &payPNC*pncP + &payWant*wantP + &payWksg*wksgP + &payEduc*educP + &payMarit*maritP + &payHisprace*0 + 
					&payMage1*mage_c1 + &payMage2*mage_c2 + &payMage3*mage_c3))));

	payP1 = rand("bernoulli",1/(1+exp(-(&payInt + &payPNC*pncP + &payWant*wantP + &payWksg*wksgP + &payEduc*educP + &payMarit*maritP + &payHisprace*1 + 
					&payMage1*mage_c1 + &payMage2*mage_c2 + &payMage3*mage_c3))));

	xmP = &exposure*&mediator;
	ptbP = rand("bernoulli",1/(1+exp(-(&ptbInt + &ptbPay*&mediator + &ptbXM*xmP + &ptbPNC*pncP + &ptbWant*wantP + &ptbWksg*wksgP + &ptbEduc*educP + &ptbMarit*maritP + &ptbHisprace*&exposure + 
					&ptbMage1*mage_c1 + &ptbMage2*mage_c2 + &ptbMage3*mage_c3))));
	
	keep id ptbP;
run;
%mend;
%gform(run=1,exposure=hisprace,mediator=payP);*natural course;
%gform(run=2,exposure=1,mediator=payP);*exposed, natural mediator;
%gform(run=3,exposure=0,mediator=payP);*unexposed, natural mediator;
%gform(run=4,exposure=1,mediator=payP1);*exposed, unexposed mediator;
%gform(run=5,exposure=0,mediator=payP1);*unexposed, unexposed mediator;
%gform(run=6,exposure=1,mediator=payP0);*exposed, unexposed mediator;
%gform(run=7,exposure=0,mediator=payP0);*unexposed, unexposed mediator;
%gform(run=8,exposure=1,mediator=0);*exposed, unexposed mediator;
%gform(run=9,exposure=0,mediator=0);*unexposed, unexposed mediator;

proc means data=a mean;var ptb;
proc means data=mc1 mean;var ptbP;
run;quit;run;

data mc1;set mc1;rename ptbP=Yn;
data mc2;set mc2;rename ptbP=Y1;
data mc3;set mc3;rename ptbP=Y0;
data mc4;set mc4;rename ptbP=Y1mn1;
data mc5;set mc5;rename ptbP=Y0mn1;
data mc6;set mc6;rename ptbP=Y1mn0;
data mc7;set mc7;rename ptbP=Y0mn0;
data mc8;set mc8;rename ptbP=Y1m0;
data mc9;set mc9;rename ptbP=Y0m0;

data results;
	merge mc1-mc9;
	by id;
	disparity = y1-y0;
	tde = y1mn1-y0mn1;
	tie = y1mn1-y1mn0;
	pde = y1mn0-y0mn0;
	pie = y0mn1-y0mn0;
	cde = y1m0-y0m0;
run;quit;run;

ods select all;
proc genmod data=a desc;
model ptb = hisprace / link=identity dist=bin;run;
proc means data=results mean;var disparity pde pie tde tie cde;run;


