//
//  Shape.h
//  PS4
//
//  Created by Ryan Dao on 2/4/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@protocol Body <NSObject>

// The body origin point
@property (nonatomic) CGPoint origin;

// The body center of mass point in the world's coordinate system
@property (strong, nonatomic) Vector2D *center;

// The body mass
@property (readonly, nonatomic) CGFloat mass;

// The inverse value of the body mass
@property (readonly, nonatomic) CGFloat invMass;

// The body moment of inertia
@property (readonly, nonatomic) CGFloat I;

// The inverse value of the moment of inertia
@property (readonly, nonatomic) CGFloat invI;

// The body linear velocity
@property (strong, nonatomic) Vector2D *linearVelocity;

// The body angular velocity
@property (nonatomic) CGFloat angularVelocity;

// The total force acting on the body
@property (strong, nonatomic) Vector2D *force;

// The total torque acting on the body
@property (nonatomic) CGFloat torque;

// The restitution coefficient of the body
@property (nonatomic) CGFloat restitution;

// The friction coefficient of the body
@property (nonatomic) CGFloat	friction;

// A flag to indicate whether the body is static
@property (nonatomic) BOOL isStatic;

/* Methods */

- (BOOL)containsPoint:(CGPoint)point;
  // EFFECTS: Test if this body can contain a given point

- (CGRect)boundingBox;
  // EFFECTS: Returns the bounding box of this body.

- (void)applyForce:(Vector2D *)force atPoint:(CGPoint)point;
  // EFFECTS: Apply a force to this body at a world point. 
  //	        If the force is not applied at the center of mass, the result
  //		      will generate a torque and affect the angular velocity.

- (void)applyForceToCenter:(Vector2D *)force;
  // EFFECTS: Apply a force to the center of mass.

- (void)applyTorque:(CGFloat)torque;
  // EFFECTS: Apply a torque to this body

@end
