//
//  QTGameElement.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameElement.h"

@implementation QTGameElement
{
    NSString* _elementID;
}
-(id)init
{
    if (self  = [super init]) {
        self.identity = -1;
        self.blockNumber = -1;
        self.direction = ElementDirection_None;
        self.positionX=-1;
        self.positionY=-1;
        _elementID = nil;
    }
    return self;
}

-(BOOL)isValid
{
    if (self.identity == -1) {
        return NO;
    }
    if (_blockNumber<2||_blockNumber>3) {
        return NO;
    }
    if (_direction==ElementDirection_None) {
        return NO;
    }
    if (_positionX==-1||_positionY==-1) {
        return NO;
    }
    return YES;
}

-(BOOL)isEqualToElement:(QTGameElement*)element
{
    if (element.identity == self.identity&&element.positionX == self.positionX&&element.positionY == self.positionY)
        return YES;
    return NO;
}

-(QTGameElement*)deepCopy
{
    //子类实现
    return nil;
}

-(NSString*)edentify
{
    if (!_elementID) {
        _elementID = [NSString stringWithFormat:@"%d%d%d",self.identity,self.positionX,self.positionY];
    }
    return _elementID;
}

-(NSString*)description
{
    NSString* des = [NSString stringWithFormat:@"identify = %@\n blockNumer=%@\n direction=%@\n posionX = %@\n positionY=%@\n",@(self.identity),@(self.blockNumber),@(self.direction),@(self.positionX),@(self.positionY)];
    
    return des;
}
@end
