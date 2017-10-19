//
// QTMapSingleton.h
// CrackQianTang
//
// Created byX-MAN on 2017/10/19.
//Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTGameMap.h"
@interface QTMapSingleton : NSObject
+(id)sharedSingleton;
-(void)addMap:(QTGameMap*)map;
-(BOOL)isMapExist:(QTGameMap*)map;
-(void)clearAll;
@end
