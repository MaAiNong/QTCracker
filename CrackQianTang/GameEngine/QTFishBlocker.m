//
//  QTFishBlocker.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTFishBlocker.h"

@implementation QTFishBlocker

-(id)init
{
    if (self  = [super init]) {
        
    }
    return self;
}

-(QTGameElement*)deepCopy
{
    QTFishBlocker* element = [[QTFishBlocker alloc] init];
    
    element.identity = self.identity;
    element.blockNumber = self.blockNumber;
    element.direction = self.direction;
    element.positionX = self.positionX;
    element.positionY = self.positionY;
    
    return element;
}


@end
