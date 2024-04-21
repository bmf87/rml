


#
# Convert numeric age value from Shiny UI 
# to 13-level age code used in data set
#
age_level = function(x) {
  case_when(
    (x>=18 & x<=24) ~ 1, 
    (x>=25 & x<=30) ~ 2, 
    (x>=31 & x<=35) ~ 3, 
    (x>=36 & x<=40) ~ 4, 
    (x>=41 & x<=45) ~ 5,
    (x>=46 & x<=50) ~ 6, 
    (x>=51 & x<=55) ~ 7,
    (x>=56 & x<=60) ~ 8,
    (x>=61 & x<=65) ~ 9,
    (x>=66 & x<=70) ~ 10,
    (x>=71 & x<=75) ~ 11,
    (x>=76 & x<=80) ~ 12,
    (x>=80) ~ 13
  )
}

#
# Convert 13-level age codes to an age group
# e.g. 18 - 24
#
age_grouping = function(x) {
  case_when(
    (x==1) ~ '18-24', 
    (x==2) ~ '25-30', 
    (x==3) ~ '31-35', 
    (x==4) ~ '36-40', 
    (x==5) ~ '41-45',
    (x==6) ~ '46-50', 
    (x==7) ~ '51-55',
    (x==8) ~ '56-60',
    (x==9) ~ '61-65',
    (x==10) ~ '66-70',
    (x==11) ~ '71-75',
    (x==12) ~ '76-80',
    (x==13) ~ '80+'
  )
}
