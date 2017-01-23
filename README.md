# README #

- iPhone app with Modern Architecture.
- This is iOS sample application that Using Apple Advanced UICollectionView library.
- Development environment: Xcode 7.1

# Installation

Podfile

    platform :ios, '6.1'
    pod 'SDWebImage', '~>3.7'
    pod 'UIActivityIndicator-for-SDWebImage'
    
Connect to Server
- ShowMeTheMovieAppDelegate.m
```Obj-C
    // Change Server Type
    // FakeServer is using with local json file for test.
    // RealServer is using real data from server.
    
    FakeServer* server = [[FakeServer alloc] init];
    //RealServer* server = [[RealServer alloc] init];
```
- You can take API key if you need connect to real server. https://www.themoviedb.org/documentation/api

# Class hierarchy

# Information flow
![Information flow](https://raw.github.com/4dot/ShowMeTheMovie/master/doc/program/ShowMeTheMovie_information_flow.png)

# DataCacheManager

- The Information flow represent how the DataCacheManager works. A URL request is used to make a hash key for the dump file name using MD5. 
