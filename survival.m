function [tab]=survival(monthA,variable,varargin)
%
% Survival curve and Confidence ýnterval estimator
% 9.01.2020
% 
%
% monthA -Entry for all subjects' followed up time. Arrangment is not
% important algorithm will sort all months. Soo enjoy.
% for censored data, you should add negative sign e.g monthA=[1,3,5,-7,-9]
% algorithm decodes "-" sign as censored so you must follow this protocol
%
% variable--Variables
% 
% varargin -- varargin can take 5 different vals.
% 1- 'split' -default 'unique'-- 
% 
% 1.1 'unique' ---It decodes monthA with respect to variables
% You can enter infinite groups ( Mathematically yes you can but logically you cant)
% Have to arrange variables and monthA correctly for group seperation.
% survival (monthA,variable,'split','unique')
% survival (monthA,variable)
%
% 1.2- 'percentile'-default [25,75]-- It takes 25th and 75th percentile of variables
% and seperate monthA respect to that seperation. Of course it generates 3
% different survival curves at default. But if you change percentile values
% by entering simply 'prcVal' and [m1 m2 m3 m4 m5 m6] -all m's must be integers-
% then it will generate more survival curves.   
% survival(monthA,variable,'split' 'percentile','prcVal',[m1 m2 m3 ..])
% 
% 1.3- 'median'-- It takes median of variable array and generates two survival curves. 
% survival (monthA,variable,'split','median')
%
% 2- prcVal-- default [25,75] as has been mentioned above it is the value
% array for percentile range. You can manipulate it freely. 
% survival(monthA,variable,'split','percentile','prcVal',[25 75 80])
% 
% 3-znum-- default 1.96 %95-- It is the value for cut-off.
% survival(monthA,variable,'znum',1.96) for %95
% And thank god it is just a float not same as the others :)
% 
% 4- xlabel-default 'Time'
% 
% 5- ylabel - default 'Survival'
% 
% Abdullah BAÞ, Ph.D.
% BME
% Bogazici University, Istanbul


property={'split','prcVal','znum','xlabel','ylabel'};
value={'unique',[25,75],1.96,'Time','Survival'};

le=length(varargin);
le=1:2:le;
%index = ismember(contains(property,varargin{le},'IgnoreCase',true))

[tf,inds]= (ismember(property,{varargin{le}}));
inds=find(inds>0);
k=1;
for i=inds
value{i}=varargin{le(k)+1};
k=k+1;
end
%value={value{inds}}


if value{1}=="median"
    variableInd=variable>median(variable);
    monthA1{1}=(monthA(variableInd));
    monthA1{2}=(monthA(~variableInd));
    [a,b]=hist((monthA(variableInd)),unique((monthA(variableInd))));
    [ix,ind]=sort(abs(b));
    b=b(ind);
    a=a(ind);
    deathsA{1}=a;
    monthA1{1}=b;
    [a,b]=hist((monthA(~variableInd)),unique((monthA(~variableInd))));
    [ix,ind]=sort(abs(b));
    b=b(ind);
    a=a(ind);
    deathsA{2}=a;
    monthA1{2}=b;
    peopleA{1}=sum(variableInd);
    peopleA{2}=sum(~variableInd);

elseif value{1}=="percentile"
    val=[0 value{2} 100];
    for i=1:length(val)-1    
        variableInd=[variable>prctile(variable,val(i)) & variable<prctile(variable,val(i+1))];
        monthA1{i}=(monthA(variableInd));
        [a,b]=hist((monthA(variableInd)),unique((monthA(variableInd))));
        [ix,ind]=sort(abs(b));
        b=b(ind);
        a=a(ind);
        deathsA{i}=a;
        monthA1{i}=b;    
        peopleA{i}=sum(variableInd);
    end
    
