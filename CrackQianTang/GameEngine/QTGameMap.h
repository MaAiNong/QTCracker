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
@interface QTGameMap : EKQueue
-(NSEnumerator*)enumerator;
-(QTGameMap*)addGameElement:(QTGameElement*)element;
-(BOOL)isValid;
@end