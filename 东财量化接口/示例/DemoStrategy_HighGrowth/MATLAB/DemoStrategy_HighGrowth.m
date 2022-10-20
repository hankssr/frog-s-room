function [data,rtn,retrace,order,indicators]=DemoStrategy_HighGrowth(startyear,endyear,sector,index,capital)
%%
%�߳ɳ���ɲ���
%���Ȩ�أ���ֵ��Ȩ
%��ϸ���Ƶ�ʣ���
%
%����:
%	startyear=2012;   %��ʼ��
%	endyear=2017; %��ֹ��
%   sector='009007063';   %������
%   index='000016.SH';  %��ͼ�Ƚϵ�ָ������
%	captial=10^7;  %�ʽ�
%���:
%   data��[����,�ֲ���ϸ,��λ�䶯��ϸ,�ֲֽ��,�����ʽ�,��ֵ,������]
%   date������
%   rtn���ڼ�������
%   retrace���س�
%	order����λ�䶯��ϸ
%   indicators��data�ı�ͷ

%%
%��¼API����ȡ����
warning off
em=EmQuantMatlab();
errorid=em.start('forcelogin=1');
%����Ĭ��ֵ
if ~exist('startyear','var')
    startyear=2012;
    endyear=2017;
    sector='009007063';
    index='000016.SH';  %��ͼ�Ƚ�
    capital=10^7;  %�ʽ�
end
%��ȡ��Ʊ���룬ɸѡstartyear-3��ǰ���еĹ�Ʊ
%��ȡ��������������
startdate=strcat(num2str(startyear-1),'/12/31');%20111231
enddate=strcat(num2str(endyear),'/12/31');%20171231
codes0=em.sector(sector,'2017/10/10');
listdate=em.css(codes0(:,1),'LISTDATE');
reportdate1=datenum(strcat(num2str(startyear-4),'/01/01'),'yyyy/mm/dd');%20080101
codes0(find(datenum(char(listdate))>reportdate1),:)=[];
date=em.tradedates(strcat(num2str(startyear),'/04/01'),enddate,'Period=2');
%������ִ�����3�¿ɻ�ȡ����һ���걨��Ϣ
if endyear==str2double(datestr(today,'yyyy')) && str2double(datestr(today,'mm'))<4
    y=endyear-startyear+3; 
else
    y=endyear-startyear+4;  
end
%%
%��ȡ��Ȳ������ݣ�
%   ͨ��css��ȡEPS���������롢������ͬ�������ʡ�Ӫҵ����ͬ�������ʡ����ʲ�ͬ��������
%   ����3��EPS����������������ֵ
%   FinancialData=[3��EPS�����ʾ�ֵ,3���������������ʾ�ֵ,������ͬ�������ʡ�
%                   Ӫҵ����ͬ�������ʡ����ʲ�ͬ��������]
%   ��������ɸѡ
%   codes{:,3}=���������Ĺ�Ʊ����

