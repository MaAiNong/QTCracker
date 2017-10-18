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
@interface QTGameMap : EKQueue

-(QTGameMap*)addGameElement:(QTGameElement*)element;
-(EKQueue*)allMoves;
-(QTFishHeader*)getFinshHeader;
-(BOOL)isEqualToMap:(QTGameMap*)map;
-(void)sortByIdentify;

-(NSEnumerator*)enumerator;
-(BOOL)canFishMoveOut;
-(BOOL)isValid;

-(QTGameMap*)shadowCopy;
-(QTGameMap*)replaceElement:(QTGameElement*)element;

@end
