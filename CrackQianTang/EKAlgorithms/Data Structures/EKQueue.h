//
//  EKQueue.h
//  EKAlgorithms
//
//  Created by Evgeny Karkan on 20.10.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface EKQueue : NSObject

- (void)insertObject:(id)object;
- (id)removeFirstObject;
- (id)peek;
- (BOOL)isEmpty;
- (void)clear;
- (NSArray *)allObjectsFromQueue;
- (NSArray *)quickAllObjects;

@end
