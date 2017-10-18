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
@end

@implementation ViewController

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
    
    self.gameEngine = [[QTGameEngine alloc] init];
    [self.gameEngine setDelegate:self];
    [self.gameEngine start];
    
    [self.gameBoard drawGameWithMap:[self.gameEngine gameMap]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self gameEngine] crack];
    });
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- QTGameEngineDelegate

-(void)mapEngine:(QTGameEngine *)engine crackFailed:(EKDeque *)resultQueue
{
    
}

-(void)mapEngine:(QTGameEngine *)engine crackSuccess:(EKDeque *)resultQueue
{
    
    for (QTGameMap* map in [resultQueue allObjectsFromDeque]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.gameBoard drawGameWithMap:map];
        });
        
    }

    
    
}



@end
