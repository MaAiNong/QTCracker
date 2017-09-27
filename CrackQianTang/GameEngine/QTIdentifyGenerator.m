
//
//  QTIdentifyGenerator.m
//  CrackQianTang
//
//  Created byX-MAN on 2017/9/26.
//  Copyright © 2017年 maainong. All rights reserved.
//

#import "QTIdentifyGenerator.h"
QTIdentifyGenerator* _identifyGenerator = nil;
static dispatch_queue_t _serialQueue;
@implementation QTIdentifyGenerator
{
    int _identify;
}

+ (dispatch_queue_t)serialQueue {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serialQueue = dispatch_queue_create("com.qt.crack", DISPATCH_QUEUE_SERIAL);
    });
    
    return _serialQueue;
}

+(id)sharedInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _identifyGenerator = [[QTIdentifyGenerator alloc] init];
        _identifyGenerator = [[QTIdentifyGenerator alloc] init];
        [_identifyGenerator reset];
    });
    return _identifyGenerator;
}

-(void)handleIdentifier:(IdentifierBlock)block
{
    dispatch_sync([QTIdentifyGenerator serialQueue],^{
        
        block(_identify);
        
        _identify++;
        
    });
    
}

-(void)reset
{
    dispatch_sync([QTIdentifyGenerator serialQueue], ^{
        _identify = 1;
    });
}
@end
