//
//  QTPixels2Elements.h
//  CrackQianTang
//
//  Created by kevin on 2017/10/21.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NPMatrix.h"

@interface QTPixels2Elements : NSObject
+(NSArray*)getQTElementsByPiexls:(NSArray<NPMatrix*>*)matrixs;
@end
