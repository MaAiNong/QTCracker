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

@interface ViewController ()
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
    [self.gameEngine start];
    
    [self.gameBoard drawGameWithMap:[self.gameEngine gameMap]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
