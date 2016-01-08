# README #

iPhone app with Modern Architecture.

Development environment: 
Xcode 7.1

-----------

# ** Class hierarchy **
-----------


# ** Information flow **
-----------
- Below the diagram represent how the news data(ItemBase class) comes from the server to the specific UI such as ItemDetailView class.

![Information flow](doc/program/ShowMeTheMovie_information_flow.pdf) 




# ** DataCacheManager **
-----------
- Below the workflow represent how the DataCacheManager works. A URL request is used to make a hash key for the dump file name using MD5. 
When the app get back data from the server, DataCacheManager dumps the response data to the file.
When the app makes a request using the same URL sometimes later, the DataCacheManager looks for the dump file in the local device. If the file exist, then it returns the response data from the dump file. If the dump file does not exist or it's too old, then a request is made to the server to get the newest information.

