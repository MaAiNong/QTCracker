//
//  QTGameElement.h
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QT_BOARD_COUNT 6

typedef enum {ElementDirection_None=-1,ElementDirection_Horizon,ElementDirection_Vertical}ElementDirection;

@interface QTGameElement : NSObject

@property(nonatomic,assign)int identity;//标识 头为0 其他递增不重复即可 默认-1
@property(nonatomic,assign)int blockNumber;//块数 2 3 默认-1
@property(nonatomic,assign)ElementDirection direction;//垂直方向？
@property(nonatomic,assign)int positionX;//头部位置 垂直方向最上面的方块所处的位置 水平方向最左侧所处的位置 坐标轴方向和IOS一致
@property(nonatomic,assign)int positionY;//头部位置 垂直方向最上面的方块所处的位置 水平方向最左侧所处的位置 坐标轴方向和IOS一致

-(BOOL)isValid;
-(BOOL)isEqualToElement:(QTGameElement*)element;
-(QTGameElement*)deepCopy;
@end
