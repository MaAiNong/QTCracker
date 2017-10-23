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
#import "UIImage+Canny.h"
#import "QTIdentifyGenerator.h"

@interface ViewController ()<QTGameEngineDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)GameBoardView* gameBoard;
@property(nonatomic,strong)QTGameEngine* gameEngine;
@property(nonatomic,assign)QTGameCrackType crackType;

@property(nonatomic,strong)UILabel* crackTypeLabel;
@property(nonatomic,strong)UIActivityIndicatorView* activityHint;
@property(nonatomic,strong)UIImagePickerController* imagePicker;
@property(nonatomic,strong)dispatch_queue_t crackQueue;
@property(nonatomic,strong)dispatch_queue_t uiQueue;

@end

@implementation ViewController
{
    NSTimeInterval _startTime;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self.gameBoard];
    self.gameBoard.center = self.view.center;
    
    [self.view addSubview:self.activityHint];
    [self.activityHint setFrame:self.gameBoard.frame];
    
    [self.view addSubview:self.crackTypeLabel];
    self.crackType = QTGameCrackType_BFS;
    
    //添加滑动和点击手势
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeCrackStyle)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImagePicker)]];
    
    self.gameEngine = [[QTGameEngine alloc] init];
    [self.gameEngine setDelegate:self];
    
    //进行破解操作的线程
    self.crackQueue = dispatch_queue_create("com.man.sb", DISPATCH_QUEUE_SERIAL);
    //绘制UI的线程
    self.uiQueue = dispatch_queue_create("com.man.ui", DISPATCH_QUEUE_SERIAL);

    [self showImagePicker];
    
}

-(void)changeCrackStyle
{
    if (QTGameCrackType_BFS == self.crackType)
    {
        self.crackType = QTGameCrackType_DFS;
    }
    else if (QTGameCrackType_DFS == self.crackType)
    {
        self.crackType = QTGameCrackType_BFS;
    }
}

-(void)showImagePicker
{
     [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopActiveAnimate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityHint stopAnimating];
    });
}

#pragma mark --- QTGameEngineDelegate
-(void)mapEngine:(QTGameEngine *)engine noNeedToCrack:(NSDictionary *)message
{
    [self stopActiveAnimate];
    NSLog(@"no need to crack");
}

-(void)mapEngine:(QTGameEngine *)engine crackFailed:(EKDeque *)resultQueue
{
    [self stopActiveAnimate];
    NSLog(@"failed to crack");
}

-(void)mapEngine:(QTGameEngine *)engine crackSuccess:(EKDeque *)resultQueue
{
    [self stopActiveAnimate];
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

#pragma mark --- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (editedImage) {
        [[QTIdentifyGenerator sharedInstance] reset];
        QTGameMap* map = [editedImage QTGameMap];
        if (map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.gameBoard drawGameWithMap:map];
                [self.activityHint startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), self.crackQueue, ^{
                    _startTime = [NSDate timeIntervalSinceReferenceDate];
                    [self.gameEngine crackWithMap:map crackType:self.crackType];
                });
            });
        }
        else
        {
            
        }
    }
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark --- getter
-(UIImagePickerController*)imagePicker
{
    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
//        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    return _imagePicker;
}

-(GameBoardView*)gameBoard
{
    if (!_gameBoard) {
        _gameBoard = [[GameBoardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20, CGRectGetWidth(self.view.bounds)-20)];
    }
    return _gameBoard;
}

-(UIActivityIndicatorView*)activityHint
{
    if (!_activityHint) {
        _activityHint = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityHint;
}

-(UILabel*)crackTypeLabel
{
    if (!_crackTypeLabel) {
        _crackTypeLabel = [[UILabel alloc] init];
        _crackTypeLabel.backgroundColor = [UIColor clearColor];
        [_crackTypeLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [_crackTypeLabel setTextAlignment:NSTextAlignmentLeft];
        [_crackTypeLabel setFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.bounds),20)];
    }
    return _crackTypeLabel;
}
-(void)setCrackType:(QTGameCrackType)crackType
{
    _crackType = crackType;
    if (QTGameCrackType_DFS == crackType)
    {
        [self.crackTypeLabel setText:@"DFS"];
    }
    else if (QTGameCrackType_BFS == crackType)
    {
        [self.crackTypeLabel setText:@"BFS"];
    }
    else
    {
        [self.crackTypeLabel setText:@""];
    }
}
@end
