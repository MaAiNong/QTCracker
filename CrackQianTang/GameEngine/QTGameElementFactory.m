//
//  QTGameElementFactory.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameElementFactory.h"
#import "QTIdentifyGenerator.h"
@implementation QTGameElementFactory
+(QTFishHeader*)generateFinshHeaderWithPositionX:(int)px positionY:(int)py;
{
    QTFishHeader* header = [[QTFishHeader alloc] init];
    
    header.positionX = px;
    header.positionY = py;
    
    return header;
}

+(QTFishBlocker*)generateHorizonBlocker:(int)px position:(int)py number:(int)number
{
    QTFishBlocker* blocker = [[QTFishBlocker alloc] init];
    blocker.blockNumber = number;
    blocker.direction = ElementDirection_Horizon;
    blocker.positionX = px;
    blocker.positionY = py;
    
    [[QTIdentifyGenerator sharedInstance] handleIdentifier:^(int identifier) {
        blocker.identity = identifier;
    }];
    
    NSLog(@"%@",blocker);
    
    return blocker;
    
}

+(QTFishBlocker*)generateVerticalBlocker:(int)px position:(int)py number:(int)number
{
    QTFishBlocker* blocker = [[QTFishBlocker alloc] init];
    blocker.blockNumber = number;
    blocker.direction = ElementDirection_Vertical;
    blocker.positionX = px;
    blocker.positionY = py;
    
    [[QTIdentifyGenerator sharedInstance] handleIdentifier:^(int identifier) {
        blocker.identity = identifier;
    }];
    
    NSLog(@"%@",blocker);
    
    return blocker;
}
@end
