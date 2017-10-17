//
//  QTGameMap.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameMap.h"

@implementation QTGameMap

-(id)init
{
    if (self  = [super init])
    {
        
    }
    return self;
}

-(QTGameMap*)addGameElement:(QTGameElement *)element
{
    [self insertObject:element];
    
    return self;
}

-(NSEnumerator*)enumerator
{
    if (![self isEmpty]) {
        return [[self allObjectsFromQueue] objectEnumerator];
    }
    return nil;
}

-(BOOL)isValid
{
    for (QTGameElement* element in [self allObjectsFromQueue]) {
        if (![element isValid]) {
            return NO;
        }
    }
    return YES;
}
@end