codes=cell(y-3,3);
for n=1:y %2007-2016��Ȳ�������
    reportdate=strcat(num2str(startyear-5+n),'/12/31');
	varargin1=strcat('ReportDate=',reportdate);
    EpsMr(:,:,n)=import_css(em,codes0,'EPSBASIC,MBREVENUE',varargin1); %EPS����������
    if n>3
        FinancialData(:,1,n-3)=(EpsMr(:,1,n)-EpsMr(:,1,n-1))./EpsMr(:,1,n-1)/3+...
            (EpsMr(:,1,n-1)-EpsMr(:,1,n-2))./EpsMr(:,1,n-2)/3+...
            (EpsMr(:,1,n-2)-EpsMr(:,1,n-3))./EpsMr(:,1,n-3)/3;  %3��EPS�����ʾ�ֵ
        FinancialData(:,2,n-3)=(EpsMr(:,2,n)-EpsMr(:,2,n-1))./EpsMr(:,2,n-1)/3+...
            (EpsMr(:,2,n-1)-EpsMr(:,2,n-2))./EpsMr(:,2,n-2)/3+...
            (EpsMr(:,2,n-2)-EpsMr(:,2,n-3))./EpsMr(:,2,n-3)/3;  %3���������������ʾ�ֵ
        %������ͬ�������ʡ�Ӫҵ����ͬ�������ʡ����ʲ�ͬ��������
        FinancialData(:,3:5,n-3)=import_css(em,codes0,'YOYNI,YOYGR,YOYEQUITY',varargin1);
        incpsindicators2=strcat('s,PEG,',reportdate,',6');
        %����ɸѡ%%%%%%%%%%%%%%
        err1=1;  %���������жϲ���
        while err1~=0
            try
                [codes{n-3,1},~,~,~,err1]=em.cps(codes0(:,1),incpsindicators2,'[s]<1');
            catch
                fprintf('������...')
                errorid=em.start('forcelogin=1');
            end
        end
        try
            if isnan(codes{n-3,1}),codes{n-3,1}=[];end %�޷���������Ʊ��ȡ[];
        end
        yr_codes0=codes0;yr_FinancialData=FinancialData(:,:,n-3);
        [m1,~]=find(isnan(yr_FinancialData));yr_FinancialData(m1,:)=[];yr_codes0(m1,:)=[];%ȥ����Ч����
        [m2,~]=sort(yr_FinancialData(:,1),'descend');
        [m3,~]=sort(yr_FinancialData(:,2),'descend');
        [m4,~]=find(yr_FinancialData(:,1)>m2(fix(size(m2,1)/2))...
            & yr_FinancialData(:,2)>m3(fix(size(m3,1)/2)) & all(yr_FinancialData>0,2));
        codes{n-3,2}=yr_codes0(m4,1);
        codes{n-3,3}=intersect(codes{n-3,1},codes{n-3,2});    %���������Ĺ�Ʊ����
    end
end

%%
%�����λ�����������
%   ÿ����ĩ����
%   ����δɸѡ�����ʹ�Ʊ���ղ�
%   data=[����,�ֲ���ϸ,��λ�䶯��ϸ,�ֲֽ��,�����ʽ�,��ֵ,������]
%   data{:,2}=[�ֲ���ϸ]=[����,��Ʊ����,���̼�,��ֵ,�ֹɱ���,�ֹ���,�ֲֽ��]
%   data{:,3}=[��λ�䶯��ϸ]=[����,��Ʊ����,����,��������,����,���׼۸�]

indicators=[{'����'},{'�ֲ���ϸ'},{'��λ�䶯��ϸ'},{'�ֲֽ��'},{'�����ʽ�'},{'��ֵ'},{'������'}];
data(:,1)=cellstr(datestr(datenum(char(date())),'yyyy/mm/dd'));
buy=0;%�ж��Ƿ���γֲֲ��������γֲ�ʱ��Ϊ1
chgMon=[str2num(cell2mat(data(:,1))),zeros(size(data,1),2)];
chgMon(:,2)=cell2mat(cellfun(@(x) str2num(x(6:7)),data(:,1),'UniformOutput',false));
order=[];
%�������ڶ�Ӧ�������;
for n=1:size(date,1)
    if chgMon(n,2)>3
        chgMon(n,3)=str2num(data{n,1}(1:4))-1;
    else
        chgMon(n,3)=str2num(data{n,1}(1:4))-2;
    end
