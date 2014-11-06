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
    BOOL didChangeX;
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
        
        //[self thruster];
        
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
    
    //node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    //node.physicsBody.angularVelocity = 0.0;
    
    CGFloat rotation = 0.0;
    rotation = node.zRotation;
    
    CGFloat heading = 45.0 - rotation;
    
    int f = 2;
    CGFloat fx = 0;
    CGFloat fy = 0;

    fy = f * cos(heading);
    fx = f * sin(heading);
    
    NSLog(@"Heading: %f  fx : %f  fy: %f",heading,fx,fy);
    

    
    [node.physicsBody applyImpulse: CGVectorMake(fx,fy)];

    NSLog(@"%@ velocity x:%f y:%f angular velocity: %f",node.name, node.physicsBody.velocity.dx, node.physicsBody.velocity.dy, node.physicsBody.angularVelocity);

}

-(void)fire
{
    
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

- (void)messWithGravity
{
    CGPoint curGravity = [self globalGravity];
    if(didChangeX){
        [self setGlobalGravity:CGPointMake(curGravity.x, -curGravity.y)];
        didChangeX = false;
    }
    else{
        didChangeX = true;
        [self setGlobalGravity:CGPointMake(-curGravity.x, curGravity.y)];
    }
    
    NSLog(@"Gravity x:%f y:%f", curGravity.x, curGravity.y);
}

-(void)handleLabelsAtLocation:(CGPoint)location
{
    NSArray* nodes = [self nodesAtPoint:location];
    for(SKNode* node in nodes)
    {
        //if fire button touched, bring the rain
        if ([node.name isEqualToString:@"LeftBtn"]) {
            [self rotateLeft];
        }
        if ([node.name isEqualToString:@"RightBtn"]) {
            [self rotateRight];
        }
        if ([node.name isEqualToString:@"FireBtn"]) {
            [self fire];
        }
        if ([node.name isEqualToString:@"ThrusterBtn"]) {
            [self thruster];
        }
        
    }
}

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


#if TARGET_OS_IPHONE



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self handleLabelsAtLocation:location];
    
    //dont forget to call super
    [super touchesBegan:touches withEvent:event];
}

#else

-(void)mouseDown:(NSEvent *)theEvent{
    
    CGPoint location = [theEvent locationInNode:self];
    
    [self handleLabelsAtLocation:location];
    
    [super mouseDown:theEvent];
}

#endif

- (void)handleRotation:(CGPoint)location
{
    //Add movement rotating left and right by clicking on the left or right of the spaceship
    
    LHNode* node = (LHNode*)[[self gameWorldNode] childNodeWithName:@"Spaceship"];
    node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    
    if (node.position.x < location.x)
    {
        NSLog(@"Rotate Right X");
        [self rotateRight];
    }
    else if (node.position.x > location.x)
    {
        NSLog(@"Rotate Left X");
        [self rotateLeft];
    }
    else if (node.position.y < location.y)
    {
        NSLog(@"Rotate Left Y");
        [self rotateLeft];
    }
    else if (node.position.y > location.y)
    {
        NSLog(@"Rotate Right Y");
        [self rotateRight];
    }
}

-(void)handleBodiesAtLocation:(CGPoint)location
{
    NSLog(@"................................................");
    
    
    //[self rotateLeft];
    //[self rotateRight];
    //[self thruster];
    
}

@end
