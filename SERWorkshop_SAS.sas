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
