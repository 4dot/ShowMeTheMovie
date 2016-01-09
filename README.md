# README #

- iPhone app with Modern Architecture.
- This is iOS sample application that Using Apple Advanced UICollectionView library.

Development environment: 
Xcode 7.1

# Installation

Podfile

    platform :ios, '6.1'
    pod 'SDWebImage', '~>3.7'
    pod 'UIActivityIndicator-for-SDWebImage'

# Class hierarchy

# Information flow
![Information flow](https://github.com/4dot/ShowMeTheMovie/doc/program/ShowMeTheMovie_information_flow.pdf)

# DataCacheManager

- Below the workflow represent how the DataCacheManager works. A URL request is used to make a hash key for the dump file name using MD5. 
