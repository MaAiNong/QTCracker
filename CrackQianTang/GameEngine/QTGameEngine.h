//
//  QTGameEngine.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTGameMap.h"

@interface QTGameEngine : NSObject
-(void)start;
-(QTGameMap*)gameMap;
-(void)crack;
@end
