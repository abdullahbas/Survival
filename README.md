#SURVIVAL ANALYSIS 
#

**This is the code for  survival analysis and it generates curves of survivals. -pretty ones**
#


![Scheme](https://github.com/trabz/Survival/blob/master/Inputs.png)
)

# Break Into

**INPUTS--This section have multiple values and they are neccessary to enter**
****
****
* Time of Survival --or follow up

* Variable

 `survival(monthA,variable)`
#
**** *****
****
 
**PARAMETERS--This section has 5 values and they are not neccessary to enter**


* split -- default -  *unique* --- `survival(monthA,variable,'split','unique')`
* prcval-default-*[25,75]*-- `survival(monthA,variable,'split','percentile','prcVal',[25 75])`
* znum-- default   -*1.96*- `survival(monthA,variable,'znum',1.96)`
* xlabel -- default  -*time*-- `survival(monthA,variable,'xlabel','Time')`
* ylabel -- default - *survival*-- `survival(monthA,variable,'ylabel','Survival')`

**General form -- `survival(monthA,variable,'VarName','Value','VarName2','Value2')`



![surv1](https://github.com/trabz/Survival/blob/master/surv2.png)
![surv2](https://github.com/trabz/Survival/blob/master/survs.png)










