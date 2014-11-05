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
        
        //[self rotateRight];
        
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

-(void)rotateRight
{
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
    
    CGFloat rotation = 0.0;
    rotation = rotation - 45.0;
    node.zRotation = rotation;
    
    NSLog(@"Rotating %@  %f degrees",node.name, rotation);
    
}

-(void)thruster
{
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
    
    node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    node.physicsBody.angularVelocity = 0.0;
    
    CGFloat rotation = 0.0;
    rotation =  node.zRotation;
    
    int x = 0;
    int y = 0;

    
    if (rotation == 0)
    {
        x = 0;
        y = 0;
    }
    else if (rotation == 45)
    {
        x = 10;
        y = 10;
    }
    else
        NSLog(@"Failed on heading");
    
    [node.physicsBody applyImpulse: CGVectorMake(x,y)];

    NSLog(@"%@ velocity x:%f y:%f angular velocity: %f",node.name, node.physicsBody.velocity.dx, node.physicsBody.velocity.dy, node.physicsBody.angularVelocity);

}


@end