elseif value{1}=="unique"
    
    val=unique(variable);
    for i=1:length(val)    
        variableInd=variable==val(i);
        monthA1{i}=(monthA(variableInd));
        [a,b]=hist((monthA(variableInd)),unique((monthA(variableInd))));
        [ix,ind]=sort(abs(b));
        b=b(ind);
        a=a(ind);
        deathsA{i}=a;
        monthA1{i}=b;    
        peopleA{i}=sum(variableInd);
    end
    
end




monthA=monthA1;

united=([monthA{:}]);
united=unique(united);
[ix,ind]=sort(abs(united));
united=united(ind);
%figs=[figures{:}]



for i=1:length(monthA)
    deaths=zeros(1,length(united));
    [cc,deind]=ismember(abs(monthA{i}),abs(united));    
    month=united;
    deaths(deind)=deathsA{i};
    %deaths=deaths(1:end-1)
    people=(peopleA{i})*ones(1,length(deaths)+1);
    cumSurv=ones(1,length(deaths)+1);
    indicesUn=month.*deaths>0;
    indicesCen=month.*deaths<0;
%{
deaths=[3 2 1 1 1 1 1 2 1 2 1 1 1 2 1 2 1 1 1 1 3 1 2];

month=[1 2 3 4 5 6 7 8 10 12 14 17 20999 27 28 30 36 ...
    38999 40999 45999 50 63999 132999];
indices=month<999;
people=33*ones(1,length(deaths)+1);
cumSurv=ones(1,length(deaths)+1);
%}
for ik=1:length(month)  
   if (month(ik)>0) 
       
       people(ik+1)=people(ik)-deaths(ik);
       survival=(people(ik)-deaths(ik))/people(ik);
       cumSurv(ik+1)=survival*cumSurv(ik);  
       ind=nonzeros([(1:ik).*indicesUn(1:ik)]);
       d=deaths(ind);
       n=people(ind);       
       ste(ik)=cumSurv(ik+1).*(sqrt(sum(d./(n.*(n-d))))) ;  
   else
       
       people(ik+1)=people(ik)-deaths(ik);
       cumSurv(ik+1)=cumSurv(ik);
       ste(ik)=ste(ik-1);
       
   end

end
cums=cumSurv(2:end);
ind2=find(indicesUn==1);
ind1=find(indicesCen==1);
CIup=0;
CIlow=0;
ste(isnan(ste))=ste(diff(isnan(ste))>0);
CIup=cums()+1*value{3}*ste();
CIlow=cums()+(-1*value{3})*ste();
CIup=(CIup>0).* CIup;
CIlow=(CIlow>0).*CIlow;

sh = stairs(CIup); 
x = [sh.XData(1),repelem(sh.XData(2:end),2)];
y = [repelem(sh.YData(1:end-1),2),sh.YData(end)];
sh2=stairs(CIlow);
x2=[sh2.XData(1),repelem(sh2.XData(2:end),2)];
y2 = [repelem(sh2.YData(1:end-1),2),sh2.YData(end)];
x(isnan(x))=x(diff(isnan(x))>0);
y(isnan(y))=y(diff(isnan(y))>0);
x2(isnan(x2))=x2(diff(isnan(x2))>0);

y2(isnan(y2))=y2(diff(isnan(y2))>0);

stairs(0:length(cumSurv(1:end))-1,cumSurv(1:end))
xticks(1:length(cumSurv(1:end)))
xticklabels(abs(month))
hold on

patch([x,fliplr(x)], [y,fliplr(y2)],...
   [rand rand rand],'FaceAlpha',0.3,'EdgeColor','None')
hold on
scatter(ind2,cumSurv(ind2),'filled','b')
hold on
scatter(ind1,cumSurv(ind1),'r')
hold on
xlabel(value{4}),ylabel(value{5})
tab{i}=[month(indicesUn)' cums(indicesUn)' ste(indicesUn)'  CIlow(indicesUn)' CIup(indicesUn)'];

end
hold off
legend('SURV','Confidence Interval','Uncensored','Censored')

end
