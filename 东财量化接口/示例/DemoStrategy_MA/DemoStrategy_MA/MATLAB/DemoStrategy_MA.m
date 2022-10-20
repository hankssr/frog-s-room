function [data,date,rtn,retrace,indicators]=DemoStrategy_MA(codes,startdate,enddate,ma,capital) 
%%
%均线策略:
%   买入：金叉。多头行情时，股价偏离均线过高可以卖出，等股价回补均线时再买入
%   卖出：死叉。跌幅远离均线可以进去做短线，回补均线时候卖掉做差价
%   MA中线+MA长线金叉，判断为买入，满仓
%   MA中线+MA长线死叉，判断为卖出，空仓
%   MA短线+MA中线金叉，买入30%仓位
%   MA短线+MA中线死叉，卖出30%仓位
%
%输入:
%    codes={'000002.SZ';'600004.SH'}; %股票代码，支持数组
%    startdate='20170101';  %起始日期
%    enddate='20170701';    %截止日期
%    ma=[5,10,15];   %短线MA、中线MA、长线MA
%    capital=10^6;  %资金
%输出:
%   元胞数组，按个股区分
%   data：[收盘价,后复权收盘价,股本,买卖点,持股数,持股金额,流动资金,净值,收益率]
%   date：日期
%   rtn：期间收益率
%   retrace：回撤
%   indicators：data的表头


%登录API并获取数据
em=EmQuantMatlab();
errorid=em.start();
%输入默认值
if ~exist('codes','var')
   codes={'600519.SH';'600999.SH';'601318.SH';'600837.SH'};%em.sector('009007063',today);
   startdate='20170101';
   enddate='20170630';
   ma=[5,10,15];   %短线MA、中线MA、长线MA
   capital=10^6;  %资金
end
%获取交易日
date1=em.tradedates(startdate,enddate);  
%批量调用数据提取函数
data1=DemoImport_css(em,codes,date1,'Close','Close,TotalShare'); 
data2=DemoImport_css_MA(em,codes,date1,ma);

%调用均线策略计算函数
retrace=[];
for j=1:size(codes,1)
    try
        [data0,rtn0,retrace0,indicators,date0]=Demo_MA(data1{j,1},data2{j,1},capital,date1,codes{j,1});
        data{j,1}=data0;    %计算结果
        rtn{j,1}=rtn0;  %收益率
        retrace=[retrace;retrace0]; %回撤
        date{j,1}=date0;    %日期
        fprintf('%d\t%s\t%d\n',j,codes{j,1},rtn0);
    end
end



em.close
end

function [data,indicators]=DemoImport_css(em,codes,date,indicators1,indicators2)
%%
%数据提取：
%   通过css提取一段时间的股票收盘价、市值，并按股票作为元胞数组保存
%   codes可支持多只股票
%   date为交易日
%返回：
%   data为元胞数组，indicators为MA参数名

data1=[];data2=[];
for m=1:size(date,1)    %日
    varargin1=strcat('TradeDate=',date{m,1},',AdjustFlag=1,Period=1'); %日数据不复权收盘价
    varargin2=strcat('TradeDate=',date{m,1},',EndDate=',date{m,1},',AdjustFlag=2,Period=1'); %日数据后复权收盘价、股本
    data1=[data1;em.css(codes,indicators1,varargin1)];   %不复权收盘价
    data2=[data2;em.css(codes,indicators2,varargin2)];   %复权收盘价,市值
end
%按股票作为元胞数组保存
for j=1:size(codes,1)
    data{j,1}=[data1(j:size(codes):end,:),data2(j:size(codes):end,:)];
end
end

function [data,indicators]=DemoImport_css_MA(em,codes,date,ma)
%%
%数据提取，提取多条MA均线
%输入：
%   codes可支持多只股票
%   date为交易日
%输出：
%   data为元胞数组，indicators为MA参数名

%数据提取：通过css提取一段时间，不同种类的MA数据
indicators=[{strcat('MA',num2str(ma(1)))},{strcat('MA',num2str(ma(2)))},{strcat('MA',num2str(ma(3)))}];
data1=[];
for m=1:size(date,1)    %日
    data0=[];
    for n=1:size(ma,2) %MA
        varargin2=strcat('TradeDate=',date{m,1},',N=',num2str(ma(n)),',AdjustFlag=2,Period=1'); %日数据后复权
        data0=[data0,em.css(codes,'MA',varargin2)];
    end
    data1=[data1;data0];
end
%按股票作为元胞数组保存
for j=1:size(codes,1)
    data{j,1}=data1(j:size(codes):end,:);
end
end

