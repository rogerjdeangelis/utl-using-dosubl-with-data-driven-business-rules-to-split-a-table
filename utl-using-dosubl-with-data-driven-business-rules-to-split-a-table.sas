Using dosubl with data driven business rules to split a table

github
https://tinyurl.com/y6f28j2l
https://github.com/rogerjdeangelis/utl-using-dosubl-with-data-driven-business-rules-to-split-a-table

SAS forum
https://tinyurl.com/y3opbf9z
https://communities.sas.com/t5/SAS-Programming/Use-a-string-as-a-rule-for-where/m-p/557963

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

filename ft15f001 "d:/txt/rules.txt";
parcards4;
sex=M
sex=F
;;;;
run;quit;

file d:/txt/rules.txt

sex=M
sex=F

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;


Up to 40 obs WORK.LOG total obs=2

Obs    RULE     RC                           STATUS

 1     sex=M     0    Table class table M where sex=M Created Successfully
 2     sex=F     0    Table class table F where sex=F Created Successfully


WORK.M total obs=10

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

  1    Alfred      M      14     69.0      112.5
  2    Henry       M      14     63.5      102.5
  3    James       M      12     57.3       83.0
....

WORK.F total obs=9

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

 1     Alice       F      13     56.5       84.0
 2     Barbara     F      13     65.3       98.0
 3     Carol       F      14     62.8      102.5

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

%symdel cc sex rule gender / nowarn; * just in case global;

data log;

  informat rule $18.;

  infile ft15f001;

  input rule;
  call symput("rule",rule);

  put rule=;

  rc=dosubl('
      %let &rule;
      data &sex;
         set sashelp.class(where=(sex="&sex"));
      run;quit;
      %let cc=&syserr;
      %let gender=&sex;
   ');


  if symgetn("cc") = 0 then
       status=catx(" ","Table class table", symget("gender"), "where", rule, "Created Successfully");
  else
       status=catx(" ","Table class table", symget("gender"), "where", rule, "Failed");

run;quit;


