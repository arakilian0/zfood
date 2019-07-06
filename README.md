# zfood

Inspired by Sillicone Valley's (S4E4) SeeFood APP Demo! - [video](https://www.youtube.com/watch?v=FNyi3nAuLb0)

Requirements:
-------------

- xcode(version-10.2.1) - https://developer.apple.com/xcode/
- carthage - https://github.com/Carthage/Carthage
- ibm watson visual recognition api - https://www.ibm.com/watson/services/visual-recognition/
- watson/swift-sdk - https://github.com/watson-developer-cloud/swift-sdk
- SVProgressHUD - https://github.com/SVProgressHUD/SVProgressHUD

So all you really need to have is this repo, Xcode, Homebrew, and your api key.
Once you have those 4 we can get going.

Using the App Store on your mac machine, search for Xcode, and install. (Make sure it's provided by Apple)

Next, using [Homebrew](https://brew.sh/), install Carthrage

```
brew install carthrage
```

Next, go to [IBM Watson site](https://www.ibm.com/watson/services/visual-recognition/) and get yourself an API key to use the IBM Watson Visual Recognition API

Once you have that all done, open the `ViewController.swift` file and where it says apiKey(line 15), replace "your-ibm-watson-visual-recognition-api-key" with your actual apikey.

Finally build and test your app!

Screenshots
-----------

#### Launch Screen, Main App View, and Image Picker
![alt text](https://raw.githubusercontent.com/arakilian0/zfood/master/screenshot1.png)


#### Possible results
![alt text](https://raw.githubusercontent.com/arakilian0/zfood/master/screenshot2.png)
