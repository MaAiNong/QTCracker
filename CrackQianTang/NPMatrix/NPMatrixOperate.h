//
//  NPMatrixOperate.h
//  CannyDemo
//
//  Created by Hydra on 15/8/10.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrixType.h"

typedef enum : unsigned char {
    NPDefaultOrder = 0,
    /**
     for y...
        for x...
     */
    NPXOrderdFirst = 0 << 0,
    
    /**
     for x...
        for y...
     */
    NPYOrderdFirst = 1 << 0,
    
    /**
     for x=0 to max-1...
     */
    NPXAscending = 0 << 1,
    
    /**
     for x=max-1 to 0...
     */
    NPXDecending = 1 << 1,
    
    /**
     for y=0 to max-1...
     */
    NPYAscending = 0 << 2,
    
    /**
     for y=max-1 to 0...
     */
    NPYDecending = 1 << 2,
} NPOrderOptions;

typedef long (*NPLongFuncPtr)(NPMatrixType *self, long element, unsigned long x, unsigned long y, void *param, BOOL *stop);
typedef long double (*NPLDoubleFuncPtr)(NPMatrixType *self, long double element, unsigned long x, unsigned long y, void *param, BOOL *stop);

long double NPMatrixSumElementsLDouble(NPMatrixType *mat);
long NPMatrixSumElementsLong(NPMatrixType *mat);

BOOL NPMatrixDotDivLDouble(NPMatrixType *mat, long double a);
BOOL NPMatrixDotDivLong(NPMatrixType *mat, long a);

BOOL NPMatrixDotMultiplyLDouble(NPMatrixType *mat, long double a);
BOOL NPMatrixDotMultiplyLong(NPMatrixType *mat, long a);

BOOL NPMatrixDotSumLDouble(NPMatrixType *mat, long double a);
BOOL NPMatrixDotSumLong(NPMatrixType *mat, long a);

BOOL NPMatrixDotSubLDouble(NPMatrixType *mat, long double a);
BOOL NPMatrixDotSubLong(NPMatrixType *mat, long a);

BOOL NPMatrixSum(NPMatrixType *mat, NPMatrixType *a);
BOOL NPMatrixSub(NPMatrixType *mat, NPMatrixType *a);

BOOL NPMatrixDotMutiplyMatrix(NPMatrixType *mat, NPMatrixType *a);
BOOL NPMatrixDotDivMatrix(NPMatrixType *mat, NPMatrixType *a);

/*
 mat1 X mat2, using type of mat1
 */
NPMatrixType* NPMatrixCreateByMultiply(NPMatrixType *mat1, NPMatrixType *mat2);
NPMatrixType* NPMatrixCreateByMultiplyUsingType(NPMatrixType *mat1, NPMatrixType *mat2, NPMatrixTypeEnum type);

NPMatrixType* NPMatrixCreateByDiv(NPMatrixType *matNum, NPMatrixType *matDen);

BOOL NPMatrixInv(NPMatrixType *mat);
BOOL NPMatrixTrans(NPMatrixType *mat);

BOOL NPMatrixModifyElementUsingLongTypeFunction(NPMatrixType *mat, NPLongFuncPtr func, void *param, NPOrderOptions options);
BOOL NPMatrixModifyElementUsingLDoubleTypeFunction(NPMatrixType *mat, NPLDoubleFuncPtr func, void *param, NPOrderOptions options);

NPMatrixType* NPMatrixCreateAdjointMatrix(NPMatrixType *mat, unsigned long x, unsigned long y);

long NPMatrixGetLongValueOfDeterminant(NPMatrixType *mat);
long double NPMatrixGetLDoubleValueOfDeterminat(NPMatrixType *mat);

