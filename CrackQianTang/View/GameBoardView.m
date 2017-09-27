//
//  GameBoardView.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "GameBoardView.h"
#import "QTGameElement.h"
#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@implementation GameBoardView
{
    CGFloat _gameWidth;
    UIColor* _gameColor;
    QTGameMap* _currentMap;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawGameWithMap:(QTGameMap*)map
{
    if (_currentMap)
    {
        _currentMap = map;
        UIView animateWithDuration:0.3 animations:^{
            [self changeGameMap:map];
        }
        
    }
    else
    {
        _currentMap = map;
        [self parseGameMap:map];
    }
}

-(void)parseGameMap:(QTGameMap*)map
{
    for (UIView* sview in [self subviews]) {
        [sview removeFromSuperview];
    }
    
    
}

-(void)changeGameMap:(QTGameMap*)map
{
    //    TODO:
}

-(void)layoutSubviews
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gameColor = UIColorFromRGB(0x0bbe06);
        self.layer.borderColor =_gameColor.CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor clearColor];
    });
    _gameWidth = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [super layoutSubviews];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context,_gameColor.CGColor);
    CGFloat gap = _gameWidth/6;
    //横纵四条线
    for (int i=1; i<=5; i++) {
        CGFloat x_axis = i*gap;
        CGContextMoveToPoint(context,x_axis, 0);
        CGContextAddLineToPoint(context, x_axis , _gameWidth);
        
        CGFloat y_axis = i*gap;
        CGContextMoveToPoint(context,0, y_axis);
        CGContextAddLineToPoint(context, _gameWidth,y_axis);
    }
    
    CGContextStrokePath(context);
}

@end
