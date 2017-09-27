//
//  QTBaseView.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/27.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTGameElement.h"
@interface QTBaseView : UIView
-(QTBaseView*)generateQTView:(QTGameElement*)element;
@end
