//
//  NPMatrixUtilities.h
//  CannyDemo
//
//  Created by Hydra on 15/8/9.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrixType.h"


/**************************************************
 
 getIndexOfMatrix
 
 A[1000] -> store -> A[10][100]
 A[getIndexOfMatrix(10,100,x,y)] -> query -> A[y][x]
 
 ***************************************************/



#ifdef DEBUG

#define INDEX_OF_MATRIX(m, x, y)    (assert(y>=0 && y< m->info.matrixHeight && x>=0 && x< m->info.matrixWidth), \
                                    (y) * m->info.matrixWidth + (x))

#else

#define INDEX_OF_MATRIX(m, x, y) (y) * m->info.matrixWidth + (x)

#endif

#define NPMATRIX_GET_TYPE(type, b, m, x, y) b = ((type *) (m->buf))[INDEX_OF_MATRIX(m, x, y)]

#define NPMATRIX_GET(b, m, x, y) \
switch(m->info.type) { \
    case NPCharTypeMatrix: \
        NPMATRIX_GET_TYPE(char, b, m, x, y);\
        break; \
    case NPShortTypeMatrix: \
        NPMATRIX_GET_TYPE(short, b, m, x, y);\
        break; \
    case NPLongTypeMatrix: \
        NPMATRIX_GET_TYPE(long, b, m, x, y);\
        break; \
    case NPUCharTypeMatrix: \
        NPMATRIX_GET_TYPE(unsigned char, b, m, x, y);\
        break; \
    case NPUShortTypeMatrix: \
        NPMATRIX_GET_TYPE(unsigned short, b, m, x, y);\
        break; \
    case NPULongTypeMatrix: \
        NPMATRIX_GET_TYPE(unsigned long, b, m, x, y);\
        break; \
    case NPFloatTypeMatrix: \
        NPMATRIX_GET_TYPE(float, b, m, x, y);\
        break; \
    case NPDoubleTypeMatrix: \
        NPMATRIX_GET_TYPE(double, b, m, x, y);\
        break; \
    case NPLongDoubleTypeMatrix: \
        NPMATRIX_GET_TYPE(long double, b, m, x, y);\
        break; \
    default: \
        assert(NO); \
}

#define NPMATRIX_PUT_TYPE(type, b, m, x, y) ((type *) (m->buf))[INDEX_OF_MATRIX(m, x, y)] = b;

#define NPMATRIX_PUT(b, m, x, y) \
switch(m->info.type) { \
    case NPCharTypeMatrix: \
        NPMATRIX_PUT_TYPE(char, b, m, x, y)\
        break; \
    case NPShortTypeMatrix: \
        NPMATRIX_PUT_TYPE(short, b, m, x, y)\
        break; \
    case NPLongTypeMatrix: \
        NPMATRIX_PUT_TYPE(long, b, m, x, y)\
        break; \
    case NPUCharTypeMatrix: \
        NPMATRIX_PUT_TYPE(unsigned char, b, m, x, y)\
        break; \
    case NPUShortTypeMatrix: \
        NPMATRIX_PUT_TYPE(unsigned short, b, m, x, y)\
        break; \
    case NPULongTypeMatrix: \
        NPMATRIX_PUT_TYPE(unsigned long, b, m, x, y)\
        break; \
    case NPFloatTypeMatrix: \
        NPMATRIX_PUT_TYPE(float, b, m, x, y)\
        break; \
    case NPDoubleTypeMatrix: \
        NPMATRIX_PUT_TYPE(double, b, m, x, y)\
        break; \
    case NPLongDoubleTypeMatrix: \
        NPMATRIX_PUT_TYPE(long double, b, m, x, y)\
        break; \
    default: \
        assert(NO); \
}


BOOL NPMatrixWriteToFile(NPMatrixType *mat, const char *filename);


