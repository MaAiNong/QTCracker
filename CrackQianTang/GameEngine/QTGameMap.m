//
//  QTGameMap.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTGameMap.h"
#import "QTMapSingleton.h"
@implementation QTGameMap

-(id)init
{
    if (self  = [super init])
    {
        
    }
    return self;
}

//-(id)cop

-(QTGameMap*)addGameElement:(QTGameElement *)element
{
    [self insertObject:element];
    
    return self;
}

-(QTFishHeader*)getFinshHeader
{
    for (QTGameElement* element in [self quickAllObjects]) {
        if ([element isKindOfClass:[QTFishHeader class]]) {
            return ((QTFishHeader*)element);
        }
    }
    return nil;
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

-(BOOL)canFishMoveOut
{
    QTGameElement* header = [self getFinshHeader];
    int headerMinY = header.positionY;
    int headerMaxY = headerMinY + 1;
    
    int headerMinX = header.positionX;
    int headerMaxX = headerMinX + header.blockNumber;
    
    for (QTGameElement* element in [self quickAllObjects]) {
        
        if (![element isEqual:header]) {
            
            if (ElementDirection_Horizon == element.direction) {
                if (element.positionY==headerMinY&&element.positionX>=headerMaxX) {//同一行 且在前面
                    return NO;
                }
            }
            else if((element.positionX>=headerMaxX)&&headerMaxY<=(element.positionY+element.blockNumber)&&headerMinY>=element.positionY)//前方竖直 且堵塞
            {
                return NO;
            }
        }
        
    }
    return YES;
}

-(CGRect)getElementRect:(QTGameElement*)element
{
    CGRect rect = CGRectMake(
                                 element.positionX,
                                 element.positionY,
                                 ((ElementDirection_Horizon == element.direction)?element.blockNumber:1),
                                 ((ElementDirection_Horizon == element.direction)?1:element.blockNumber)
                             );
    return rect;
}

-(BOOL)noConflictToOthers:(QTGameElement*)element
{
   
    CGRect eleRect = [self getElementRect:element];
    for (QTGameElement* newele in [self quickAllObjects]) {
        
        if (newele.identity != element.identity) {
            
            CGRect newEleRect = [self getElementRect:newele];
            
            if(CGRectIntersectsRect(newEleRect, eleRect)||CGRectContainsRect(newEleRect, eleRect)||CGRectContainsRect(eleRect,newEleRect))
                return NO;
            
        }
        
    }
    return YES;
}

-(void)sortByIdentify
{
    //这个地方可以优化为按照标识排序 这样的话对比map的时间会大幅度降低
    //TODO://xkt
}

-(BOOL)isEqualToMap:(QTGameMap*)map
{
    for (QTGameElement* origin in [self quickAllObjects]) {
        
        for (QTGameElement* destination in [map quickAllObjects]) {
            
            if (origin.identity == destination.identity)
            {
                if(![origin isEqualToElement:destination])
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}

-(QTGameMap*)shadowCopy
{
    QTGameMap* map = [[QTGameMap alloc] init];
    map.delegate = self.delegate;
    for (QTGameElement* element in [self quickAllObjects]) {
        [map addGameElement:element];
    }
    return map;
}

//替换map中的某个元素
-(QTGameMap*)replaceElement:(QTGameElement*)element
{
    QTGameMap* map = [[QTGameMap alloc] init];
    map.delegate = self.delegate;
    QTGameElement* first = [self removeFirstObject];
    while (first) {
        if (first.identity == element.identity)
            [map addGameElement:element];
        else
            [map addGameElement:first];
        
        first = [self removeFirstObject];
    }
    return map;
}


-(NSArray*)getElementMoves:(QTGameElement*)element
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if (ElementDirection_Horizon == element.direction)
    {
        for(int i=element.positionX-1;i>=0;i--)
        {
            QTGameElement* newElement = [element deepCopy];
            newElement.positionX = i;
            if ([self noConflictToOthers:newElement]) {
                [array addObject:newElement];
            }
            else
            {
                break;
            }
        }
        
        for (int i=element.positionX+1; i<=QT_BOARD_COUNT-(element.blockNumber); i++) {
            QTGameElement* newElement = [element deepCopy];
            newElement.positionX = i;
            if ([self noConflictToOthers:newElement]) {
                [array addObject:newElement];
            }
            else
            {
                break;
            }
        }
    }
    else
    {
        for(int i=element.positionY-1;i>=0;i--)
        {
            QTGameElement* newElement = [element deepCopy];
            newElement.positionY = i;
            if ([self noConflictToOthers:newElement]) {
                [array addObject:newElement];
            }
            else
            {
                break;
            }
        }
        
        for (int i=element.positionY+1; i<=QT_BOARD_COUNT-(element.blockNumber); i++) {
            QTGameElement* newElement = [element deepCopy];
            newElement.positionY = i;
            if ([self noConflictToOthers:newElement]) {
                [array addObject:newElement];
            }
            else
            {
                break;
            }
        }
    }
    
    return array;
}

-(EKQueue*)allMoves
{
    //需要考虑深浅拷贝
    //这个地方可以优化为从已有的map列表里面取或删除map 这样的话虽然没有降低比较频率，但是节省了空间
    //TODO:xkt allmoves
    EKQueue* queue = [[EKQueue alloc] init];
    NSArray* allData = [self quickAllObjects];
    for (QTGameElement* element in allData)
    {
        NSArray* canMoves = [self getElementMoves:element];
        for (QTGameElement* newElement in canMoves) {
            
            BOOL mapValid = YES;
            
            QTGameMap* map = [self shadowCopy];
            map.delegate = self.delegate;
            map = [map replaceElement:newElement];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(isMapValid:)]) {
                mapValid = [self.delegate isMapValid:map];
            }
            if (mapValid) {
                
                mapValid = ![[QTMapSingleton sharedSingleton] isMapExist:map];
                if(mapValid)
                {
                    [[QTMapSingleton sharedSingleton] addMap:map];
                    [queue insertObject:map];
                }
                else
                {
//                    NSLog(@"ex");
                }
            }
            
        }
    }
    return queue;
}
@end
