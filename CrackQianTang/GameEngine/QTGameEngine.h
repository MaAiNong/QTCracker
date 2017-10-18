//
//  QTGameEngine.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTGameMap.h"
#import "EKDeque.h"
@class QTGameEngine;
@protocol QTGameEngineDelegate<NSObject>
-(void)mapEngine:(QTGameEngine*)engine crackSuccess:(EKDeque*)resultQueue;
-(void)mapEngine:(QTGameEngine*)engine crackFailed:(EKDeque*)resultQueue;
@end

@interface QTGameEngine : NSObject

@property(nonatomic,weak)id<QTGameEngineDelegate>delegate;

-(void)start;
-(QTGameMap*)gameMap;
-(QTGameMap*)crack;
@end
