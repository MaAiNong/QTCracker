//
//  NPMatrixType.h
//  CannyDemo
//
//  Created by Hydra on 15/8/9.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : unsigned long {
    NPNoTypeMatrix,
    NPUCharTypeMatrix,
    NPCharTypeMatrix,
    NPUShortTypeMatrix,
    NPShortTypeMatrix,
    NPULongTypeMatrix,
    NPLongTypeMatrix,
    NPFloatTypeMatrix,
    NPDoubleTypeMatrix,
    NPLongDoubleTypeMatrix,
    NPMaxTypeMatrix,
} NPMatrixTypeEnum;

struct matrix_head {
    // type aMat[matrixHeight][matrixWidth]
    unsigned long matrixHeight;
    unsigned long matrixWidth;
    NPMatrixTypeEnum type;
};

typedef struct matrix {
    struct matrix_head info;
    void *buf;
} NPMatrixType;

NPMatrixType *NPMatrixCreate (unsigned long matrixHeight,
                        unsigned long matrixWidth,
                        NPMatrixTypeEnum type);

NPMatrixType *NPMatrixCreateFromTemplate(NPMatrixType *sourceMat, NPMatrixType *templateMat);

NPMatrixType *NPMatrixCopy(NPMatrixType *mat);

NPMatrixType *NPMatrixCopyToType(NPMatrixType *mat, NPMatrixTypeEnum type);

void NPMatrixFree(NPMatrixType *mat);

unsigned char typelen(NPMatrixTypeEnum type);

void *NPMatrixGetRawPointer(NPMatrixType *mat, unsigned long x, unsigned long y);

