//
//  EKDeque.h
//  EKAlgorithms
//
//  Created by Evgeny Karkan on 20.10.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface EKDeque : NSObject

- (void)insertObjectToBack:(id)object;
- (void)insertObjectToFront:(id)object;

- (id)removeFirstObject;
- (id)removeLastObject;

- (id)peekFirstObject;
- (id)peekLastObject;

- (BOOL)isEmpty;
- (void)clear;
- (NSArray *)allObjectsFromDeque;
- (NSArray *)quickAllObjects;

@end
