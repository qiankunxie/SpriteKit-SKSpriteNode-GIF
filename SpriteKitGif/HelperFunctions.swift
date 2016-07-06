//
//  HelperFunctions.swift
//  SpriteKitGif
//
//  Created by 谢乾坤 on 7/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
import CoreGraphics

public func * (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}
