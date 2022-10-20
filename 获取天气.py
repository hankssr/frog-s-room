import json
import logging as log

import requests


def get_weather_wind(url):
    r = requests.get(url)
    if r.status_code != 200:
        log.error("Can't get weather data!")
    info = json.loads(r.content.decode())

    # get wind data
    data = info['weatherinfo']
    WD = data['WD']
    WS = data['WS']
    return "{}({})".format(WD, WS)


def get_weather_city(url):
    # open url and get return data
    r = requests.get(url)
    if r.status_code != 200:
        log.error("Can't get weather data!")

        # convert string to json
    info = json.loads(r.content.decode())

    # get useful data
    data = info['weatherinfo']
    city = data['city']
    temp1 = data['temp1']
    temp2 = data['temp2']
    weather = data['weather']
    return "{} {} {}~{}".format(city, weather, temp1, temp2)


if __name__ == '__main__':
    msg = """**天气提醒**:   

{} {}   
{} {}   

来源: 国家气象局 
""".format(
        get_weather_city('http://www.weather.com.cn/data/cityinfo/101021200.html'),
        get_weather_wind('http://www.weather.com.cn/data/sk/101021200.html'),
        get_weather_city('http://www.weather.com.cn/data/cityinfo/101020900.html'),
        get_weather_wind('http://www.weather.com.cn/data/sk/101020900.html')
    )
    print(msg)