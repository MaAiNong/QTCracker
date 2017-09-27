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

@interface QTGameEngine()
@property(nonatomic,strong)QTGameMap* gameMap;
@end

@implementation QTGameEngine
-(void)start
{
    [[QTIdentifyGenerator sharedInstance] reset];
    
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
    [map addGameElement:BLOCKER_V(0, 3, 2)];
    [map addGameElement:BLOCKER_V(3, 4, 2)];
    [map addGameElement:BLOCKER_V(3, 5, 2)];
    
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

-(QTGameMap*)gameMap
{
    return self.gameMap;
}
@end
