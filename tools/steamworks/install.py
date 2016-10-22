import os
import urllib2
from zipfile import ZipFile


'''
We host this on our Darklight Games server because we cannot download
from the Valve site directly without a valid login session in the
cookies. We also don't want to host this on GitHub since it doesn't
need to be versioned at all and it would be a needless 20+MB download
for each client, and only certain superusers are going to ever make use
of it.
'''
SDK_URL = 'http://darklightgames.com/tools/steamworks_sdk/steamworks_sdk_138a.zip'


print 'Downloading Steamworks SDK...'
print 'URL: %s' % SDK_URL
response = urllib2.urlopen(SDK_URL)
bytes = response.read()
cwd = os.path.dirname(os.path.realpath(__file__))
zip_path = os.path.join(cwd, 'steamworks_sdk.zip')
with open(zip_path, 'wb') as f:
    f.write(bytes)
with ZipFile(zip_path) as zipfile:
    zipfile.extractall(cwd)
os.remove(zip_path)
