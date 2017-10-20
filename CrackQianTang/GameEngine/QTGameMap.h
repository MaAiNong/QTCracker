//
//  QTGameMap.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTGameElement.h"
#import "EKQueue.h"
#import "QTFishHeader.h"

@class QTGameMap;

@interface QTGameMap : EKQueue

@property(nonatomic,assign,readonly)int matchWeight;
@property(nonatomic,weak)QTGameMap* fatherMap;//广度优先算法里面有用

-(QTGameMap*)addGameElement:(QTGameElement*)element;
-(QTGameMap*)shadowCopy;
-(QTGameMap*)replaceElement:(QTGameElement*)element;

-(EKQueue*)allMoves;
-(EKQueue*)newAllMoves;
-(QTFishHeader*)getFinshHeader;

-(NSEnumerator*)enumerator;

-(BOOL)isEqualToMap:(QTGameMap*)map;
-(void)sortByIdentify;
-(BOOL)canFishMoveOut;
-(BOOL)isValid;

-(void)addMatchWeight;
-(NSString*)getIdentify;
@end
