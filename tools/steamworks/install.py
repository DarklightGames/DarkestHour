import os
import urllib2
from zipfile import ZipFile


SDK_URL = 'https://partner.steamgames.com/downloads/steamworks_sdk_138a.zip'


print 'Downloading Steamworks SDK...'
response = urllib2.urlopen(SDK_URL)
bytes = response.read()
cwd = os.path.dirname(os.path.realpath(__file__))
zip_path = os.path.join(cwd, 'steamworks_sdk.zip')
with open(zip_path, 'wb') as f:
    f.write(bytes)
with ZipFile(zip_path) as zipfile:
    zipfile.extractall()
os.remove(zip_path)
