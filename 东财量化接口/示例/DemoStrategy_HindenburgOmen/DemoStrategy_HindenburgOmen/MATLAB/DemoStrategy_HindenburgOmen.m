function DemoStrategy_HindenburgOmen
% �˵Ǳ����ף�
% �˵Ǳ����׵ı����ǹ�������ת���򱩵�ʱ����������Ե��г��ֻ���
% ���ɸ����������ҵ�������Ըߣ����г��������Եͣ�
% �����ò��ֹ�Ʊ���¸߲��ִ��µ��������г��ķֻ��̶ȣ� 
% A�ɸ����������ҵ�������Եͣ����г��������Ըߣ�
% ����ͨ������������г������ϵ���������г��ֻ��̶ȡ�


%��¼API����ȡ����
warning off
em=EmQuantMatlab();
errorid=em.start('forcelogin=1');
%��֤A��
sector='2000032255';
startdate='20160101';
enddate='20161231';
date=em.tradedates(startdate,enddate);
codes=em.sector(sector,startdate);
index='000001.SH';
close=import_csd(em,codes,'close',startdate,enddate,'');
indexSH=import_csd(em,index,'close',startdate,enddate,'');
meanRsq=zeros(size(date,1),1);
for n=30:size(date)
    newcodes=em.sector(sector,date(n-29));
    [~,ia,~]=intersect(codes(:,1),newcodes(:,1));
    [addcodes,ic]=setdiff(newcodes(:,1),codes(:,1));
    if ~isempty(addcodes)
        addclose=import_csd(em,addcodes,'close',startdate,enddate,'');
        close=[close,addclose];
        codes=[codes;newcodes(ic,:)];
    end
    X=close(n-29:n,[ia',(end-size(ic,1)+1):end]);
    for m=size(X,2):-1:1
        %stats=[R Square,F,Prob,Estimator of error variance]
        [~,~,~,~,stats] = regress(indexSH(n-29:n),[ones(30,1),X(:,m)]);
        Rsq(m)=stats(1);
    end
    meanRsq(n)=mean(Rsq);
end
k=zeros(size(date,1),1);
k(34:end)=(meanRsq(34:end)-meanRsq(31:end-3))./meanRsq(31:end-3);
mark=[datenum(datestr(char(date(k>0.3)))),indexSH(k>0.3)];
%��ͼ
figure (1)
hold on 
set(gcf,'unit','centimeters','position',[3 5 30 15])
x=datenum(datestr(char(date(30:end,:))));
plot(x,indexSH(30:end,:),'Color','r')
plot(mark(:,1),mark(:,2),['o','k'],'linewidth',2)
datetick('x','yyyymmdd','keepticks')
grid on
legend('000001.SH','Mark','Location','EastOutside');
ylabel('Close of 000001.SH')
xlabel('Hindenburg Omen')
end

%%
%��������
function datas=import_csd(em,incodes,inindicators,instartdate,inenddate,varargin)
n=0;
if size(incodes,1)==1
        [datas,~,~,~,erroid]=em.csd(incodes,inindicators,instartdate,inenddate,cell2mat(varargin));
else
    while n<=2
        try
            [datas,~,~,~,erroid]=em.csd(incodes(:,1),inindicators,instartdate,inenddate,cell2mat(varargin));
            return
        catch
            %pause(5)
            fprintf('������...')
            errorid=em.start('forcelogin=1');
            n=n+1;
        end
    end
end
end