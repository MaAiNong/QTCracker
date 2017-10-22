//
//  NPMatrix.h
//  CannyDemo
//
//  Created by Hydra on 15/8/11.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NPMatrixType.h"
#import "NPMatrixOperate.h"

/**
 Block used by modifyByUsingIntegerTypeBlock:options: method.
 
 Params:
 element: current element of matrix.
 x, y: current position
 stop: set to YES if you want to stop.
 
 Return value:
 If you want to change the current element, return that number.
 If you don't, return element.
 */
typedef NSInteger (^NPIntegerTypeBlock)(NSInteger element, NSUInteger x, NSUInteger y, BOOL *stop);

/**
 Block used by modifyByUsingDoubleTypeBlock:options: method.
 
 Params:
 element: current element of matrix.
 x, y: current position
 stop: set to YES if you want to stop.
 
 Return value:
 If you want to change the current element, return that number.
 If you don't, return element.
 */
typedef CGFloat (^NPDoubleTypeBlock)(CGFloat element, NSUInteger x, NSUInteger y, BOOL *stop);

@interface NPMatrix : NSObject

/**
 Returns width of the matrix.
 */
@property (readonly, nonatomic) NSUInteger width;

/**
 Returns height of the matrix.
 */
@property (readonly, nonatomic) NSUInteger height;

/**
 Returns bytes of memory used of the matrix;
 */
@property (readonly, nonatomic) NSUInteger bufferSize;

/**
 Returns data type of the matrix.
 e.g. NPUCharTypeMatrix represents a matrix that use unsigned char as its data type.
 */
@property (readonly, nonatomic) NPMatrixTypeEnum type;

/**
 Constructs a matrix of height * width, using type.
 */
+(instancetype)matrixWithType:(NPMatrixTypeEnum)type height:(size_t)height width:(size_t)width;
-(instancetype)initWithType:(NPMatrixTypeEnum)type height:(size_t)height width:(size_t)width;

/**
 Constructs a matrix as a copy of "matrix" param.
 */
+(instancetype)matrixWithMatrix:(NPMatrix *)matrix;
-(instancetype)initWithMatrix:(NPMatrix *)matrix;

/**
 Constructs a matrix using a 2-dimensional array of numbers.
 
 e.g.
 
 NPMatrix *matrix=[NPMatrix matrixWithArrayOfNumbers:@[@[@1, @3, @5], @[@2, @4, @6]]];
 
 This constructs a matrix of:
 
 y x=0 1 2
 
 0 | 1 3 5 |
 
 1 | 2 4 6 |
 
 */
+(instancetype)matrixWithArrayOfArrayOfNumbers:(NSArray *)array type:(NPMatrixTypeEnum)type;
-(instancetype)initWithArrayOfArayOfNumbers:(NSArray *)array type:(NPMatrixTypeEnum)type;

/**
 Returns the element at point (x,y) of the matrix.
 */
-(NSNumber *)elementAtX:(NSUInteger)x Y:(NSUInteger)y;

/**
 Returns the mean element at point (x,y) of the matrix.
 */
-(NSNumber *)meanValueAtX:(NSUInteger)x Y:(NSUInteger)y radius:(NSUInteger)radius;



/**
 Sets the element at point (x,y) of the matrix.
 */
-(void)setNumber:(NSNumber *)number atX:(NSUInteger)x Y:(NSUInteger)y;

/**
 Gets a raw pointer that point to the element at (x,y) of the matrix.
 */
-(void *)getRawPointerAtX:(NSUInteger)x Y:(NSUInteger)y;

@end

@interface NPMatrix (Conversion)
/*
 Methods below is used to converting matrix to a specified type.
 */
-(instancetype)charMatrix;
-(instancetype)shortMatrix;
-(instancetype)longMatrix;
-(instancetype)ucharMatrix;
-(instancetype)ushortMatrix;
-(instancetype)ulongMatrix;
-(instancetype)floatMatrix;
-(instancetype)doubleMatrix;
-(instancetype)longDoubleMatrix;

@end

@interface NPMatrix (CommonMatrixes)

/**
 Constructs a 2-dim normalized gauss matrix with size and sigma. If sigma is given to zero, it'll be automatically calculated.
 */
+(instancetype)gaussMatrixWithSize:(NSUInteger)size sigma:(CGFloat)sigma;

/**
 Constructs a soble matrix of 0 degree.
 */
+(instancetype)sobleMatrixX;
/**
 Constructs a soble matrix of 90 degree.
 */
+(instancetype)sobleMatrixY;

/**
 Constructs a robert matrix of 0 degree.
 */
+(instancetype)robertMatrixX;
/**
 Constructs a robert matrix of 90 degree.
 */
+(instancetype)robertMatrixY;

@end

@interface NPMatrix (Operators)

/**
 Divs a number, returns self.
 
 X=X./a;
 */
