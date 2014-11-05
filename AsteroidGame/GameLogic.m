//
//  GameLogic.m
//  AsteroidGame
//
//  Created by Jason Fry on 05/11/2014.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic

+(id)scene
{
    return [[self alloc] initWithContentOfFile:@"published/MainScene.lhplist"];
}

-(id)initWithContentOfFile:(NSString *)levelPlistFile{
    
    if(self = [super initWithContentOfFile:levelPlistFile])
    {
        /*INIT YOUR CONTENT HERE*/
        
        [self rotateLeft];
        
        [self thruster];
        
    }
    
    return self;
}

-(void)rotateLeft
{
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
    
    CGFloat rotation = 0.0;
    rotation = rotation + 45.0;
    node.zRotation = rotation;
    
    NSLog(@"Rotating %@  %f degrees",node.name, rotation);
    
}

-(void)thruster
{
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
    
    node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    node.physicsBody.angularVelocity = 0.0;
    
    [node.physicsBody applyImpulse: CGVectorMake(10,0)];

    NSLog(@"%@ velocity x:%f y:%f angular velocity: %f",node.name, node.physicsBody.velocity.dx, node.physicsBody.velocity.dy, node.physicsBody.angularVelocity);

}


@end
