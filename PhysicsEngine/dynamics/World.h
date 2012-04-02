//
//  World.h
//  PS4
//
//  Created by Ryan Dao on 2/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#import "RectangleBody.h"
#import "CollisionRectangle.h"

@interface World : NSObject
  // OVERVIEW: This class manages all physics entities and dynamic simulation
@property (strong, nonatomic) Vector2D *gravity;         // The world gravity vector
@property (strong, nonatomic) NSMutableArray *bodyList;  // The list of all the physical bodies in this world
@property (strong, nonatomic) CollisionRectangle *collisionSolver;

- (id)initWithGravity:(Vector2D *)gravity;
  // EFFECTS: Initialize the world with a pre-defined gravity vector

- (RectangleBody *)createDynamicBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation 
                                                        mass:(CGFloat)mass; 
  // EFFECTS: Create a dynamic body

- (RectangleBody *)createStaticBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation;
  // EFFECTS: Create a static body. 
  // 	        A static body is a body that cannot be moved, e.g. the ground of the world

- (void)step:(CGFloat)timeStep; 
  // EFFECTS: Advance the world to take a time step.
  //          In one time step, this function performs collision detection and 
  //	        resolve the positions of all physical bodies.

@end