end
for n=1:size(data,1)
    if n== 258
        disp(n)
    else
        disp(n)
    end
    varargin2=strcat('TradeDate=',data{n,1},',AdjustFlag=2');
    if n==1 %��һ��
        oldportfolio=cell(0,4);oldcapital=capital;
    elseif isempty(data{n-1,2})  %���δ�ֲ�
        oldportfolio=cell(0,4);oldcapital=data{n-1,5};
    else
        %oldportfolioΪ������ڵ����յļ۸񡢳ֲ����
        oldportfolio=[data{n-1,2}(:,1),import_css(em,data{n-1,2}(:,1),'NAME,Close',varargin2),...
            data{n-1,2}(:,6)];%������ڵ����յ�[����,����,���̼�,�ֹ���]
        oldcapital=sum(cell2mat(oldportfolio(:,3)).*cell2mat(oldportfolio(:,4)))+data{n-1,5};
    end
    %����data{n,2}=[�ֲ���ϸ]=[����,��Ʊ����,���̼�,��ֵ,�ֹɱ���,�ֹ���,�ֲֽ��]
    
    data{n,2}(:,1)=codes{chgMon(n,3)-startyear+2,3};    %�ֲ���ϸ
    data_2=zeros(size(data{n,2}(:,1),1),7);
    if isempty(codes{chgMon(n,3)-startyear+2,3})
        data{n,2}=cell(0,7);    %���δѡ����Ʊ
    else
        data{n,2}(:,2:4)=import_css(em,data{n,2}(:,1),'NAME,Close,MV',varargin2);
        data_2(:,3:4)=cell2mat(data{n,2}(:,3:4));
        if isequal(oldportfolio(:,1),data{n,2}(:,1))
            data_2(:,6)=cell2mat(data{n-1,2}(:,6));
        else
            data_2(:,5)=data_2(:,4)./sum(data_2(:,4)); %�ֹɱ���
            data_2(:,6)=fix(oldcapital*data_2(:,5)./data_2(:,3)/100)*100;    %����
        end
        data_2(:,7)=data_2(:,3).*data_2(:,6);  %�ֲֽ��
        data_2(:,5)=data_2(:,7)./sum(data_2(:,7)); %�ֹɱ���
        data{n,2}(:,5:7)=num2cell(data_2(:,5:7));
    end
    %�����λ�䶯��ϸ=[����,��Ʊ����,����,��������,����,���׼۸�]
    [m3,c1,c2]=intersect(oldportfolio(:,1),data{n,2}(:,1));
    [~,c3]=setdiff(data{n,2}(:,1),m3);
    [~,c4]=setdiff(oldportfolio(:,1),m3);
    change=[];
    change=[m3,data{n,2}(c2,2),...
        num2cell(cell2mat(data{n,2}(c2,6))-cell2mat(oldportfolio(c1,4))),...
        data{n,2}(c2,3)];%  ���ֹ�Ʊ
    change=[change;data{n,2}(c3,[1,2,6,3])];    %�������Ʊ
    change=[change;oldportfolio(c4,1:2),num2cell(-cell2mat(oldportfolio(c4,4))),...
        oldportfolio(c4,3)];    %��ֹ�Ʊ
    data{n,3}=[change(:,1:2),repmat([data{n,1},{'����'}],size(change,1),1),change(:,3:4)];
    data{n,3}(find(cell2mat(data{n,3}(:,5))<0),4)={'����'};
    data{n,3}(find(cell2mat(data{n,3}(:,5))==0),:)=[];
    data{n,4}=sum(data_2(:,7));  %�ֲֽ��
    if size(data{n,3},1)~=0 || n==1
        data{n,5}=oldcapital-data{n,4};   %�����ʽ�,������
    else
        data{n,5}=data{n-1,5};  %�����ʽ𣬷ǵ�����
    end
    data{n,6}=data{n,4}+data{n,5};  %��ֵ
    data{n,7}=(data{n,6}-capital)/capital;  %������
    order=[order;data{n,3}];
end


%%
%�����س��ʡ���������
r2=0;
for i=1:n
	for j=i:n
        r1=(data{i,6}-data{j,6})/data{j,6};
        r2=[r2,r1];
	end
end
retrace=max(r2); %�س���
rtn=data{end,7};    %��������

%%
%��ͼ����������
err2=1;
while err2~=0
    try
        [y1,~,~,~,err2]=em.csd(index,'CLOSE',date{1,1},date{end,1},'Period=2');
    catch
        fprintf('������...')
        errorid=em.start('forcelogin=1');
    end
end

y0=cell2mat(data(:,6));
y2=y1(1,1)/y0(1,1)*y0;
x1=datenum(datestr(char(date)));
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
xname=cellstr(datestr(x1(1:fix(size(x1,1))/10:end),'yyyy/mm/dd'))';
set(gca,'XTickLabel',xname,'FontSize',6.5) 
legend(index,'Return','Location','EastOutside');
grid on
xlabel(strcat('Time:',num2str(startyear),'-',num2str(endyear),'   Return:',...
    num2str(rtn),'   Retrace:',num2str(retrace)),'FontSize',8)
saveas(figure(1),'Demo.jpg')
close all
save('Demo.mat','data','rtn','order','retrace')
em.close

end

function datas=import_css(em,incodes,inindicators,varargin)
erroid=1;%���������жϲ���
while erroid~=0
    try
        [datas,~,~,~,erroid]=em.css(incodes,inindicators,cell2mat(varargin));
    catch
        %pause(5)
        fprintf('������...')
        errorid=em.start('forcelogin=1');
    end
end
end