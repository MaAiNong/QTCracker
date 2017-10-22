//
//  ViewController.m
//  CrackQianTang
//
//  Created by X-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "ViewController.h"
#import "QTGameEngine.h"
#import "GameBoardView.h"

@interface ViewController ()<QTGameEngineDelegate>
@property(nonatomic,strong)GameBoardView* gameBoard;
@property(nonatomic,strong)QTGameEngine* gameEngine;
@property(nonatomic,strong)dispatch_queue_t crackQueue;
@property(nonatomic,strong)dispatch_queue_t uiQueue;
@end

@implementation ViewController
{
    NSTimeInterval _startTime;
}
- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    GameBoardView* game = [[GameBoardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20, CGRectGetWidth(self.view.bounds)-20)];
    game.center = self.view.center;
    [game setNeedsLayout];
    [game setNeedsDisplay];
    self.gameBoard = game;
    [self.view addSubview:self.gameBoard];
    
    self.gameEngine = [[QTGameEngine alloc] initWithImage:[UIImage imageNamed:@"qt121.png"]];
    [self.gameEngine setDelegate:self];
    if([self.gameEngine start])
    {
        [self.gameBoard drawGameWithMap:[self.gameEngine gameMap]];
        
        self.crackQueue = dispatch_queue_create("com.man.sb", DISPATCH_QUEUE_SERIAL);
        self.uiQueue = dispatch_queue_create("com.man.ui", DISPATCH_QUEUE_SERIAL);
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), self.crackQueue, ^{
        
            _startTime = [NSDate timeIntervalSinceReferenceDate];
            [self.gameEngine crack];
            

        });
    }
    else
    {
        NSLog(@"cannot start game");
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- QTGameEngineDelegate
-(void)mapEngine:(QTGameEngine *)engine noNeedToCrack:(NSDictionary *)message
{
    NSLog(@"no need to crack");
}

-(void)mapEngine:(QTGameEngine *)engine crackFailed:(EKDeque *)resultQueue
{
    NSLog(@"failed to crack");
}

-(void)mapEngine:(QTGameEngine *)engine crackSuccess:(EKDeque *)resultQueue
{
    NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
    NSArray* maps = [resultQueue allObjectsFromDeque];
    
    NSLog(@"crack success 耗时 %f 秒 %f 分钟 %lu 步骤",endTime-_startTime,(endTime-_startTime)/60,(unsigned long)maps.count);
    
    for (QTGameMap* map in maps) {
    
        dispatch_async(self.uiQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    [self.gameBoard changeGameMap:map];
                }];
            });
            sleep(1);
        });
        
    }
    
}



@end