function [data,rtn,retrace,indicators,date]=Demo_MA(data1,data2,capital,date,codes) 
%%
%均值策略
%输入：
%   data1=[收盘价,后复权收盘价,股本]
%   data2=MA
%   capital=资金量
%   date=日期
%   codes=股票代码
%输出：
%   data=[收盘价,后复权收盘价,股本,买卖点,持股数,持股金额,流动资金,净值,收益率]
%   rtn=收益率
%   retrace=回撤
%   indicators=data的表头
%   date=日期
%作图：
%   y1=收盘价
%   y2=与收盘价对应的收益

indicators=[{'收盘价'},{'后复权收盘价'},{'股本'},{'买卖点'},{'持股数'},{'持股金额'},{'流动资金'},{'净值'},{'收益率'}];
%数据清洗，去除无效值
[a,~]=find(isnan(data1));data1(a,:)=[];data2(a,:)=[];date(a,:)=[];
data1(:,4:9)=zeros(size(data1,1),6);
data1(1:11,7:8)=capital; %流动资金
buy=0; %判断是否初次持仓参数，初次持仓时变为1
for m=2:size(date,1)
    %判断金叉、死叉
    if data2(m-1,2)>data2(m-1,3) && data2(m,2)<data2(m,3)
        data1(m,4)=-1;
    elseif data2(m-1,1)>data2(m-1,2) && data2(m,1)<data2(m,2)
        data1(m,4)=-0.3;
    elseif data2(m-1,2)<data2(m-1,3) && data2(m,2)>data2(m,3)
        data1(m,4)=1;
    elseif data2(m-1,1)<data2(m-1,2) && data2(m,1)>data2(m,2)
        data1(m,4)=0.3;
    end
    %仓位变动
    %多头行情初次持仓100%
    %短线金叉、死叉变动30%，长线金叉、死叉变动100%
    if data1(m,4)==1 && buy==0  %初次持仓
        data1(m,5)=fix(capital/100/data1(m,1))*100; %股数
        buy=1;mark=m;
    elseif data1(m,4)==-0.3 && buy==1
        data1(m,5)=data1(m-1,5)-fix(data1(m-1,5)*0.3);
    elseif data1(m,4)==-1 && buy==1
        data1(m,5)=0;
    elseif data1(m,4)==0.3 && buy==1
        if data1(m-1,5)==0
            data1(m,5)=fix(data1(m-1,7)*0.3/100/data1(m,1))*100;
        else
            data1(m,5)=data1(m-1,5)+fix(data1(m-1,7)/100/data1(m,1))*100;
        end
    elseif data1(m,4)==1 && buy==1
        data1(m,5)=data1(m-1,5)+fix(data1(m-1,7)/100/data1(m,1))*100;
    else
        data1(m,5)=data1(m-1,5);
    end
	data1(m,6)=data1(m,5)*data1(m,1);   %所持股票市值
	data1(m,7)=data1(m-1,7)-(data1(m,5)-data1(m-1,5))*data1(m,1);   %流动资金
    data1(m,8)=data1(m,6)+data1(m,7); %净值
    data1(m,9)=(data1(m,8)-data1(1,8))/data1(1,8);  %收益率
end
%求最大回撤率
r2=0;
for i=1:m
	for j=i:m
        r1=(data1(i,8)-data1(j,8))/data1(j,8);
        r2=[r2,r1];
	end
end
retrace=max(r2); %回撤率
rtn=data1(end,9);
data=data1;
%作图
y1=data1(mark:end,1);
y2=data1(mark,1)/data1(mark,8)*data1(mark:end,8);
x1=datenum(datestr(char(date(mark:end))));
xmin=x1(1);
xmax=x1(end);
ymin=min([y1;y2]);
ymax=max([y1;y2]);
close all
figure (1)
hold on
set(gcf,'unit','centimeters','position',[3 5 30 15])
plot(x1,y1,'Color',[91,155,213]/255,'linewidth',2)
plot(x1,y2,'Color',[238,84,84]/255,'linewidth',2)
axis([xmin xmax ymin ymax]);
set(gca,'XTick',x1(1:fix(size(x1,1))/10:end))
xname=cellstr(datestr(x1(1:fix(size(x1,1))/10:end),'yyyymmdd'))';
set(gca,'XTickLabel',xname,'FontSize',6.5) 
legend('Close','Return','Location','EastOutside');
grid on
xlabel(strcat(codes,'   Time:',datestr(date{1,1},'yyyymmdd'),'-',...
    datestr(date{end,1},'yyyymmdd'),'   Return:',num2str(rtn),'   Retrace:',...
    num2str(retrace)))
saveas(figure(1),strcat('Demo_',codes,'.jpg'))
close all
save(strcat('Demo_',codes,'.mat'),'data','date','rtn','retrace','indicators')
end