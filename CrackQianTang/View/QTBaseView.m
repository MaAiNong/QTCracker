//
//  QTBaseView.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/27.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTBaseView.h"
#import "QTFinshView.h"
#import "QTHorizonBlockView.h"
#import "QTVerticalBlockView.h"
#import "QTFishHeader.h"
#import "QTFishBlocker.h"
@implementation QTBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(QTBaseView*)generateQTView:(QTGameElement*)element
{
    if ([element isKindOfClass:[QTFishBlocker class]]) {
        
        QTFishBlocker* blocker = (QTFishBlocker*)element;
        
        
    }
    
    if ([element isKindOfClass:[QTFishHeader class]]) {
        
    }
    
}

@end
