import requests
from bs4 import BeautifulSoup
import pandas as pd


url = 'http://68.100.168.134:8080/mpd/listinfractions.jsp'
r = requests.get(url)
soup = BeautifulSoup(r.text)

code = []
desc = []
shortDesc = []
fine = []

table = soup.find('table',{'width':'100%'})

for row in table.find_all('tr')[1:]:
    col = row.find_all('td')
    column_1 = col[0].string.strip()
    code.append(column_1)

    column_2 = col[1].string.strip()
    desc.append(column_2)

    column_3 = col[2].string.strip()
    shortDesc.append(column_3)

    column_4 = col[3].string.strip()
    fine.append(column_4)

columns = {'code': code, 'desc': desc, 'shortDesc': shortDesc, 'fine': fine}
parkMoveFines = pd.DataFrame(columns)
print parkMoveFines.head(10)

parkMoveFines.to_csv('parkMoveFines.csv')
