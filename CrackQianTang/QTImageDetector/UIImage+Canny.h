//
//  UIImage+Canny.h
//  CannyDemo
//
//  Created by Hydra on 15/8/16.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPMatrix.h"

#import "QTGameMap.h"

@interface UIImage (Canny)

-(instancetype)cannyImageWithGaussFilter:(size_t)size sigma:(CGFloat)sigma;
-(NPMatrix *)cannyMatrixWithGaussFilter:(size_t)size sigma:(CGFloat)sigma;
-(NSArray<NPMatrix*>*)imagePixels;
-(QTGameMap*)QTGameMap;
@end
