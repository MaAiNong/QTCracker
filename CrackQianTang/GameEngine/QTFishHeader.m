//
//  QTFishHeader.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTFishHeader.h"

@implementation QTFishHeader
-(id)init
{
    if (self  = [super init]) {
        
        self.identity = 0;
        self.blockNumber = 2;
        self.direction = ElementDirection_Horizon;
        
    }
    return self;
}
@end
