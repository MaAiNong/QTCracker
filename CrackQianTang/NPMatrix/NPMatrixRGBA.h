//
//  NPMatrixRGBA.h
//  CannyDemo
//
//  Created by Hydra on 15/8/10.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrixType.h"
typedef struct rgba_map {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
} NPRGBAMap;

bool NPMatrixCreateFromRGBA(const NPRGBAMap *rgba, size_t size_map,
                            unsigned long height, unsigned long width,
                            NPMatrixType **rmat,
                            NPMatrixType **gmat,
                            NPMatrixType **bmat,
                            NPMatrixType **amat);

bool NPMatrixCombineToRGBA(NPRGBAMap *rgba, size_t size_map,
                           NPMatrixType *rmat,
                           NPMatrixType *gmat,
                           NPMatrixType *bmat,
                           NPMatrixType *amat);