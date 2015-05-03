# ImageViewer

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The ImageViewer is a very simple image viewer for iOS, which behaviour is inspired by the facebook app and completely written in Swift.

## Installation
Using [Carthage](https://github.com/Carthage/Carthage):

```
github "mollywoodnini/ImageViewer"
```
Carthage builds two frameworks (ImageViewer and Haneke) which you'll have to import to your project.

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
- Xcode 6.3

## License

Released under the MIT license. See the LICENSE file for more info.

## Credits
- <a href="https://github.com/Haneke/HanekeSwift">Thanks to Haneke for the awesome image cache!</a>
- <a href="https://icons8.com/web-app/3058/Close">Thanks to icons8.com for the close image!</a>
- <a href="https://github.com/michaelhenry/MHFacebookImageViewer">Thanks to Michael Henry, whose ImageViewer was a huge help for me to get this here done.</a>
