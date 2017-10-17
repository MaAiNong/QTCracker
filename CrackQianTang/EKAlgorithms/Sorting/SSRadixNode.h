//
//  RadixNode.h
//  Radix Sort
//
//  Created by Stevenson on 27/02/2014.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SSRadixNode : NSObject

@property (nonatomic) int data;
@property (nonatomic) SSRadixNode *next;

@end
