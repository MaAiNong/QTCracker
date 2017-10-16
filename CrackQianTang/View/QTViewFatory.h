//
//  QTViewFatory.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/27.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTBaseView.h"
#import "QTGameElement.h"
@interface QTViewFatory : NSObject
+(QTBaseView*)generateBaseViewByElement:(QTGameElement*)element frame:(CGRect)frame;
@end
