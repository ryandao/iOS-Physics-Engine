//
//  RectangleShape.m
//  PS4
//
//  Created by Ryan Dao on 2/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "RectangleBody.h"
#import "Constants.h"

@interface RectangleBody ()  

// Redeclare readonly properties as read-write
@property (nonatomic, readwrite) CGFloat mass;
@property (nonatomic, readwrite) CGSize size;

@end

@implementation RectangleBody 
@synthesize origin = origin_;
@synthesize center = center_;
@synthesize size = size_;
@synthesize rotation = rotation_;
@synthesize rotationMatrix = rotationMatrix_;
@synthesize edges = edges_;
@synthesize corners = corners_;
@synthesize mass = mass_;
@synthesize invMass = invMass_;
@synthesize I = I_;
@synthesize invI = invI_;
@synthesize linearVelocity = linearVelocity_;
@synthesize angularVelocity = angularVelocity_;
@synthesize force = force_;
@synthesize torque = torque_;
@synthesize restitution = restitution_;
@synthesize friction = friction_;
@synthesize isStatic = isStatic_;

- (void)checkRep {
  // EFFECTS: Ensure that this body conforms to a set of specifications
  //          The specifications include:
  //	          size != ZeroSize
  //            mass != 0
  //            if(isStatic) -> linearVelocity = 0 && angularVelocity = 0

  if (CGSizeEqualToSize(size_, CGSizeZero)) {
    [NSException raise:@"RectangleBody exception" format:@"Size cannot be zero"];
  }
  if (mass_ - 0 < TOLERANCE) {
    [NSException raise:@"RectangleBody exception" format:@"Mass cannot be zero"];
  }
  if (isStatic_) {
    linearVelocity_	= [Vector2D vectorWith:0 y:0];
    angularVelocity_ = 0;
  }
}

- (id)initWithCenter:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation mass:(CGFloat)mass 
         restitution:(CGFloat)restitution friction:(CGFloat)friction isStatic:(BOOL)isStatic { 
  // EFFECTS: Return a fully initialized RectangleBody with all properties
  if (self = [super init]) {
    self.center = center;
    self.size = size;
    self.rotation = rotation;
    self.restitution = restitution;
    self.friction = friction;
    self.isStatic = isStatic;
    self.mass = mass;
    // At initialization, velocity of the body should be zero
    self.linearVelocity = [Vector2D vectorWith:0 y:0];  
    self.angularVelocity = 0;
  }
  [self checkRep];
  return self;
}

- (id)initDynamicBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation 
                                         mass:(CGFloat)mass {
  // EFFECTS: Return a fully initialized dynamic RectangleBody with center, size, rotation angle and mass
  
  if (self = [self initWithCenter:center size:size rotation:rotation 
                             mass:mass restitution:1 friction:0 isStatic:NO]) {
    return self;  
  };
  assert(0);  // We should never reach here...
}

- (id)initStaticBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation {
  // EFFECTS: Return a fully initialized static RectangleBody
  
  if (self = [self initWithCenter:center size:size rotation:rotation mass:INFINITY 
                      restitution:1 friction:0 isStatic:YES]) {
    return self;
  }
  assert(0); // We should never reach here...
}

- (CGFloat) I {
  return (pow(size_.width, 2) + pow(size_.height, 2)) * mass_ / 12;
}

- (CGFloat)invI {
  if (isStatic_) {
    return 0;
    //return 1 / self.I;
  } else {
    return 1 / self.I;
  }
}

- (CGFloat)invMass {
  if (isStatic_) {
    return 0;
    //return 1 / mass_;
  } else {
    return 1 / mass_;
  }
}

- (void)setLinearVelocity:(Vector2D *)linearVelocity {
  // EFFECTS: set the linear velocity for the body
  
  linearVelocity_ = linearVelocity;
  [self checkRep];
}

