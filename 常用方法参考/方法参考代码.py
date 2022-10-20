#获取过去 N 天的日期

def get_nday_list(n):
    before_n_days = []
    for i in range(1, n + 1)[::-1]:
        before_n_days.append(str(datetime.date.today() - datetime.timedelta(days=i)))
    return before_n_days

a = get_nday_list(30)
print(a)

#生成一段时间区间内的日期
import datetime

def create_assist_date(datestart = None,dateend = None):
    # 创建日期辅助表

    if datestart is None:
        datestart = '2016-01-01'
    if dateend is None:
        dateend = datetime.datetime.now().strftime('%Y-%m-%d')

    # 转为日期格式
    datestart=datetime.datetime.strptime(datestart,'%Y-%m-%d')
    dateend=datetime.datetime.strptime(dateend,'%Y-%m-%d')
    date_list = []
    date_list.append(datestart.strftime('%Y-%m-%d'))
    while datestart<dateend:
        # 日期叠加一天
        datestart+=datetime.timedelta(days=+1)
        # 日期转字符串存入列表
        date_list.append(datestart.strftime('%Y-%m-%d'))
    return date_list

d_list = create_assist_date(datestart='2021-12-27', dateend='2021-12-30')
d_list

#保存数据到CSV

def save_data(data, date):
    if not os.path.exists(r'2021_data_%s.csv' % date):
        with open("2021_data_%s.csv" % date, "a+", encoding='utf-8') as f:
            f.write("标题,热度,时间,url\n")
            for i in data:
                title = i["title"]
                extra = i["extra"]
                time = i['time']
                url = i["url"]
                row = '{},{},{},{}'.format(title,extra,time,url)
                f.write(row)
                f.write('\n')
    else:
        with open("2021_data_%s.csv" % date, "a+", encoding='utf-8') as f:
            for i in data:
                title = i["title"]
                extra = i["extra"]
                time = i['time']
                url = i["url"]
                row = '{},{},{},{}'.format(title,extra,time,url)
                f.write(row)
                f.write('\n')

