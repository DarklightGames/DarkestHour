import os
import urllib2
from zipfile import ZipFile

def download_sdk():
	response = urllib2.urlopen('https://partner.steamgames.com/downloads/steamworks_sdk.zip')
	bytes = response.read()
	with open('steamworks_sdk.zip', 'wb') as f:
		f.write(bytes)
	zipfile = ZipFile('steamworks_sdk.zip')
	zipfile.extractall()
	os.remove('steamworks_sdk.zip')

download_sdk()