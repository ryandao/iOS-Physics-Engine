//
//  Collision.m
//  PS4
//
//  Created by Ryan Dao on 2/6/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "CollisionRectangle.h"
#import "Matrix2D.h"
#import "Vector2D.h"
#import "Common.h"
#import "Constants.h"

@implementation CollisionRectangle
@synthesize collisionDataList = collisionDataList_;

- (id)init {
  if (self = [super init]) {
    self.collisionDataList = [[NSMutableArray alloc] init];
  }
  
  return self;
}

+ (Matrix2D *)transformationMatrixFrom:(RectangleBody *)rectA to:(RectangleBody *)rectB {
  // EFFEECTS: Return the transformation matrix from rect1's coordinate system
  //           to rect2's coordinate system
  
  return [[rectA.rotationMatrix transpose] multiply:rectB.rotationMatrix]; 
}

- (BOOL)testCollision:(RectangleCollisionData *)data {
  // REQUIRES: data.referenceRect != nil && data.incidentRect != nil
  // EFFECTS: Returns YES if two bodies of a given collision are colliding. 
  //          If the two bodies are colliding, calculate and add 
  //          the collision data to the collision data object.
  
  if (data.referenceBody == nil && data.incidentBody == nil) {
    return NO;
  }
  if (data.referenceBody.isStatic && data.incidentBody.isStatic) {
    // No need to perform collision detection on static objects
    return NO;
  }
  
  RectangleBody *rectA = data.referenceBody;
  RectangleBody *rectB = data.incidentBody;
  Vector2D *hA = [rectA.corners objectAtIndex:0];  // Vector from center to top-right point of A
  Vector2D *hB = [rectB.corners objectAtIndex:0];  // Vector from center to top-right point of B
  Vector2D *dA = [rectA transformPointCoordinate:rectB.center];  // Position of B's center in A's coordinate sysmtem
  Vector2D *dB = [rectB transformPointCoordinate:rectA.center];  // Position of A's center in B's coordinate sysmtem
  
  // Start collision detection
  Matrix2D *C = [CollisionRectangle transformationMatrixFrom:rectB to:rectA];                                                     
  Vector2D *fA = [[dA abs] subtract:[hA add:[C multiplyVector:hB]]];
  Vector2D *fB = [[dB abs] subtract:[hB add:[[C transpose] multiplyVector:hA]]];
  
  // Add the components of fA, fB to an array for iteration
  NSArray *intersections = [NSArray arrayWithObjects:[NSNumber numberWithDouble:fA.x], [NSNumber numberWithDouble:fA.y],
                             [NSNumber numberWithDouble:fB.x], [NSNumber numberWithDouble:fB.y], nil];
  double minIntersection = -INFINITY;  // The intersection component with the smallest value
  int minIntersectionIndex;            // Index of the min intersection component
  for (int i = 0; i < [intersections count]; i++) {
    // Preliminary check and find min value
    double component = [[intersections objectAtIndex:i] doubleValue];
    if (component - 0 > TOLERANCE) {
      return NO;
    } else {
      if (component - minIntersection > TOLERANCE) {
        minIntersection = component;
        minIntersectionIndex = i;
      }
    }    
  }
  
  // Add more data to the collision data object
  data.intersection = minIntersection;
  data.intersectionIndex = minIntersectionIndex;
  return YES;
}

