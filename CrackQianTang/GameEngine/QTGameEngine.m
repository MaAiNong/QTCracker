//
//  QTGameEngine.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameEngine.h"
#import "QTIdentifyGenerator.h"
#import "QTGameMap.h"
#import "QTGameElementFactory.h"
#import "EKStack.h"
#import "EKDeque.h"
#import "QTMapSingleton.h"
@interface QTGameEngine()
@property(nonatomic,strong)QTGameMap* gameMap;
@property(nonatomic,strong)EKDeque* mapDeque;
@property(nonatomic,strong)EKQueue* usedMap;
@end

@implementation QTGameEngine
-(void)start
{
    self.mapDeque = [[EKDeque alloc] init];
    self.usedMap = [[EKQueue alloc] init];
    
    [[QTIdentifyGenerator sharedInstance] reset];
    [[QTMapSingleton sharedSingleton] clearAll];
    
    //初始化map
    QTGameMap* map = [[QTGameMap alloc] init];
    map.delegate = self;
    //第121局
    //头部
    [map addGameElement:HEADER(1, 2)];
    //垂直
    [map addGameElement:BLOCKER_V(0, 1, 2)];
    [map addGameElement:BLOCKER_V(3, 1, 3)];
    [map addGameElement:BLOCKER_V(4, 1, 3)];
    [map addGameElement:BLOCKER_V(5, 1, 2)];
    [map addGameElement:BLOCKER_V(2, 3, 3)];
    //水平
    [map addGameElement:BLOCKER_H(0, 3, 2)];
    [map addGameElement:BLOCKER_H(3, 4, 2)];
    [map addGameElement:BLOCKER_H(3, 5, 2)];
    
    self.gameMap = map;
    
    if([map isValid])
    {
        NSLog(@"data valid");
    }
    else
    {
        NSLog(@"data invalid");
    }
}

-(BOOL)isMapUsed:(QTGameMap*)map
{
    for (QTGameMap* usedMap in [self.usedMap quickAllObjects]) {
        if ([usedMap isEqualToMap:map]) {
            return YES;
        }
    }
    return NO;
}

-(QTGameMap*)crack;
{
   [self crackMap:_gameMap];
   return _gameMap;
}



-(BOOL)crackMap:(QTGameMap*)map
{//深度遍历算法
    [self.mapDeque insertObjectToBack:map];
    [self.usedMap insertObject:map];
    
    if ([map canFishMoveOut]) {
        [self crackSuccess];
        return YES;
    }
    else
    {
        EKQueue* maps = [map allMoves];
        if (![maps isEmpty]) {
            while (![maps isEmpty]) {
                QTGameMap* nextMap = [maps removeFirstObject];
                if (![self isMapUsed:nextMap]) {
                    BOOL crack = [self crackMap:nextMap];
                    if(crack)
                    {
                        return crack;
                    }
                    else
                    {
                        [self.mapDeque removeLastObject];
                    }
                }
            }
        }
        else
        {
            [self.mapDeque removeLastObject];
        }
        return NO;
    }
}

-(BOOL)isMapValid:(QTGameMap *)map
{
    return ![self isMapUsed:map];
}

-(void)crackSuccess
{
    NSLog(@"crackSuccess");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mapEngine:crackSuccess:)]) {
        [self.delegate mapEngine:self crackSuccess:self.mapDeque];
    }
}

-(void)crackFailed
{
    NSLog(@"crackFailed");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mapEngine:crackFailed:)]) {
        [self.delegate mapEngine:self crackFailed:nil];
    }
}

-(QTGameMap*)gameMap
{
    return _gameMap;
}
@end