- (void)setAngularVelocity:(CGFloat)angularVelocity {
  // EFFECTS: Set the angular velocity for this body
  
  angularVelocity_ = angularVelocity;
  [self checkRep];
}

- (NSArray *)corners {
  // EFFECTS: Return an arrray of the rectangle's corners in the body's coordinate system
    
  Vector2D *corner1 = [Vector2D vectorWith:size_.width/2 y:size_.height/2];
  Vector2D *corner2 = [Vector2D vectorWith:size_.width/2 y:-size_.height/2];
  Vector2D *corner3 = [Vector2D vectorWith:-size_.width/2 y:-size_.height/2];
  Vector2D *corner4 = [Vector2D vectorWith:-size_.width/2 y:size_.height/2];  
  return [NSArray arrayWithObjects:corner1, corner2, corner3, corner4, nil];
}

- (NSArray *)edges {
  // EFFECTS: Return an array of the edge vectors in the body's coordinate system

  Vector2D *corner1 = [self.corners objectAtIndex:TOP_RIGHT_CORNER];
  Vector2D *corner2 = [self.corners objectAtIndex:BOTTOM_RIGHT_CORNER];
  Vector2D *corner3 = [self.corners objectAtIndex:BOTTOM_LEFT_CORNER];
  Vector2D *corner4 = [self.corners objectAtIndex:TOP_LEFT_CORNER];
  
  Vector2D *edge1= [corner2 subtract:corner1];
  Vector2D *edge2= [corner3 subtract:corner2];
  Vector2D *edge3= [corner4 subtract:corner3];
  Vector2D *edge4= [corner1 subtract:corner4];
  return [NSArray arrayWithObjects:edge1, edge2, edge3, edge4, nil];
}

- (Matrix2D *)rotationMatrix {
  // EFFECTS: Return the rotation matrix corresponding to the rotation angle
  
  return [Matrix2D initRotationMatrix:rotation_];
}

- (double)distanceFromWorldToEdge:(int)edgeIndex {
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0
  // EFFECTS: Return the distance from the world origin to a given edge of this rectangle body
  
  assert(edgeIndex < 4 && edgeIndex >= 0);  
  Vector2D *normal = [self normalVectorOfEdge:edgeIndex];
  Vector2D *topright = [self.corners objectAtIndex:TOP_RIGHT_CORNER];
  switch (edgeIndex) {
    case RIGHT_MOST_EDGE:
    case LEFT_MOST_EDGE:
      return [center_ dot:normal] + topright.x;
      break;
    case BOTTOM_EDGE:
    case TOP_EDGE:
      return [center_ dot:normal] + topright.y;
      break;
    default:
      assert(0);
      break;
  }
}

- (Vector2D *)normalVectorOfEdge:(int)edgeIndex {
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0
  // EFFECTS: Return the unit normal vector of a given edge of this rectangle body
  
  assert(edgeIndex < 4 && edgeIndex >= 0);  
  switch (edgeIndex) {
    case RIGHT_MOST_EDGE:
      return self.rotationMatrix.col1;
      break;
    case LEFT_MOST_EDGE:
      return [self.rotationMatrix.col1 negate];
      break;
    case TOP_EDGE:
      return self.rotationMatrix.col2;
      break;
    case BOTTOM_EDGE:
      return [self.rotationMatrix.col2 negate];
      break;
    default:
      assert(0);
      break;
  }
}

- (int)positiveAdjacentEdgeOf:(int)edgeIndex {
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return the index of the positive edge adjacent to a given edge
  
  assert(edgeIndex < 4 && edgeIndex >= 0);
  switch (edgeIndex) {
    case RIGHT_MOST_EDGE:
    case LEFT_MOST_EDGE:
      return TOP_EDGE;
      break;
    case BOTTOM_EDGE:
    case TOP_EDGE:
      return LEFT_MOST_EDGE;
      break;
    default:
      assert(0);
      break;
  }
}

