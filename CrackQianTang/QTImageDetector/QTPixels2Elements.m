//
//  QTPixels2Elements.m
//  CrackQianTang
//
//  Created by kevin on 2017/10/21.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTPixels2Elements.h"
#import "QTGameElementFactory.h"


@implementation QTPixels2Elements

+(NSArray*)getQTElementsByPiexls:(NSArray<NPMatrix*>*)matrixs;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray* pointArray = [[NSMutableArray alloc] init];
    
    //字节数
    if(matrixs.count!=4)
    {
        return nil;
    }

    NPMatrix *rmat,*gmat,*bmat,*amat;
    rmat=matrixs[0];
    gmat=matrixs[1];
    bmat=matrixs[2];
    amat=matrixs[3];
    
    {
//        NSUInteger twidht = rmat.width;
//        NSUInteger theight = rmat.height;
//        printf("-------------------------------\n");
//        for (NSUInteger y = 0; y<theight; y++)
//        {
//            for (NSUInteger x = 0; x<twidht; x++)
//            {
//                printf("%d ",[[rmat elementAtX:x Y:y] unsignedCharValue]);
//            }
//            printf("\n-------------------------------");
//        }
//        return nil;
    }
    
    NSUInteger widht = rmat.width;
    NSUInteger height = rmat.height;
    NSUInteger sliceX = widht/QT_BOARD_COUNT;
    NSUInteger sliceY = height/QT_BOARD_COUNT;
    NSUInteger radius = MIN((sliceX/4),(sliceY/4));
    QTGameElement* elment = nil;
    
    
    for (NSUInteger x = 0; x<QT_BOARD_COUNT; x++)
    {
        for (NSUInteger y = 0; y<QT_BOARD_COUNT; y++)
        {
            ElementDirection direction = ElementDirection_None;
            int blockNUM = -1;
            BOOL isHeader = NO;
            if((QT_BOARD_COUNT-1)==x)
            {
                direction = ElementDirection_Vertical;
            }
            else if ((QT_BOARD_COUNT-1) == y)
            {
                direction = ElementDirection_Horizon;
            }
            
            if (![self isPointUsed:CGPointMake(x, y) inArray:pointArray])
            {
                NSUInteger pointX = x*sliceX+sliceX/2;
                NSUInteger pointY = y*sliceY+sliceY/2;
                
                int meanR = [[rmat meanValueAtX:pointX Y:pointY radius:radius] unsignedCharValue];
                int meanG = [[gmat meanValueAtX:pointX Y:pointY radius:radius] unsignedCharValue];
                int meanB = [[bmat meanValueAtX:pointX Y:pointY radius:radius] unsignedCharValue];
                
                if (meanG>50&&meanG<80&&meanB>50&&meanB<80) {
                    blockNUM = 2;
                    direction = ElementDirection_Horizon;
                    isHeader = YES;
                }
                else if (meanR>=0&&meanR<=40) {
                    //蓝色 三个 需要确定方向
                    
                    blockNUM = 3;
                    
                    if(direction == ElementDirection_None)
                    {
                        int tmpX = [[rmat meanValueAtX:(x+1)*sliceX Y:pointY radius:radius] unsignedCharValue];
                        
                        int tmpY = [[rmat meanValueAtX:pointX Y:(y+1)*sliceY radius:radius] unsignedCharValue];
                        
                            if (tmpX>tmpY)
                            {//垂直
                                direction = ElementDirection_Vertical;
                            }
                            else
                            {//水平
                                direction = ElementDirection_Horizon;
                            }
                    }
                }
                else if(meanB>=40&&meanB<=80)
                {
                    //黄色 两个 需要确定方向
                    blockNUM = 2;
                    
                    if(direction == ElementDirection_None)
                    {
                        int tmpX = [[bmat meanValueAtX:(x+1)*sliceX Y:pointY radius:radius] unsignedCharValue];
                        
                        int tmpY = [[bmat meanValueAtX:pointX Y:(y+1)*sliceY radius:radius] unsignedCharValue];
                        
                        if (tmpX>tmpY)
                        {//垂直
                            direction = ElementDirection_Vertical;
                        }
                        else
                        {//水平
                            direction = ElementDirection_Horizon;
                        }
                    }
                }
                if (blockNUM!=-1&&direction!=ElementDirection_None) {
                    
                    if (direction == ElementDirection_Vertical)
                    {
                        elment = [QTGameElementFactory generateVerticalBlocker:x position:y number:blockNUM];
                        if (blockNUM == 2 ) {
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x,y+1)]];
                        }
                        else if (blockNUM == 3)
                        {
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x,y+1)]];
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x,y+2)]];
                        }
                    }
                    else
                    {
                        if (isHeader) {
                            elment = [QTGameElementFactory generateFinshHeaderWithPositionX:x positionY:y];

                        }
                        else
                        {
                            elment = [QTGameElementFactory generateHorizonBlocker:x position:y number:2];
                        }
                        if (blockNUM == 2) {
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x+1,y)]];
                        }
                        else if (blockNUM == 3) {
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x+1,y)]];
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x+2,y)]];
                        }
                    }
                    

                    
                    [array addObject:elment];
                }
            }
        }
    }
    return array;
}

+(BOOL)isPointUsed:(CGPoint)point inArray:(NSArray*)array
{
    for (NSValue* value in array)
    {
        CGPoint pt = [value CGPointValue];
        
        if(CGPointEqualToPoint(pt, point))
        {
            return YES;
        }
    }
    return NO;
}

@end
