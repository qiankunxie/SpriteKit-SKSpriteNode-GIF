//
//  GameScene.swift
//  SpriteKitGif
//
//  Created by 谢乾坤 on 7/6/16.
//  Copyright (c) 2016 QiankunXie. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let nsurl = NSURL(string: "http://d38cjvupbxhsu.cloudfront.net/jackblack.gif")
        let gifnode = SKSpriteNode()
        gifnode.size = CGSize(width: 1, height: 0.3) * size
        gifnode.position = CGPoint(x: 0.5, y: 0.75) * size
        addChild(gifnode)
        gifnode.animateWithRemoteGIF(nsurl!)
        
        let localgif = SKSpriteNode()
        localgif.size = CGSize(width: 1, height: 0.3) * size
        localgif.position = CGPoint(x: 0.5, y: 0.35) * size
        addChild(localgif)
        localgif.animateWithLocalGIF(fileNamed: "shooterMcGavin")
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
