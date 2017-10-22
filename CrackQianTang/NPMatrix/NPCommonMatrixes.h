//
//  NPCommonMatrixes.h
//  CannyDemo
//
//  Created by Hydra on 15/8/10.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPMatrixType.h"

NPMatrixType *NPMatrixCreateZeroMatrix (unsigned long matrixHeight,
                                  unsigned long matrixWidth,
                                  NPMatrixTypeEnum type);

NPMatrixType *NPMatrixCreateGaussTemplate (unsigned char size, long double sigma);

NPMatrixType *NPMatrixCreateRobertXTemplate ();

NPMatrixType *NPMatrixCreateRobertYTemplate ();

NPMatrixType *NPMatrixCreateSobleXTemplate ();

NPMatrixType *NPMatrixCreateSobleYTemplate ();

