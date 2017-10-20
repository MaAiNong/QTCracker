//
//  QTGameEngine.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameEngine.h"
#import "QTIdentifyGenerator.h"
#import "QTMapSingleton.h"
#import "QTGameMap.h"
#import "QTGameElementFactory.h"
#import "EKStack.h"
#import "EKDeque.h"
#import "QTMapSingleton.h"
@interface QTGameEngine()
@property(nonatomic,strong)QTGameMap* gameMap;
@property(nonatomic,strong)EKDeque* mapDeque;
@end

@implementation QTGameEngine
-(void)start
{
    self.mapDeque = [[EKDeque alloc] init];
//    self.usedMap = [[EKQueue alloc] init];
    
    [[QTIdentifyGenerator sharedInstance] reset];
    [[QTMapSingleton sharedSingleton] clearAll];
    
    //初始化map
    QTGameMap* map = [[QTGameMap alloc] init];
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

-(QTGameMap*)crack;
{
    [self.mapDeque clear];
    [[QTMapSingleton sharedSingleton] clearAll];
    [[QTMapSingleton sharedSingleton] addMap:_gameMap];
    
    if([_gameMap canFishMoveOut]) {

        [self noNeedToCrack];
        return _gameMap;
    }
    
//  广度遍历
    EKQueue* tmpQueue = [[EKQueue alloc] init];
    [tmpQueue insertObject:_gameMap];
    [self BFSCrackMap:tmpQueue];
//  深度遍历
//    [self DFSCrackMap:_gameMap];
//---------------------------------------------
    if ([self.mapDeque isEmpty])
    {
        [self crackFailed];
    }
    
    return _gameMap;
}

-(void)BFSCrackMap:(EKQueue*)maps
{
    
    NSLog(@"本层需要处理的队列数据为 %lu",(unsigned long)[maps quickAllObjects].count);
    if (![maps isEmpty])
    {
        EKQueue* newQueue = [[EKQueue alloc] init];
        QTGameMap* map = [maps removeFirstObject];
        while (map) {
            if ([map canFishMoveOut])
            {
                [self handleBFSMap:map];
                return;
            }
            else
            {
                EKQueue* newMoves = [map newAllMoves];
                [newQueue insertEKQueue:newMoves];
            }
            map = [maps removeFirstObject];
        }
        [self BFSCrackMap:newQueue];
    }
}

-(void)handleBFSMap:(QTGameMap*)map
{
    [self.mapDeque clear];
    [self.mapDeque insertObjectToFront:map];
    QTGameMap* tmpMap = map.fatherMap;
    while (tmpMap)
    {
        [self.mapDeque insertObjectToFront:tmpMap];
        tmpMap = tmpMap.fatherMap;
    }
    if (![self.mapDeque isEmpty]) {
        [self crackSuccess];
    }
}

-(BOOL)DFSCrackMap:(QTGameMap*)map
{//深度遍历算法
    [self.mapDeque insertObjectToBack:map];
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
                BOOL crack = [self DFSCrackMap:nextMap];
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
        else
        {
            [self.mapDeque removeLastObject];
        }
        return NO;
    }
}

-(void)noNeedToCrack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mapEngine:noNeedToCrack:)]) {
        [self.delegate mapEngine:self noNeedToCrack:nil];
    }
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
