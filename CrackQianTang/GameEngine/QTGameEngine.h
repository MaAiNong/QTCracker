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
#import <UIKit/UIKit.h>
@class QTGameEngine;
@protocol QTGameEngineDelegate<NSObject>
-(void)mapEngine:(QTGameEngine*)engine crackSuccess:(EKDeque*)resultQueue;
-(void)mapEngine:(QTGameEngine*)engine crackFailed:(EKDeque*)resultQueue;
-(void)mapEngine:(QTGameEngine*)engine noNeedToCrack:(NSDictionary*)message;
@end

@interface QTGameEngine : NSObject

@property(nonatomic,weak)id<QTGameEngineDelegate>delegate;
-(id)initWithImage:(UIImage*)image;
-(BOOL)start;
-(QTGameMap*)gameMap;
-(QTGameMap*)crack;
@end