- (int)negativeAdjacentEdgeOf:(int)edgeIndex {
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return the index of the negative edge adjacent to a given edge
  
  assert(edgeIndex < 4 && edgeIndex >= 0);
  switch (edgeIndex) {
    case RIGHT_MOST_EDGE:
    case LEFT_MOST_EDGE:
      return BOTTOM_EDGE;
      break;
    case BOTTOM_EDGE:
    case TOP_EDGE:
      return RIGHT_MOST_EDGE;
      break;
    default:
      assert(0);
      break;
  }
}

- (NSArray *)endPointsOfEdge:(int)edgeIndex {
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return an array of the two end points of a given edge

  assert(edgeIndex < 4 && edgeIndex >= 0);
  switch (edgeIndex) {
    case RIGHT_MOST_EDGE:
      return [NSArray arrayWithObjects:[self.corners objectAtIndex:BOTTOM_RIGHT_CORNER], 
                                       [self.corners objectAtIndex:TOP_RIGHT_CORNER], nil];
      break;
    case BOTTOM_EDGE:
      return [NSArray arrayWithObjects:[self.corners objectAtIndex:BOTTOM_LEFT_CORNER], 
                                       [self.corners objectAtIndex:BOTTOM_RIGHT_CORNER], nil];
      break;
    case LEFT_MOST_EDGE:
      return [NSArray arrayWithObjects:[self.corners objectAtIndex:TOP_LEFT_CORNER], 
                                       [self.corners objectAtIndex:BOTTOM_LEFT_CORNER], nil];
      break;
    case TOP_EDGE:
      return [NSArray arrayWithObjects:[self.corners objectAtIndex:TOP_RIGHT_CORNER], 
                                       [self.corners objectAtIndex:TOP_LEFT_CORNER], nil];
      break;
    default:
      assert(0);
      break;
  }  
}

- (BOOL)containsPoint:(CGPoint)point {
  // EFFECTS: Test if this body can contain a given point
  
  return YES;
}

- (CGRect)boundingBox {
  // EFFECTS: Returns the bounding box of this body.
  
  return CGRectZero;
}

- (void)applyForce:(Vector2D *)force atPoint:(CGPoint)p {
  // EFFECTS: Apply a force to this body at a world point. 
  //	        If the force is not applied at the center of mass, the result
  //		      will generate a torque and affect the angular velocity.
  
  [self applyForceToCenter:force];
    
  // Calculate resulting torque
}

- (void)applyForceToCenter:(Vector2D *)force {
  // EFFECTS: Apply a force to the center of mass.
  
  if (force_ == nil) {
    force_ = force;
  } else {
    [force_ add:force];
  }
}

- (void)applyTorque:(CGFloat)torque {
  // EFFECTS: Apply a torque to this body
  
  torque_ += torque;
}

- (Vector2D *)transformVectorCoordinate:(Vector2D *)vector {
  // EFFECTS: Transform a vector in the world's coordinate system to the body's coordinate system
  
  return [[self.rotationMatrix transpose] multiplyVector:vector];
}

- (Vector2D *)invTransformVectorCoordinate:(Vector2D *)vector {
  // EFFECTS: Transform a vector in this body coordinate system to the world coordinate system
  
  return [self.rotationMatrix multiplyVector:vector];
}

- (Vector2D *)transformPointCoordinate:(Vector2D *)worldPoint {
  // EEFECTS: Transform a point in the world coordinate system to the body coordinate system
  
  Vector2D *translatedPoint = [worldPoint subtract:center_];
  return [[self.rotationMatrix transpose] multiplyVector:translatedPoint];
}

- (Vector2D *)invTransformPointCoordinate:(Vector2D *)point {
  // EEFECTS: Transform a point in the body coordinate system to the world coordinate system 
  
  Vector2D *translatedPoint = [point add:center_];
  return [self.rotationMatrix multiplyVector:translatedPoint];  
}

@end
