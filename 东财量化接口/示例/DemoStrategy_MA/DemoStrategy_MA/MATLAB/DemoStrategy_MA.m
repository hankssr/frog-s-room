function [data,date,rtn,retrace,indicators]=DemoStrategy_MA(codes,startdate,enddate,ma,capital) 
%%
%���߲���:
%   ���룺��档��ͷ����ʱ���ɼ�ƫ����߹��߿����������ȹɼۻز�����ʱ������
%   ���������档����Զ����߿��Խ�ȥ�����ߣ��ز�����ʱ�����������
%   MA����+MA���߽�棬�ж�Ϊ���룬����
%   MA����+MA�������棬�ж�Ϊ�������ղ�
%   MA����+MA���߽�棬����30%��λ
%   MA����+MA�������棬����30%��λ
%
%����:
%    codes={'000002.SZ';'600004.SH'}; %��Ʊ���룬֧������
%    startdate='20170101';  %��ʼ����
%    enddate='20170701';    %��ֹ����
%    ma=[5,10,15];   %����MA������MA������MA
%    capital=10^6;  %�ʽ�
%���:
%   Ԫ�����飬����������
%   data��[���̼�,��Ȩ���̼�,�ɱ�,������,�ֹ���,�ֹɽ��,�����ʽ�,��ֵ,������]
%   date������
%   rtn���ڼ�������
%   retrace���س�
%   indicators��data�ı�ͷ


%��¼API����ȡ����
em=EmQuantMatlab();
errorid=em.start();
%����Ĭ��ֵ
if ~exist('codes','var')
   codes={'600519.SH';'600999.SH';'601318.SH';'600837.SH'};%em.sector('009007063',today);
   startdate='20170101';
   enddate='20170630';
   ma=[5,10,15];   %����MA������MA������MA
   capital=10^6;  %�ʽ�
end
%��ȡ������
date1=em.tradedates(startdate,enddate);  
%��������������ȡ����
data1=DemoImport_css(em,codes,date1,'Close','Close,TotalShare'); 
data2=DemoImport_css_MA(em,codes,date1,ma);

%���þ��߲��Լ��㺯��
retrace=[];
for j=1:size(codes,1)
    try
        [data0,rtn0,retrace0,indicators,date0]=Demo_MA(data1{j,1},data2{j,1},capital,date1,codes{j,1});
        data{j,1}=data0;    %������
        rtn{j,1}=rtn0;  %������
        retrace=[retrace;retrace0]; %�س�
        date{j,1}=date0;    %����
        fprintf('%d\t%s\t%d\n',j,codes{j,1},rtn0);
    end
end



em.close
end

function [data,indicators]=DemoImport_css(em,codes,date,indicators1,indicators2)
%%
%������ȡ��
%   ͨ��css��ȡһ��ʱ��Ĺ�Ʊ���̼ۡ���ֵ��������Ʊ��ΪԪ�����鱣��
%   codes��֧�ֶ�ֻ��Ʊ
%   dateΪ������
%���أ�
%   dataΪԪ�����飬indicatorsΪMA������

data1=[];data2=[];
for m=1:size(date,1)    %��
    varargin1=strcat('TradeDate=',date{m,1},',AdjustFlag=1,Period=1'); %�����ݲ���Ȩ���̼�
    varargin2=strcat('TradeDate=',date{m,1},',EndDate=',date{m,1},',AdjustFlag=2,Period=1'); %�����ݺ�Ȩ���̼ۡ��ɱ�
    data1=[data1;em.css(codes,indicators1,varargin1)];   %����Ȩ���̼�
    data2=[data2;em.css(codes,indicators2,varargin2)];   %��Ȩ���̼�,��ֵ
end
%����Ʊ��ΪԪ�����鱣��
for j=1:size(codes,1)
    data{j,1}=[data1(j:size(codes):end,:),data2(j:size(codes):end,:)];
end
end