-(instancetype)dotDiv:(NSNumber *)a;
/**
 Multiplies a number, returns self.
 
 X=X.*a;
 */
-(instancetype)dotMultiply:(NSNumber *)a;
/**
 Sums a number, returns self.
 
 X=X+a;
 */
-(instancetype)dotSum:(NSNumber *)a;
/**
 Subs a number, returns self.
 
 X=X-a;
 */
-(instancetype)dotSub:(NSNumber *)a;

/**
 Sums a matrix, returns self.
 
 X=X+A;
 */
-(instancetype)matrixSum:(NPMatrix *)A;
/**
 Subs a matrix, returns self.
 
 X=X-A;
 */
-(instancetype)matrixSub:(NPMatrix *)A;

/**
 Dot multiplies a matrix, returns a self.
 
 X=X.*A;
 */
-(instancetype)matrixDotMultiplyMatrix:(NPMatrix *)A;
/**
 Dot divs a matrix, returns a self.
 
 X=X./A;
 */
-(instancetype)matrixDotDivMatrix:(NPMatrix *)A;

/**
 Uses a template matrix.
 
 X=X(*)T;
 */
-(instancetype)useTemplate:(NPMatrix *)T;

/**
 Y=X^-1;
 
 Not implemented yet.
 */
-(instancetype)matrixByInvertMatrix;
/**
 Y=T(X);
 
 Not implemented yet.
 */
-(instancetype)matrixByTransfomMatrix;

/**
 Divs a number, returns a new matrix.
 
 Y=X./a;
 */
-(instancetype)matrixByDotDiv:(NSNumber *)a;
/**
 Multiplies a number, returns a new matrix.
 
 Y=X.*a;
 */
-(instancetype)matrixByDotMultiply:(NSNumber *)a;

/**
 Sums a number, returns a new matrix.
 
 Y=X+a;
 */
-(instancetype)matrixBySum:(NSNumber *)a;

/**
 Subs a number, returns a new matrix.
 
 Y=X-a;
 */
-(instancetype)matrixBySub:(NSNumber *)a;

/**
 Dot divs a matrix, returns a new matrix.
 
 Y=X./A;
 */
-(instancetype)matrixByDotDivMatrix:(NPMatrix *)A;
/**
 Dot multiplies a matrix, returns a new matrix.
 
 Y=X.*A;
 */
-(instancetype)matrixByDotMultiplyMatrix:(NPMatrix *)A;

/**
 Sums a matrix, returns a new matrix.
 
 Y=X+A;
 */
-(instancetype)matrixByMatrixSum:(NPMatrix *)A;
/**
 Subs a matrix, returns a new matrix.
 
 Y=X-A;
 */
-(instancetype)matrixByMatrixSub:(NPMatrix *)A;

/**
 Multiplies a matrix, returns a new matrix.
 
 Y=X*A;
 */
-(instancetype)matrixByMatrixMultiply:(NPMatrix *)A;

/**
 Multiplies a matrix, returns a new matrix, using new type.
 
 Y=X*A;
 */
-(instancetype)matrixByMatrixMultiply:(NPMatrix *)A usingType:(NPMatrixTypeEnum)type;

/**
 Divs a matrix, returns a new matrix.
 
 Y=X/A;
 
 Not implemented yet.
 */
-(instancetype)matrixByMatrixDiv:(NPMatrix *)A;

/**
 Uses template, returns a new matrix.
 
 Y=X(*)T;
 */
-(instancetype)matrixByUsingTemplate:(NPMatrix *)T;

/**
 Enumerate every element, and modifies each if needed, using the integer type block.
 */
-(instancetype)modifyByUsingIntegerTypeBlock:(NPIntegerTypeBlock)block options:(NPOrderOptions)opt;

/**
 Enumerate every element, and modifies each if needed, using the double type block.
 */
-(instancetype)modifyByUsingDoubleTypeBlock:(NPDoubleTypeBlock)block options:(NPOrderOptions)opt;

/**
 Returns number of determinant for the matrix. Matrix must be square.
 */
-(NSNumber *)det;

@end

@interface NPMatrix (Color)

+(NSData *)rgbaDataByCombineMatrixOfRed:(NPMatrix *)r green:(NPMatrix *)g blue:(NPMatrix *)b alpha:(NPMatrix *)a;

+(NSArray *)matrixesOfRGBAFromData:(NSData *)rgba pixelWide:(NSUInteger)width pixelHigh:(NSUInteger)height;
@end

@interface NPMatrix (CommonGraphicOperator)
/**
 Returns a new matrix by using canny operations on matrix with a gauss filter of radius and sigma.
 If radius is zero, canny operates without gauss filter.
 Set sigma to zero if you want a default sigma.
 */
-(instancetype)matrixByCannyOperatorWithGaussRadius:(size_t)radius sigma:(CGFloat)sigma;

@end

