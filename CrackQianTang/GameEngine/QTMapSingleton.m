//
// QTMapSingleton.m
// CrackQianTang
//
// Created byX-MAN on 2017/10/19.
//Copyright © 2017年 maainong. All rights reserved.
//

#include "QTMapSingleton.h"

#import "EKQueue.h"

@interface QTMapSingleton ()
@property(nonatomic,strong)EKQueue* usedMap;
@end


@implementation QTMapSingleton


+(id)sharedSingleton
{
    static dispatch_once_t QTMapSingletonOnce;
    static QTMapSingleton* sharedQTMapSingleton;
    dispatch_once(&QTMapSingletonOnce, ^{
        
        sharedQTMapSingleton=[[QTMapSingleton alloc] init];
        sharedQTMapSingleton.usedMap = [[EKQueue alloc] init];
        
    });
    
    return sharedQTMapSingleton;
}

-(void)addMap:(QTGameMap*)map
{
    [self.usedMap insertObject:map];
}
-(BOOL)isMapExist:(QTGameMap*)map
{
    for (QTGameMap* usedMap in [self.usedMap quickAllObjects]) {
        if ([usedMap isEqualToMap:map]) {
            return YES;
        }
    }
    return NO;
}
-(void)clearAll
{
    [self.usedMap clear];
}

@end
