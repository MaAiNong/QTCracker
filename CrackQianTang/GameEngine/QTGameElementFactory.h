//
//  QTGameElementFactory.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTFishHeader.h"
#import "QTFishBlocker.h"

#define HEADER(PX,PY) [QTGameElementFactory generateFinshHeaderWithPositionX:PX positionY:PY]
#define BLOCKER_H(PX,PY,NUM) [QTGameElementFactory generateHorizonBlocker:PX position:PY number:NUM]
#define BLOCKER_V(PX,PY,NUM) [QTGameElementFactory generateVerticalBlocker:PX position:PY number:NUM]

@interface QTGameElementFactory : NSObject

+(QTFishHeader*)generateFinshHeaderWithPositionX:(int)px positionY:(int)py;

+(QTFishBlocker*)generateHorizonBlocker:(int)px position:(int)py number:(int)number;

+(QTFishBlocker*)generateVerticalBlocker:(int)px position:(int)py number:(int)number;

@end
