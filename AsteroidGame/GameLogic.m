//
//  GameLogic.m
//  AsteroidGame
//
//  Created by Jason Fry on 05/11/2014.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic {
    BOOL FirstPass;
}

+(id)scene
{
    return [[self alloc] initWithContentOfFile:@"published/MainScene.lhplist"];
}

-(id)initWithContentOfFile:(NSString *)levelPlistFile{
    
    if(self = [super initWithContentOfFile:levelPlistFile])
    {
        /*INIT YOUR CONTENT HERE*/
        
        FirstPass = YES;
        
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
    if (FirstPass)
    {
        rotation = 0.0;
        FirstPass = NO;
    }
    else
        rotation = node.zRotation;
    
    rotation = rotation + 0.785398163/*45deg*/;
    //rotation = rotation + 45.0;
    node.zRotation = rotation;
    
    NSLog(@"Rotating %@  %f degrees",node.name, rotation);
    
}

-(void)rotateRight
{
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
  
    CGFloat rotation = 0.0;
    if (FirstPass)
    {
        rotation = 0.0;
            FirstPass = NO;
    }
    else
        rotation = node.zRotation;
    

    rotation = rotation - 0.785398163/*45deg*/;
    //rotation = rotation - 45.0;
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
    
    int f = 2;
    CGFloat fx = 0;
    CGFloat fy = 0;

    fy = f * cos(heading);
    fx = f * sin(heading);
    
    NSLog(@"Rotation: %f  fx : %f  fy: %f",fx,fy);
    

    
    [node.physicsBody applyImpulse: CGVectorMake(fx,fy)];

    NSLog(@"%@ velocity x:%f y:%f angular velocity: %f",node.name, node.physicsBody.velocity.dx, node.physicsBody.velocity.dy, node.physicsBody.angularVelocity);

}

-(void)handleSpaceship:(SKNode*)spaceship collisionWithNode:(SKNode*)node
{
    if([node conformsToProtocol:@protocol(LHNodeProtocol)])
    {
        LHNode* n = (LHNode*)node;
        
        if([[n tags] containsObject:@"BANANA"])
        {
            [n removeFromParent];
        }
    }
}
/*

#if LH_USE_BOX2D

-(BOOL)disableCandyCollisionWithNode:(SKNode*)node
{
    if([node conformsToProtocol:@protocol(LHNodeProtocol)])
    {
        LHNode* n = (LHNode*)node;
        
        if([[n tags] containsObject:@"BANANA"])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)shouldDisableContactBetweenNodeA:(SKNode *)a andNodeB:(SKNode *)b
{
    if([[a name] isEqualToString:@"candy"])
    {
        return [self disableCandyCollisionWithNode:b];
    }
    else
    {
        return [self disableCandyCollisionWithNode:a];
    }
    
    return NO;
}

-(void)didBeginContactBetweenNodeA:(SKNode*)a
                          andNodeB:(SKNode*)b
                        atLocation:(CGPoint)scenePt
                       withImpulse:(float)impulse
{
    if([[a name] isEqualToString:@"Spaceship"])
    {
        [self handleSpaceship:a collisionWithNode:b];
    }
    else
    {
        [self handleSpaceship:b collisionWithNode:a];
    }
    
    NSLog(@"DID BEGIN CONTACT %@ %@ scenePt %@ impulse %f", [a name], [b name], LHStringFromPoint(scenePt), impulse);
}


#else //spritekit

//when using spritekit we have the following 2 methods that needs to be overwriten
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    if([[[[contact bodyA] node] name] isEqualToString:@"Spaceship"])
    {
        [self handleSpaceship:[[contact bodyA] node] collisionWithNode:[[contact bodyB] node] ];
    }
    else
    {
        [self handleSpaceship:[[contact bodyB] node] collisionWithNode:[[contact bodyA] node] ];
    }
}

#endif
*/

#if TARGET_OS_IPHONE
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self handleBodiesAtLocation:location];
    
    //dont forget to call super
    [super touchesBegan:touches withEvent:event];
}

#else

-(void)mouseDown:(NSEvent *)theEvent{
    
    CGPoint location = [theEvent locationInNode:self];
    
    [self handleBodiesAtLocation:location];
    
    [super mouseDown:theEvent];
}

#endif

-(void)handleBodiesAtLocation:(CGPoint)location
{
    NSLog(@"................................................");
    //    {//position test
    //        SKNode* node = [self childNodeWithName:@"candy"];
    //        NSLog(@"SET SPRITE %@ POSITION TO %f %f", [node name], location.x, location.y);
    //        [node setPosition:location];
    //    }
    //
    //    {//rotation test
    //        SKNode* node = [self childNodeWithName:@"statue"];
    //
    //        float zRot = [node zRotation] -  0.785398163/*45deg*/;
    //
    //        NSLog(@"SET SPRITE %@ ROTATION TO %f", [node name], zRot);
    //        [node setZRotation:zRot];
    //    }
    
    //[self rotateLeft];
    [self rotateRight];
    [self thruster];
    
}


@end
