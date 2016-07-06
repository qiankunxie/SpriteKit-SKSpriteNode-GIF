//The MIT License (MIT)
//
//Copyright (c) 2016 Qiankun Xie
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

//
//  SKSpriteKit+GIF.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 7/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.


import SpriteKit
import ImageIO

extension SKSpriteNode{
    
    func animateWithRemoteGIF(url: NSURL){
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        config.URLCache = NSURLCache.sharedURLCache()
        
        let session = NSURLSession(configuration: config)
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url, response, error in
            if error == nil, let url = url, data = NSData(contentsOfURL: url), textures = SKSpriteNode.gifWithData(data) {
                dispatch_async(dispatch_get_main_queue()) {
                    if let strongSelf = self {
                        let action = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1))
                        strongSelf.runAction(action)
                    }
                }
            } else {
                print(error?.domain)
                print(error?.code)
            }
            session.finishTasksAndInvalidate()
            })
        
        downloadTask.resume()
        
    }

    
    func animateWithLocalGIF(fileNamed name:String){
        
        // Check gif
        guard let bundleURL = NSBundle.mainBundle()
            .URLForResource(name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return
        }
        
        // Validate data
        guard let imageData = NSData(contentsOfURL: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return
        }
        
        if let textures = SKSpriteNode.gifWithData(imageData){
            let action = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1))
            self.runAction(action)
        }
    }
    
    
    public class func gifWithData(data: NSData) -> [SKTexture]? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return SKSpriteNode.animatedImageWithSource(source)
    }
    
    
    class func animatedImageWithSource(source: CGImageSource) -> [SKTexture]? {
        let count = CGImageSourceGetCount(source)
        var delays = [Int]()
        var textures = [SKTexture]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(CGImage: image)
                textures.append(texture)
            }
            
            // At it's delay in cs
            let delaySeconds = SKSpriteNode.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        
        // may use later
        let timePerTexture = Double(duration) / 1000.0 / Double(count)
        
        return textures
    }

    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = SKSpriteNode.gcdForPair(val, gcd)
        }
        
        return gcd
    }

    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionaryRef = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                unsafeAddressOf(kCGImagePropertyGIFDictionary)),
            CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
            AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    
    
}