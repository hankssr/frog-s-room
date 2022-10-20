# -*- coding:utf-8 -*-
from bs4 import BeautifulSoup
import requests
import pymysql
#定义目标网站url
url='https://www.geyanw.com/'
# #编写模拟浏览器获取
headers = {'User-Agent':'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
           'Accept':'text/html;q=0.9,*/*;q=0.8',
           'Accept-Charset':'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
           'Accept-Encoding':'gzip',
           'Connection':'close',
           'Referer':None #注意如果依然不能抓取的话，这里可以设置抓取网站的host
}
html=requests.get(url,headers=headers,).content.decode('gbk')

#创建BeautifulSoup对象
soup=BeautifulSoup(html,'lxml')
#将HTML的实例转换成Unicode编码,打印soup对象内容,格式化输出.
dd_div_list = soup.find_all({"dd"})
#找出soup中所有的dd标签写成列表
for dd_div in dd_div_list:
    #遍历获得每个dd标签
    li_div_list=dd_div.find_all({'li'})
    #找出dd_div中的li标签
    for li_div in li_div_list:
        #遍历获取每个li标签
        a_div_list=li_div.find_all({"a"})
        #找出li_div标签中的a标签
        for a_div in a_div_list:
            #遍历出a标签
            geyan_urls=url+a_div["href"]
            #找出a标签href拼接得到详情页的URL
            geyan_name=a_div["title"]
            #定义a标签的title为名字
            conn = pymysql.connect(host='127.0.0.1', port=3306, db='geyan', user='root', passwd='root')
            #定义数据库
            with conn.cursor() as cursor:
                sql = 'INSERT INTO geyan_xiangqing(name,urls) VALUES (%s,%s)'
                #写原生sql语句
                cursor.execute(sql,(geyan_name,geyan_urls))
                #插入数据
                conn.commit()
                #调用数据库
            print(geyan_urls)
            #输出URL
            print(geyan_name)
            #输出名字
