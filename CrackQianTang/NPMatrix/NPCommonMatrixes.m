//
//  NPCommonMatrixes.m
//  CannyDemo
//
//  Created by Hydra on 15/8/10.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import <math.h>

#import "NPCommonMatrixes.h"
#import "NPMatrixOperate.h"
#import "NPMatrixUtilities.h"


NPMatrixType *NPMatrixCreateZeroMatrix (unsigned long matrixHeight,
                                  unsigned long matrixWidth,
                                  NPMatrixTypeEnum type) {
    
    NPMatrixType *matrix=NPMatrixCreate(matrixHeight, matrixWidth, type);
    if (matrix) {
        bzero(matrix->buf, typelen(type) * matrixHeight * matrixWidth);
    }
    
    return matrix;
}

NPMatrixType *NPMatrixCreateGaussTemplate (unsigned char size, long double sigma) {
    NPMatrixType *matrix=NPMatrixCreate(size, size, NPLongDoubleTypeMatrix);
    if (sigma == 0) {
        sigma=(((long double)size) / 2. - 1) * 0.3 + 0.8;
    }
    
    long double center = (size - 1) / 2.0;
    
    //long double *me=matrix->buf;
    
    for (unsigned long x=0; x<size; x++) {
        long double x2 = powl(x-center, 2);
        for (unsigned long y=0; y<size; y++) {
            long double y2=powl(y-center, 2);
            // me[INDEX_OF_MATRIX(matrix, x, y)]=expl(-( x2 + y2 ) / (2.0 * sigma * sigma));
            
            NPMATRIX_PUT_TYPE(long double, expl(-( x2 + y2 ) / (2.0 * sigma * sigma)) , matrix, x, y);
        }
    }
    
    NPMatrixDotDivLDouble(matrix, NPMatrixSumElementsLDouble(matrix));
    
    return matrix;
}

NPMatrixType *NPMatrixCreateRobertXTemplate () {
    NPMatrixType *matrix=NPMatrixCreate(2, 2, NPCharTypeMatrix);
    if (matrix) {
        NPMATRIX_PUT_TYPE(char, -1, matrix, 0, 0);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 0);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 0, 1);
        NPMATRIX_PUT_TYPE(char, 1, matrix, 1, 1);
    }
    return matrix;
}

NPMatrixType *NPMatrixCreateRobertYTemplate () {
    NPMatrixType *matrix=NPMatrixCreate(2, 2, NPCharTypeMatrix);
    if (matrix) {
        NPMATRIX_PUT_TYPE(char, 0, matrix, 0, 0);
        NPMATRIX_PUT_TYPE(char, -1, matrix, 1, 0);
        NPMATRIX_PUT_TYPE(char, 1, matrix, 0, 1);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 1);
    }
    return matrix;

}

NPMatrixType *NPMatrixCreateSobleYTemplate () {
    NPMatrixType *matrix=NPMatrixCreate(3, 3, NPCharTypeMatrix);
    if (matrix) {
        NPMATRIX_PUT_TYPE(char, 1, matrix, 0, 0);
        NPMATRIX_PUT_TYPE(char, 2, matrix, 1, 0);
        NPMATRIX_PUT_TYPE(char, 1, matrix, 2, 0);
        
        NPMATRIX_PUT_TYPE(char, 0, matrix, 0, 1);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 1);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 2, 1);

        NPMATRIX_PUT_TYPE(char, -1, matrix, 0, 2);
        NPMATRIX_PUT_TYPE(char, -2, matrix, 1, 2);
        NPMATRIX_PUT_TYPE(char, -1, matrix, 2, 2);
    }
    return matrix;

}

NPMatrixType *NPMatrixCreateSobleXTemplate () {
    NPMatrixType *matrix=NPMatrixCreate(3, 3, NPCharTypeMatrix);
    if (matrix) {
        NPMATRIX_PUT_TYPE(char, 1, matrix, 0, 0);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 0);
        NPMATRIX_PUT_TYPE(char, -1, matrix, 2, 0);
        
        NPMATRIX_PUT_TYPE(char, 2, matrix, 0, 1);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 1);
        NPMATRIX_PUT_TYPE(char, -2, matrix, 2, 1);
        
        NPMATRIX_PUT_TYPE(char, 1, matrix, 0, 2);
        NPMATRIX_PUT_TYPE(char, 0, matrix, 1, 2);
        NPMATRIX_PUT_TYPE(char, -1, matrix, 2, 2);
    }
    return matrix;

}

