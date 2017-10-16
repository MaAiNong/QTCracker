//
//  QTViewFatory.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/27.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTViewFatory.h"

#import "QTFinshView.h"
#import "QTHorizonBlockView.h"
#import "QTVerticalBlockView.h"

#import "QTFishHeader.h"
#import "QTFishBlocker.h"

@implementation QTViewFatory

+(QTBaseView*)generateBaseViewByElement:(QTGameElement*)element frame:(CGRect)frame
{
    
    int x = element.positionX;
    int y = element.positionY;
    int count = element.blockNumber;
    int boardTime = 6;
    CGFloat meta = CGRectGetWidth(frame)/6;
    
    if ([element isKindOfClass:[QTFishBlocker class]])
    {
        if (ElementDirection_Horizon == element.direction)
        {
            QTHorizonBlockView* view = [[QTHorizonBlockView alloc] init];
            
            [view setFrame:CGRectMake(x*meta, y*meta, count*meta, 1*meta)];
           
            [view setBackgroundColor:[UIColor orangeColor]];
            
            [view.layer setBorderColor:[UIColor blackColor].CGColor];
            [view.layer setBorderWidth:1.0f];
            
            return view;
        }
        else
        {
            QTVerticalBlockView* view = [[QTVerticalBlockView alloc] init];
            [view setFrame:CGRectMake(x*meta, y*meta,1*meta,count*meta)];
            [view setBackgroundColor:[UIColor yellowColor]];
            [view.layer setBorderColor:[UIColor blackColor].CGColor];
            [view.layer setBorderWidth:1.0f];
            return view;
        }
    }
    else
    {
        QTFinshView* view = [[QTFinshView alloc] init];
        [view setFrame:CGRectMake(x*meta, y*meta, count*meta, 1*meta)];
        [view setBackgroundColor:[UIColor redColor]];
        [view.layer setBorderColor:[UIColor blackColor].CGColor];
        [view.layer setBorderWidth:1.0f];
        return view;
    }
    
    return nil;
}

@end
