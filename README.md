# ImageViewer

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The ImageViewer is a very simple image viewer for iOS, which behaviour is inspired by the facebook app and completely written in Swift 2.0.

## Screenshots
![Preview](https://cloud.githubusercontent.com/assets/5786065/7445805/72750532-f1c2-11e4-8944-b213bccbce73.gif
) ![Preview](https://cloud.githubusercontent.com/assets/5786065/7445806/7277981a-f1c2-11e4-9e08-bdc488f8b6a3.gif
)



## Installation
Using [Carthage](https://github.com/Carthage/Carthage):

1. Create a cartfile with following content within your project directory: `github "mollywoodnini/ImageViewer"`
2. run `carthage update`. Carthage builds two frameworks (ImageViewer and Haneke) which you'll have to import to your project.
3. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop both frameworks from the Carthage/Build folder on disk.
4. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
```
/usr/local/bin/carthage copy-frameworks
```
and add the paths to the frameworks under “Input Files”:
```
$(SRCROOT)/Carthage/Build/iOS/ImageViewer.framework
$(SRCROOT)/Carthage/Build/iOS/Haneke.framework
```

## Usage
Just create an ImageView and prepare it for the ImageViewer via:
```swift
imageView.setupForImageViewer()
```
If you want to show a higher resoluted image when tapping on the ImageView use:
```swift
imageView.setupForImageViewer(highQualityImageUrl: NSURL(string: "https://your.url/image.png")!)
```

You can specify the background color of the ImageViewer too:
```swift
imageView.setupForImageViewer(highQualityImageUrl: NSURL(string: "https://your.url/image.png")!, backgroundColor: UIColor.redColor())
```

To hide the status bar add the "View controller-based status bar appearance" key to the Info.plist and set its value to NO.

## Requirements
- iOS 8.0+
- Xcode 7.0+

## License

Released under the MIT license. See the LICENSE file for more info.

## Credits
- <a href="https://github.com/Haneke/HanekeSwift">Thanks to Haneke for the awesome image cache!</a>
- <a href="https://icons8.com/web-app/3058/Close">Thanks to icons8.com for the close image!</a>
- <a href="https://github.com/michaelhenry/MHFacebookImageViewer">Thanks to Michael Henry, whose ImageViewer was a huge help for me to get this here done.</a>
