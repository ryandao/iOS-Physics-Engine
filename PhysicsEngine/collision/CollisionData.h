//
//  CollisionManifold.h
//  PS4
//
//  Created by Ryan Dao on 2/11/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Body.h"
#import "RectangleBody.h"

@interface CollisionData : NSObject
  // OVERVIEW: This class stores the relevant data of a collision between two bodies

@end

@interface RectangleCollisionData : CollisionData 
  // OVERVIEW: This class stores the relevant data of a collision between two rectangle bodies
@property (strong, nonatomic) RectangleBody *referenceBody;  // The reference body
@property (strong, nonatomic) RectangleBody *incidentBody;   // The incident body
@property (nonatomic) int referenceEdge;      // Index of the reference edge
@property (nonatomic) int incidentEdge;       // Index of the incident edge
@property (nonatomic) double intersection;    // The overlapping area of the projected bodies
@property (nonatomic) int intersectionIndex;  // Index of the best overlapping line
@property (strong, nonatomic) NSMutableArray *contactPoints;      // List of all the contact points of this collision 
@property (strong, nonatomic) NSMutableArray *contactSeparations; // List of the separation distance for each contact point 
@property (nonatomic) CGFloat restitution;    // The restitution for this collision

- (id)initWith:(RectangleBody *)rect1 body2:(RectangleBody *)rect2;
  // EFFEECTS: Initialize a RectangleCollisionData object with two physical rectangle bodies

@end
