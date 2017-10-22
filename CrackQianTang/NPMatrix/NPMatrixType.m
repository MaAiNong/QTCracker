//
//  NPMatrixType.m
//  CannyDemo
//
//  Created by Hydra on 15/8/9.
//  Copyright (c) 2015å¹?Hydra. All rights reserved.
//

#import "NPMatrixUtilities.h"
#import "NPMatrixType.h"

//inline unsigned char typelen(NPMatrixTypeEnum type);

unsigned char typelen(NPMatrixTypeEnum type) {
    unsigned char elesize=0;
    
    switch (type) {
            
        case NPUCharTypeMatrix:
        case NPCharTypeMatrix:
            elesize=sizeof(char);
            break;
            
        case NPUShortTypeMatrix:
        case NPShortTypeMatrix:
            elesize=sizeof(short);
            break;
        
        case NPULongTypeMatrix:
        case NPLongTypeMatrix:
            elesize=sizeof(long);
            break;
            
        case NPFloatTypeMatrix:
            elesize=sizeof(float);
            break;
            
        case NPDoubleTypeMatrix:
            elesize=sizeof(double);
            break;
            
        case NPLongDoubleTypeMatrix:
            elesize=sizeof(long double);
            break;
            
        default:
            return 0;
    }
    
    return elesize;
}

NPMatrixType *NPMatrixCreate (unsigned long matrixHeight,
                              unsigned long matrixWidth,
                              NPMatrixTypeEnum type) {
    
    if (matrixWidth*matrixHeight==0) {
        return NULL;
    }
    
    unsigned char elesize=typelen(type);
    if (elesize==0) {
        return NULL;
    }
    
    NPMatrixType *matrix=malloc(sizeof(NPMatrixType));
    
    matrix->info.type=type;
    matrix->info.matrixWidth=matrixWidth;
    matrix->info.matrixHeight=matrixHeight;
    matrix->buf=malloc(matrixHeight * matrixWidth * elesize);
    
    if (matrix->buf == NULL) {
        free(matrix);
        return NULL;
    }
    
    return matrix;
}

NPMatrixType *NPMatrixCopy(NPMatrixType *mat) {
    if (mat==NULL) {
        return NULL;
    }
    
    unsigned char elesize=typelen(mat->info.type);
    if (elesize==0) {
        return NULL;
    }
    
    NPMatrixType *matrix=NPMatrixCreate(mat->info.matrixHeight, mat->info.matrixWidth, mat->info.type);
    
    if (matrix) {
        unsigned long bufsize=mat->info.matrixWidth * mat->info.matrixHeight * typelen(mat->info.type);
        memcpy(matrix->buf, mat->buf, bufsize);
    }

    return matrix;
    
}

#define COPY_MATRIX_TYPE_D_S(typed, types, d, s) { \
    typed *matd=d->buf; \
    types *mats=s->buf; \
    for (unsigned long index=0; index<(d->info.matrixWidth * d->info.matrixHeight); index++) \
        matd[index]=mats[index]; \
}

#define COPY_MATRIX_TYPE_S(types, d, s) { \
    switch(d->info.type) { \
        case NPCharTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(char, types, d, s); \
            break; \
        case NPUCharTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(unsigned char, types, d, s); \
            break; \
        case NPShortTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(short, types, d, s); \
            break; \
        case NPUShortTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(unsigned short, types, d, s); \
            break; \
        case NPLongTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(long, types, d, s); \
            break; \
        case NPULongTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(unsigned long, types, d, s); \
            break; \
        case NPFloatTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(float, types, d, s); \
            break; \
        case NPDoubleTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(double, types, d, s); \
            break; \
        case NPLongDoubleTypeMatrix: \
            COPY_MATRIX_TYPE_D_S(long double, types, d, s); \
            break; \
        default: \
            assert(NO); \
    } \
}

#define COPY_MATRIX(d, s)  \
    switch(s->info.type) { \
        case NPCharTypeMatrix: \
            COPY_MATRIX_TYPE_S(char, d, s); \
            break; \
        case NPUCharTypeMatrix: \
            COPY_MATRIX_TYPE_S(unsigned char, d, s); \
            break; \
        case NPShortTypeMatrix: \
            COPY_MATRIX_TYPE_S(short, d, s); \
            break; \
        case NPUShortTypeMatrix: \
            COPY_MATRIX_TYPE_S(unsigned short, d, s); \
            break; \
        case NPLongTypeMatrix: \
            COPY_MATRIX_TYPE_S(long, d, s); \
            break; \
        case NPULongTypeMatrix: \
            COPY_MATRIX_TYPE_S(unsigned long, d, s); \
            break; \
        case NPFloatTypeMatrix: \
            COPY_MATRIX_TYPE_S(float, d, s); \
            break; \
        case NPDoubleTypeMatrix: \
            COPY_MATRIX_TYPE_S(double, d, s); \
            break; \
        case NPLongDoubleTypeMatrix: \
            COPY_MATRIX_TYPE_S(long double, d, s); \
            break; \
        default: \
            assert(NO); \
    }


NPMatrixType *NPMatrixCopyToType(NPMatrixType *mat, NPMatrixTypeEnum type) {
    if (mat==NULL) {
        return NULL;
    }
    
    if (typelen(mat->info.type)==0) {
        return NULL;
    }
    
    NPMatrixType *matrix=NPMatrixCreate(mat->info.matrixHeight, mat->info.matrixWidth, type);
    if (matrix == NULL) {
        return NULL;
    }
    
    
    COPY_MATRIX(matrix, mat);
    
    return matrix;
}

void NPMatrixFree(NPMatrixType *mat) {
    if (mat==NULL) {
        return;
    }
    
    free(mat->buf);
    free(mat);
}

void *NPMatrixGetRawPointer(NPMatrixType *mat, unsigned long x, unsigned long y) {
    
    if (mat==NULL) {
        return NULL;
    }
    
    switch (mat->info.type) {
        case NPCharTypeMatrix:
        case NPUCharTypeMatrix:
        {
            char *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        case NPShortTypeMatrix:
        case NPUShortTypeMatrix:
        {
            short *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        case NPLongTypeMatrix:
        case NPULongTypeMatrix:
        {
            long *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        case NPFloatTypeMatrix:
        {
            float *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        case NPDoubleTypeMatrix:
        {
            double *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        case NPLongDoubleTypeMatrix:
        {
            long double *ptr=mat->buf;
            return ptr+INDEX_OF_MATRIX(mat, x, y);
        }
            break;
            
        default:
            return NULL;
    }
}


