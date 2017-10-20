//
// QTMapSingleton.m
// CrackQianTang
//
// Created byX-MAN on 2017/10/19.
//Copyright © 2017年 maainong. All rights reserved.
//

#include "QTMapSingleton.h"

#import "EKQueue.h"
#import "EKDeque.h"

@interface QTMapSingleton ()
@property(nonatomic,strong)NSMutableArray* usedMap;
@end


@implementation QTMapSingleton


+(id)sharedSingleton
{
    static dispatch_once_t QTMapSingletonOnce;
    static QTMapSingleton* sharedQTMapSingleton;
    dispatch_once(&QTMapSingletonOnce, ^{
        
        sharedQTMapSingleton=[[QTMapSingleton alloc] init];
        sharedQTMapSingleton.usedMap = [[NSMutableArray alloc] init];
        
    });
    
    return sharedQTMapSingleton;
}

-(void)addMap:(QTGameMap*)map
{
    [self.usedMap insertObject:map atIndex:0];
}
-(BOOL)isMapExist:(QTGameMap*)map
{
    BOOL match = NO;
    for (QTGameMap* usd in self.usedMap) {
        if ([usd isEqualToMap:map]) {
            [usd addMatchWeight];
            match = YES;
            break;
        }
    }
    if (match) {
        [self resort];
    }
    return match;
}

-(void)resort
{
    [self.usedMap sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QTGameMap* map1 = obj1;
        QTGameMap* map2 = obj2;
        if (map1.matchWeight>map2.matchWeight) {
            return NSOrderedAscending;
        }
        else if(map1.matchWeight<map2.matchWeight)
        {
            return NSOrderedDescending;
        }
        else
            return NSOrderedSame;
    }];
}

-(void)clearAll
{
    [self.usedMap removeAllObjects];
}

@end