function [data,indicators]=DemoImport_css_MA(em,codes,date,ma)
%%
%������ȡ����ȡ����MA����
%���룺
%   codes��֧�ֶ�ֻ��Ʊ
%   dateΪ������
%�����
%   dataΪԪ�����飬indicatorsΪMA������

%������ȡ��ͨ��css��ȡһ��ʱ�䣬��ͬ�����MA����
indicators=[{strcat('MA',num2str(ma(1)))},{strcat('MA',num2str(ma(2)))},{strcat('MA',num2str(ma(3)))}];
data1=[];
for m=1:size(date,1)    %��
    data0=[];
    for n=1:size(ma,2) %MA
        varargin2=strcat('TradeDate=',date{m,1},',N=',num2str(ma(n)),',AdjustFlag=2,Period=1'); %�����ݺ�Ȩ
        data0=[data0,em.css(codes,'MA',varargin2)];
    end
    data1=[data1;data0];
end
%����Ʊ��ΪԪ�����鱣��
for j=1:size(codes,1)
    data{j,1}=data1(j:size(codes):end,:);
end
end

function [data,rtn,retrace,indicators,date]=Demo_MA(data1,data2,capital,date,codes) 
%%
%��ֵ����
%���룺
%   data1=[���̼�,��Ȩ���̼�,�ɱ�]
%   data2=MA
%   capital=�ʽ���
%   date=����
%   codes=��Ʊ����
%�����
%   data=[���̼�,��Ȩ���̼�,�ɱ�,������,�ֹ���,�ֹɽ��,�����ʽ�,��ֵ,������]
%   rtn=������
%   retrace=�س�
%   indicators=data�ı�ͷ
%   date=����
%��ͼ��
%   y1=���̼�
%   y2=�����̼۶�Ӧ������

indicators=[{'���̼�'},{'��Ȩ���̼�'},{'�ɱ�'},{'������'},{'�ֹ���'},{'�ֹɽ��'},{'�����ʽ�'},{'��ֵ'},{'������'}];
%������ϴ��ȥ����Чֵ
[a,~]=find(isnan(data1));data1(a,:)=[];data2(a,:)=[];date(a,:)=[];
data1(:,4:9)=zeros(size(data1,1),6);
data1(1:11,7:8)=capital; %�����ʽ�
buy=0; %�ж��Ƿ���γֲֲ��������γֲ�ʱ��Ϊ1
for m=2:size(date,1)
    %�жϽ�桢����
    if data2(m-1,2)>data2(m-1,3) && data2(m,2)<data2(m,3)
        data1(m,4)=-1;
    elseif data2(m-1,1)>data2(m-1,2) && data2(m,1)<data2(m,2)
        data1(m,4)=-0.3;
    elseif data2(m-1,2)<data2(m-1,3) && data2(m,2)>data2(m,3)
        data1(m,4)=1;
    elseif data2(m-1,1)<data2(m-1,2) && data2(m,1)>data2(m,2)
        data1(m,4)=0.3;
    end
    %��λ�䶯
    %��ͷ������γֲ�100%
    %���߽�桢����䶯30%�����߽�桢����䶯100%
    if data1(m,4)==1 && buy==0  %���γֲ�
        data1(m,5)=fix(capital/100/data1(m,1))*100; %����
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
	data1(m,6)=data1(m,5)*data1(m,1);   %���ֹ�Ʊ��ֵ
	data1(m,7)=data1(m-1,7)-(data1(m,5)-data1(m-1,5))*data1(m,1);   %�����ʽ�
    data1(m,8)=data1(m,6)+data1(m,7); %��ֵ
    data1(m,9)=(data1(m,8)-data1(1,8))/data1(1,8);  %������
end
%�����س���
r2=0;
for i=1:m
	for j=i:m
        r1=(data1(i,8)-data1(j,8))/data1(j,8);
        r2=[r2,r1];
	end
end
retrace=max(r2); %�س���
rtn=data1(end,9);
data=data1;
%��ͼ
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