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
        
        //[self rotateLeft];
        
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
    rotation = node.zRotation;
    
    CGFloat heading = 45.0 - rotation;
    
    int f = 1;
    CGFloat fx = 0;
    CGFloat fy = 0;

    fy = f * cos(heading);
    fx = f * sin(heading);
    
    NSLog(@"Rotation: %f  fx : %f  fy: %f",fx,fy);
    

    
    [node.physicsBody applyImpulse: CGVectorMake(fx,fy)];

    NSLog(@"%@ velocity x:%f y:%f angular velocity: %f",node.name, node.physicsBody.velocity.dx, node.physicsBody.velocity.dy, node.physicsBody.angularVelocity);

}


@end
