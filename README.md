# ImageViewer

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Very simple image viewer inspired by facebook and completely written in SWIFT.

## Installation

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

## Requirements
- iOS 8.0+
- Xcode 6.3

## License

Released under the MIT license. See the LICENSE file for more info.

## Credits
Thanks to https://github.com/Haneke/HanekeSwift for the image cache!
<a href="https://icons8.com/web-app/3058/Close">Close icon credits</a>
