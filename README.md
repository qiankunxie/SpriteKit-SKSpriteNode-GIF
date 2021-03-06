# SpriteKit-SKSpriteNode-GIF

A small `SKSpreiteNode` extension with gif support.

## Prepare

Modify info.plist for remote downloading and animating

Add key `App Transport Security Settings`

Add a child of `App Transport Security Settings` called `Allow Arbitrary Loads`
  
Change value to `YES`

## Usage
Import the `SKSpriteNode+GIF.swift` in your project and do the following:

### Animate Local GIF
```swift
// create a empty SKSprtieNode and set the size, postion and zPosition 
let localgif = SKSpriteNode()
localgif.size = CGSize(width: 1, height: 0.3) * size
localgif.position = CGPoint(x: 0.5, y: 0.35) * size
addChild(localgif)

// call the function to load the file in main bundle to animate the gif
// currently each texture is animating for 0.1 sec
localgif.animateWithLocalGIF(fileNamed: "shooterMcGavin")
```
### Animate Remote GIF with url
```swift
// transfer stirng to NSURL object
let nsurl = NSURL(string: "http://d38cjvupbxhsu.cloudfront.net/jackblack.gif")
// create empty spritenode
let gifnode = SKSpriteNode()
gifnode.size = CGSize(width: 1, height: 0.3) * size
gifnode.position = CGPoint(x: 0.5, y: 0.75) * size
addChild(gifnode)

// call the function to load the file in main bundle to animate the gif
// currently each texture is animating for 0.1 sec 
gifnode.animateWithRemoteGIF(nsurl!)
```


# Inspiration
This project is heavily inspired by [SwiftGif](https://github.com/bahlo/SwiftGif/blob/master/README.md).:thumbsup:

# License
This repository is licensed under the MIT license.



