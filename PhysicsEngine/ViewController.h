//
//  ViewController.h
//  PS4
//
//  Created by Ryan Dao on 2/4/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "World.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *blockViews;
@property (strong, nonatomic) NSMutableDictionary *blockMap;  // A simple table to map the block view indexes
                                                              // to the corresponding physical body indexes
@property (strong, nonatomic) World *world;
@property (strong, nonatomic) Vector2D *gravity;

@end
