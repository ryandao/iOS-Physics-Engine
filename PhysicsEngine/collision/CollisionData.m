//
//  CollisionManifold.m
//  PS4
//
//  Created by Ryan Dao on 2/11/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "CollisionData.h"

@implementation CollisionData

@end

@implementation RectangleCollisionData
@synthesize referenceBody = referenceBody_;
@synthesize incidentBody = incidentBody_;
@synthesize referenceEdge = referenceEdge_;
@synthesize incidentEdge = incidentEdge_;
@synthesize intersection = intersection_;
@synthesize intersectionIndex = intersectionIndex_;
@synthesize contactPoints = contactPoints_;
@synthesize contactSeparations = contactSeparations_;
@synthesize restitution = restitution_;

- (CGFloat)restitution {
  if (referenceBody_ && incidentBody_) {
    return sqrtf(referenceBody_.restitution	* incidentBody_.restitution);
  }
  return 0;
}

- (id)initWith:(RectangleBody *)rect1 body2:(RectangleBody *)rect2 {
  // EFFEECTS: Initialize a RectangleCollisionData object with two physical rectangle bodies
  
  if (self = [super init]) {
    self.referenceBody = rect1;
    self.incidentBody = rect2;
    self.contactPoints = [[NSMutableArray alloc] init];
    self.contactSeparations = [[NSMutableArray alloc] init];
  }
  return self;
}

@end