- (void)findReferenceEdge:(RectangleCollisionData *)data {
  // EFFECTS: Find the reference body and the reference edge of a particular collision
  
  RectangleBody *rectA = data.referenceBody;  
  RectangleBody *rectB = data.incidentBody;  
  Vector2D *dA = [rectA transformPointCoordinate:rectB.center];  // Position of B's center in A's coordinate sysmtem
  Vector2D *dB = [rectB transformPointCoordinate:rectA.center];  // Position of A's center in B's coordinate sysmtem
  
  switch (data.intersectionIndex) {
    case 0:  // minIntersection = fA.x
      data.referenceBody = rectA;
      data.incidentBody = rectB;
      if (dA.x - 0 > TOLERANCE) {
        data.referenceEdge = RIGHT_MOST_EDGE;
      } else {
        data.referenceEdge = LEFT_MOST_EDGE;
      }
      break;
      
    case 1:  // minComponent = fA.y
      data.referenceBody = rectA;
      data.incidentBody = rectB;
      if (dA.y - 0 > TOLERANCE) {
        data.referenceEdge = TOP_EDGE;
      } else {
        data.referenceEdge = BOTTOM_EDGE;
      }
      break;
      
    case 2:  // minComponent = fB.x
      data.referenceBody = rectB;
      data.incidentBody = rectA;      
      if (dB.x - 0 > TOLERANCE) {
        data.referenceEdge = LEFT_MOST_EDGE;
      } else {
        data.referenceEdge = RIGHT_MOST_EDGE;
      }
      break;
      
    case 3:  // minComponent = fB.y
      data.referenceBody = rectB;
      data.incidentBody = rectA;
      if (dB.y - 0 > TOLERANCE) {
        data.referenceEdge = BOTTOM_EDGE;
      } else {
        data.referenceEdge = TOP_EDGE;
      } 
      break;
      
    default:
      break;
  }
}

- (void)findIncidentEdge:(RectangleCollisionData *)data {
  // REQUIRES: This method should be called after the reference body and the reference edge are identified.
  // EFFECTS: Find the index of the incident edge of a given collision.
  
  Vector2D *nf = [data.referenceBody normalVectorOfEdge:data.referenceEdge];    
  Vector2D *ni = [[data.incidentBody transformVectorCoordinate:nf] negate];  // Incident unit directional vector
                                                                             // in the incident body's coordinate system
  if ([ni abs].x > [ni abs].y && ni.x > 0) {
    data.incidentEdge = RIGHT_MOST_EDGE;
  } else if ([ni abs].x > [ni abs].y && ni.x <= 0) {
    data.incidentEdge = LEFT_MOST_EDGE;
  } else if ([ni abs].x <= [ni abs].y && ni.y > 0) {
    data.incidentEdge = TOP_EDGE;
  } else if ([ni abs].x <= [ni abs].y && ni.y <=0) {
    data.incidentEdge = BOTTOM_EDGE;
  } else {
    assert(0);  // We should never reach here...
  }
}

- (BOOL)collideRectangle:(RectangleBody *)rectA with:(RectangleBody *)rectB {
  // EFFECTS: Check if two rectangle bodies are colliding and find contact points
  
  RectangleCollisionData *data = [[RectangleCollisionData alloc] initWith:rectA body2:rectB];
  // Preliminary collision test 
  if (! [self testCollision:data]) {
    return NO;
  }
  
  // If colliding, find the reference edge
  [self findReferenceEdge:data];
  
  // Choose incident edge 
  [self findIncidentEdge:data];
  Vector2D *v1 = [[data.incidentBody endPointsOfEdge:data.incidentEdge] objectAtIndex:0];  
  v1 = [data.incidentBody invTransformPointCoordinate:v1];
  Vector2D *v2 = [[data.incidentBody endPointsOfEdge:data.incidentEdge] objectAtIndex:1];
  v2 = [data.incidentBody invTransformPointCoordinate:v2];
  
  // Clipping
  int positiveAdjacentEdge = [data.referenceBody positiveAdjacentEdgeOf:data.referenceEdge]; 
  int negativeAdjacentEdge = [data.referenceBody negativeAdjacentEdgeOf:data.referenceEdge];   
  Vector2D *ns = [data.referenceBody normalVectorOfEdge:positiveAdjacentEdge];  
  double Dpos = [data.referenceBody distanceFromWorldToEdge:positiveAdjacentEdge];
  double Dneg = [data.referenceBody distanceFromWorldToEdge:negativeAdjacentEdge];   
  NSArray *clipResults = [Common clipVector:v1 secondEnd:v2 clippingDirection:[ns negate] 
                            distanceWorldToClippingLine:Dneg];  // First clip
  if (! clipResults) {
    return NO;
  }
  v1 = [clipResults objectAtIndex:0];
  v2 = [clipResults objectAtIndex:1];
  clipResults = [Common clipVector:v1 secondEnd:v2 clippingDirection:ns
                    distanceWorldToClippingLine:Dpos];  // Second clip
  if (! clipResults) {
    return NO;
  }
  v1 = [clipResults objectAtIndex:0];
  v2 = [clipResults objectAtIndex:1];
  
  // Calculate and add contact points to data
  Vector2D *nf = [data.referenceBody normalVectorOfEdge:data.referenceEdge];  
  double Df = [data.referenceBody distanceFromWorldToEdge:data.referenceEdge];
  double separation1 = [nf dot:v1] - Df;
  double separation2 = [nf dot:v2] - Df;
  [data.contactSeparations addObject:[NSNumber numberWithDouble:separation1]];
  [data.contactSeparations addObject:[NSNumber numberWithDouble:separation2]];
  [data.contactPoints addObject:[Common projectPointOnLine:v1 withNormal:nf distanceWorldToLine:Df]];
  [data.contactPoints addObject:[Common projectPointOnLine:v2 withNormal:nf distanceWorldToLine:Df]]; 
  
  // Add the collision data to the list of collisions
  [collisionDataList_ addObject:data];
  
  return YES;
}

