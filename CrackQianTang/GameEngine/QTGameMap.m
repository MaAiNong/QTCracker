//
//  QTGameMap.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameMap.h"

@implementation QTGameMap
{
    NSMutableArray* _elements;
}
-(id)init
{
    if (self  = [super init]) {
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}

-(QTGameMap*)addGameElement:(QTGameElement *)element
{
    [_elements addObject:element];
    
    return self;
}

-(NSEnumerator*)enumerator
{
    if (_elements&&_elements.count>0) {
        return [_elements objectEnumerator];
    }
    return nil;
}

-(BOOL)isValid
{
    for (QTGameElement* element in _elements) {
        if (![element isValid]) {
            return NO;
        }
    }
    return YES;
}
@end
