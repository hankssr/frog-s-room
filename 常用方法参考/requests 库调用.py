#发送 GET 请求
import requests


headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
  'cookie': 'some_cookie'
}
response = requests.request("GET", url, headers=headers)




#发送 POST 请求
import requests
payload={}
files=[]
headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
  'cookie': 'some_cookie'
}
response = requests.request("POST", url, headers=headers, data=payload, files=files)

#根据某些条件循环请求，比如根据生成的日期


def get_data(mydate):
    date_list = create_assist_date(mydate)
    url = "https://test.test"
    files=[]
    headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
        'cookie': ''
        }
    for d in date_list:
        payload={'p': '10',
        'day': d,
        'nodeid': '1',
        't': 'itemsbydate',
        'c': 'node'}
        for i in range(1, 100):
            payload['p'] = str(i)
            print("get data of %s in page %s" % (d, str(i)))
            response = requests.request("POST", url, headers=headers, data=payload, files=files)
            items = response.json()['data']['items']
            if items:
                save_data(items, d)
            else:
                break