- (void)applyImpulses {
  // EFFECTS: Apply implulses at all contact points
  
  for (RectangleCollisionData *data in collisionDataList_) {
    RectangleBody *rectA = data.referenceBody;
    RectangleBody *rectB = data.incidentBody;
    for (int i = 0; i < [data.contactPoints count]; i++) {
      Vector2D *contactPoint = [data.contactPoints objectAtIndex:i];
      Vector2D *rA = [contactPoint subtract:rectA.center];  // position of the contact point from A's center
      Vector2D *rB = [contactPoint subtract:rectB.center];  // position of the contact point from B's center
      Vector2D *uA = [rectA.linearVelocity	subtract:[rA crossZ:rectA.angularVelocity]];  // velocity of A 
                                                                                          // at the contact point
      Vector2D *uB = [rectB.linearVelocity	subtract:[rB crossZ:rectB.angularVelocity]];  // velocity of B 
                                                                                          // at the contact point
      Vector2D *u = [uB subtract:uA];  // relative velocity at the contact point
      Vector2D *n = [rectA normalVectorOfEdge:data.referenceEdge];  // unit normal vector at the contact point
      Vector2D *t = [n crossZ:1];  						                      // unit tangent vector at the contact point
      double un = [u dot:n];  // normal component of the relative velocity
      double ut = [u dot:t];  // tangent component of the relative velocity
        
      // Compute the normal and tangential mass at the contact point
      double invTotalMass = rectA.invMass + rectB.invMass;
      double RAn = ([rA dot:rA] - pow([rA dot:n], 2)) * rectA.invI;
      double RAt = ([rA dot:rA] - pow([rA dot:t], 2)) * rectA.invI;
      double RBn = ([rB dot:rB] - pow([rB dot:n], 2)) * rectB.invI;
      double RBt = ([rB dot:rB] - pow([rB dot:t], 2)) * rectB.invI;
      double Rn = RAn + RBn;
      double Rt = RAt + RBt;
      double mn = 1 / (invTotalMass + Rn);  // normal mass
      double mt = 1 / (invTotalMass + Rt);  // tangential mass
        
      // Compute the normal and tangential impulse
      int e = data.restitution;
      Vector2D *Pn;  // normal impulse
      if (0 < mn * (1 + e) * un) {
        Pn = [Vector2D vectorWith:0 y:0];     
      } else {
        Pn = [n multiply:mn * (1 + e) * un];         
      }
      double dPt = mt * ut;             // change of tangential impulse (TODO: add friction)
      Vector2D *Pt = [t multiply:dPt];  // tangential impulse
        
      // Calculate new velocities
      rectA.linearVelocity = [rectA.linearVelocity add:[[Pn add:Pt] multiply:rectA.invMass]];
      rectB.linearVelocity = [rectB.linearVelocity subtract:[[Pn add:Pt] multiply:rectB.invMass]]; 
      rectA.angularVelocity = rectA.angularVelocity + [[rA multiply:rectA.invI] cross:[Pn add:Pt]]; 
      rectB.angularVelocity = rectB.angularVelocity - [[rB multiply:rectA.invI] cross:[Pn add:Pt]]; 
    }
  }
}

- (void)clear {
  // EFFECTS: Clear all collision data
  
  [collisionDataList_ removeAllObjects];
}

@end
