//
//  World.m
//  PS4
//
//  Created by Ryan Dao on 2/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "World.h"
#import "Constants.h"

@implementation World
@synthesize gravity = gravity_;
@synthesize bodyList = bodyList_;
@synthesize collisionSolver = collisionSolver_;

- (id)initWithGravity:(Vector2D *)gravity {
  // EFFECTS: Initialize the world with a pre-defined gravity vector
  
  if (self = [super init]) { 
    self.gravity = gravity;
    self.bodyList = [[NSMutableArray alloc] init];
    self.collisionSolver = [[CollisionRectangle alloc] init];
  }
  return self;
}

- (RectangleBody *)createDynamicBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation 
                                                        mass:(CGFloat)mass {
  // EFFECTS: Create a dynamic body and add to the body list
  // TODO: Catch exception thrown by initializer
  
  RectangleBody *body = [[RectangleBody alloc] initDynamicBody:center size:size rotation:rotation 
                                                                      mass:mass];
  [bodyList_ addObject:body];
  return body;
}

- (RectangleBody *)createStaticBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation {
  // EFFECTS: Create a static body. 
  // 	        A static body is a body that cannot be moved, e.g. the ground of the world
  // TODO: Catch exception thrown by initializer
  
  RectangleBody *body = [[RectangleBody alloc] initStaticBody:center size:size rotation:rotation];
  [bodyList_ addObject:body];
  return body;
}

- (void)applyForcesAndTorques:(CGFloat)timeStep {
  // EFFECTS: Calculate the velocities of all physical bodies after applying forces and torques
  
  for (RectangleBody *body in bodyList_) {
    body.linearVelocity = [body.linearVelocity add:
                            [[gravity_ add:[body.force multiply:(body.invMass)]] multiply:timeStep]];
    body.angularVelocity = body.angularVelocity + timeStep * (body.torque / body.I);
  }
}

- (void)solveCollision:(CGFloat)timeStep {
  // EFFECTS: Perform collision detection and resolve contacts for all bodies
  
  for (int i = 0; i < [bodyList_ count]; i++) {
    // TODO: Apply broad-phrase strategy to narrow down the objects to achieve a better performance
    for (int j = i + 1; j < [bodyList_ count]; j++) {
      RectangleBody *bodyA = [bodyList_ objectAtIndex:i];
      RectangleBody *bodyB = [bodyList_ objectAtIndex:j];
      [collisionSolver_ collideRectangle:bodyA with:bodyB];
    }
  }
  
  for (int i = 0; i < IMPULSE_ITERATION; i++) {
    [collisionSolver_ applyImpulses];
  }
}

- (void)moveBodies:(CGFloat)timeStep {
  // EFFECTS: Update the positions of all of the bodies based on velocities
  
  for (RectangleBody *body in bodyList_) {
    body.center = [body.center add:[body.linearVelocity multiply:timeStep]];
    body.rotation = body.rotation + body.angularVelocity * timeStep;    
  }
}

- (void)step:(CGFloat)timeStep {
  // EFFECTS: Advance the world to take a time step.
  //          In one time step, this function performs collision detection and 
  //	        resolve the positions of all physical bodies.  
  
  //RectangleBody *ground = [bodyList_ objectAtIndex:0];
  [self applyForcesAndTorques:timeStep];
  [self solveCollision:timeStep];
  [self moveBodies:timeStep];

  // Clear the collisionSolver
  [collisionSolver_ clear];
}

@end
