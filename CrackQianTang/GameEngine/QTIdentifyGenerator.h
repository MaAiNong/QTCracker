//
//  QTIdentifyGenerator.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IdentifierBlock)(int identifier);

@interface QTIdentifyGenerator : NSObject

+(id)sharedInstance;
-(void)reset;
-(void)handleIdentifier:(IdentifierBlock)block;

@end
