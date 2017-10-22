//
//  NPMatrix.m
//  CannyDemo
//
//  Created by Hydra on 15/8/11.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrix.h"
#import "NPMatrixOperate.h"
#import "NPMatrixRGBA.h"
#import "NPMatrixUtilities.h"
#import "NPCommonMatrixes.h"
#import "NPCannyOperator.h"

@interface NPMatrix () {
    NPMatrixType *_matrix;
}
@end

@implementation NPMatrix

@dynamic width,height,type,bufferSize;

-(instancetype)init {
    self=[super init];
    if (self) {
        _matrix = NULL;
    }
    return self;
}

+(instancetype)matrixWithType:(NPMatrixTypeEnum)type height:(size_t)height width:(size_t)width {
    return [[self alloc]initWithType:type height:height width:width];
}
-(instancetype)initWithType:(NPMatrixTypeEnum)type height:(size_t)height width:(size_t)width {
    self = [super init];
    if (self) {
        _matrix = NPMatrixCreateZeroMatrix(height, width, type);
    }
    return self;
}

+(instancetype)matrixWithMatrix:(NPMatrix *)matrix {
    return [[self alloc]initWithMatrix:matrix];
}

-(instancetype)initWithMatrix:(NPMatrix *)matrix {
    self = [super init];
    if (self) {
        _matrix=NPMatrixCopy(matrix->_matrix);
    }
    return self;
}

+(instancetype)matrixWithArrayOfArrayOfNumbers:(NSArray *)array type:(NPMatrixTypeEnum)type {
    return [[self alloc]initWithArrayOfArayOfNumbers:array type:type];
}

-(instancetype)initWithArrayOfArayOfNumbers:(NSArray *)array type:(NPMatrixTypeEnum)type {
    NSUInteger height=[array count];
    if (height==0) {
        return nil;
    }
    NSUInteger width;
    if ([[array firstObject] isKindOfClass:[NSArray class]]==NO) {
        [NSException raise:@"NPArrayTypeError" format:@"Array shall be array of array of numbers"];
        return nil;
    }
    
    width=[[array firstObject] count];
    for (NSArray *numbers in array) {
        if ([numbers isKindOfClass:[NSArray class]]==NO) {
            [NSException raise:@"NPArrayTypeError" format:@"Array shall be array of array of numbers"];
            return nil;
        }
        if ([numbers count]!=width) {
            [NSException raise:@"NPArrayTypeError" format:@"Each row should contain same amount of numbers"];
            return nil;
        }
    }
    self = [self initWithType:type height:height width:width];
    if (self) {
        for (NSUInteger y=0; y<height; y++) {
            for (NSUInteger x=0; x<width; x++) {
                [self setNumber:array[y][x] atX:x Y:y];
            }
        }
    }
    
    return self;

}

#define NSNUM_GET(type, sel, nsnum, m, x, y) { \
    type c; \
    NPMATRIX_GET_TYPE(type, c, m, x, y); \
    nsnum=[NSNumber sel:c]; \
}

-(NSNumber *)meanValueAtX:(NSUInteger)x Y:(NSUInteger)y radius:(NSUInteger)radius
{
    NSUInteger count = 0;
    NSUInteger sum = 0;
    for (NSUInteger i = x-radius; i<= x+radius ; i++) {
        NSNumber* num = [self elementAtX:i Y:y];
        if (num) {
            sum+=[num unsignedCharValue];
            count++;
        }
    }
    
    for (NSUInteger i = y-radius; i<=y+radius; i++) {
        NSNumber* num = [self elementAtX:x Y:i];
        if (num) {
            sum+=[num unsignedCharValue];
            count++;
        }
    }
    
    return [NSNumber numberWithUnsignedChar:(sum/count)];
}

-(NSNumber *)elementAtX:(NSUInteger)x Y:(NSUInteger)y {
    if (_matrix == NULL) {
        return nil;
    }
    
    if (x>=_matrix->info.matrixWidth || y>=_matrix->info.matrixHeight) {
        [NSException raise:@"NPOutOfBounds" format:@"Position out of matrix bounds."];
        return nil;
    }
    
    NSNumber *num=nil;
    switch (_matrix->info.type) {
        case NPCharTypeMatrix:
            NSNUM_GET(char, numberWithChar, num, _matrix, x, y);
            break;
        case NPShortTypeMatrix:
            NSNUM_GET(short, numberWithShort, num, _matrix, x, y);
            break;
        case NPLongTypeMatrix:
            NSNUM_GET(long, numberWithLong, num, _matrix, x, y);
            break;
        case NPUCharTypeMatrix:
            NSNUM_GET(unsigned char, numberWithUnsignedChar, num, _matrix, x, y);
            break;
        case NPUShortTypeMatrix:
            NSNUM_GET(unsigned short, numberWithUnsignedShort, num, _matrix, x, y);
            break;
        case NPULongTypeMatrix:
            NSNUM_GET(unsigned long, numberWithUnsignedLong, num, _matrix, x, y);
            break;
        case NPFloatTypeMatrix:
            NSNUM_GET(float, numberWithFloat, num, _matrix, x, y);
            break;
        case NPDoubleTypeMatrix:
            NSNUM_GET(double, numberWithDouble, num, _matrix, x, y);
            break;
        case NPLongDoubleTypeMatrix:
            NSNUM_GET(long double, numberWithDouble, num, _matrix, x, y);
            break;
        default:
            break;
    }
    
    return num;
}

-(void *)getRawPointerAtX:(NSUInteger)x Y:(NSUInteger)y {
    return NPMatrixGetRawPointer(_matrix, x, y);
}

#define NSNUM_SET(type, sel, nsnum, m, x, y) { \
    type c = [nsnum sel]; \
    NPMATRIX_PUT_TYPE(type, c, m, x, y); \
}
-(void)setNumber:(NSNumber *)number atX:(NSUInteger)x Y:(NSUInteger)y {
    if (_matrix == NULL) {
        return;
    }
    
    if (x>=_matrix->info.matrixWidth || y>=_matrix->info.matrixHeight) {
        [NSException raise:@"NPOutOfBounds" format:@"Position out of matrix bounds."];
    }
    
    switch (_matrix->info.type) {
        case NPCharTypeMatrix:
            NSNUM_SET(char, charValue, number, _matrix, x, y);
            break;
        case NPShortTypeMatrix:
            NSNUM_SET(short, shortValue, number, _matrix, x, y);
            break;
        case NPLongTypeMatrix:
            NSNUM_SET(long, longValue, number, _matrix, x, y);
            break;
        case NPUCharTypeMatrix:
            NSNUM_SET(unsigned char, unsignedCharValue, number, _matrix, x, y);
            break;
        case NPUShortTypeMatrix:
            NSNUM_SET(unsigned short, unsignedShortValue, number, _matrix, x, y);
            break;
        case NPULongTypeMatrix:
            NSNUM_SET(unsigned long, unsignedLongValue, number, _matrix, x, y);
            break;
        case NPFloatTypeMatrix:
            NSNUM_SET(float, floatValue, number, _matrix, x, y);
            break;
        case NPDoubleTypeMatrix:
            NSNUM_SET(double, doubleValue, number, _matrix, x, y);
            break;
        case NPLongDoubleTypeMatrix:
            NSNUM_SET(long double, doubleValue, number, _matrix, x, y);
            break;
        default:
            break;
    }

}

-(NSUInteger)width {
    if (_matrix) {
        return _matrix->info.matrixWidth;
    }
    return 0;
}

-(NSUInteger)height {
    if (_matrix) {
        return _matrix->info.matrixHeight;
    }
    return 0;
}

-(NPMatrixTypeEnum)type {
    if (_matrix) {
        return _matrix->info.type;
    }
    return 0;
}

-(NSUInteger)bufferSize {
    if (_matrix) {
        return _matrix->info.matrixHeight * _matrix->info.matrixWidth * typelen(_matrix->info.type);
    }
    return 0;
}

-(void)dealloc {
    if (_matrix) {
        NPMatrixFree(_matrix);
    }
    
#ifdef DEBUG
    NSLog(@"dealloc");
#endif
}

#ifdef DEBUG
+(instancetype)alloc{
    NSLog(@"alloc");
    return [super alloc];
}

#endif

@end

@implementation NPMatrix (Conversion)

#define CHECK_NULL(m) \
if (m==NULL) return nil

-(instancetype)charMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPCharTypeMatrix);
    return matrix;
}

-(instancetype)shortMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPShortTypeMatrix);
    return matrix;

}

-(instancetype)longMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPLongTypeMatrix);
    return matrix;
}

-(instancetype)ucharMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPUCharTypeMatrix);
    return matrix;
}

-(instancetype)ushortMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPUShortTypeMatrix);
    return matrix;
}

-(instancetype)ulongMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPULongTypeMatrix);
    return matrix;
}

-(instancetype)floatMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPFloatTypeMatrix);
    return matrix;
}

-(instancetype)doubleMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPDoubleTypeMatrix);
    return matrix;
}

-(instancetype)longDoubleMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class] alloc] init];
    matrix->_matrix=NPMatrixCopyToType(_matrix, NPLongDoubleTypeMatrix);
    return matrix;
}


@end

@implementation NPMatrix (CommonMatrixes)

+(instancetype)gaussMatrixWithSize:(NSUInteger)size sigma:(CGFloat)sigma {
    NPMatrix *matrix=[[self alloc]init];
    matrix->_matrix = NPMatrixCreateGaussTemplate(size, sigma);
    return matrix;
}

+(instancetype)sobleMatrixX {
    NPMatrix *matrix=[[self alloc]init];
    matrix->_matrix = NPMatrixCreateSobleXTemplate();
    return matrix;
}

+(instancetype)sobleMatrixY {
    NPMatrix *matrix=[[self alloc]init];
    matrix->_matrix = NPMatrixCreateSobleYTemplate();
    return matrix;
}

+(instancetype)robertMatrixX {
    NPMatrix *matrix=[[self alloc]init];
    matrix->_matrix = NPMatrixCreateRobertXTemplate();
    return matrix;
}

+(instancetype)robertMatrixY {
    NPMatrix *matrix=[[self alloc]init];
    matrix->_matrix = NPMatrixCreateRobertYTemplate();
    return matrix;
}

@end


long long_operation(NPMatrixType *mat, long element, unsigned long x, unsigned long y, void *ptr, BOOL *stop) {
    NPIntegerTypeBlock block=(__bridge NPIntegerTypeBlock)ptr;
    return block(element, x, y, stop);
}

long double double_operation(NPMatrixType *mat, long double element, unsigned long x, unsigned long y, void *ptr, BOOL *stop) {
    NPDoubleTypeBlock block=(__bridge NPDoubleTypeBlock)ptr;
    return block(element, x, y, stop);
}

@implementation NPMatrix (Operators)

#define CHECK_NULL_RET_BOOL(m) \
if (m==NULL) return NO

-(instancetype)dotDiv:(NSNumber *)a {
    CHECK_NULL(_matrix);
    switch (*a.objCType) {
        case 'c':
        case 's':
        case 'i':
        case 'q':
        case 'l':
            if (NPMatrixDotDivLong(_matrix, [a longValue]))
                return self;
           
            return nil;
            
        case 'f':
        case 'd':
            if (NPMatrixDotDivLDouble(_matrix, [a doubleValue]))
                return self;
            
            return nil;
            
        default:
            [NSException raise:@"NPNumberTypeError" format:@"Unknown NSNumber type."];
            return nil;
    }
}

-(instancetype)dotMultiply:(NSNumber *)a {
    CHECK_NULL(_matrix);
    switch (*a.objCType) {
        case 'c':
        case 's':
        case 'i':
        case 'q':
        case 'l':
            if (NPMatrixDotMultiplyLong(_matrix, [a longValue]))
                return self;
            
            return nil;
            
        case 'f':
        case 'd':
            if (NPMatrixDotMultiplyLDouble(_matrix, [a doubleValue]))
                return self;
            
            return nil;
        default:
            [NSException raise:@"NPNumberTypeError" format:@"Unknown NSNumber type."];
            return nil;
            
    }

}
-(instancetype)dotSum:(NSNumber *)a {
    CHECK_NULL(_matrix);
    switch (*a.objCType) {
        case 'c':
        case 's':
        case 'i':
        case 'q':
        case 'l':
            if (NPMatrixDotSumLong(_matrix, [a longValue]))
                return self;
            
            return nil;
            
        case 'f':
        case 'd':
            if (NPMatrixDotSumLDouble(_matrix, [a doubleValue]))
                return self;
            
            return nil;
        default:
            [NSException raise:@"NPNumberTypeError" format:@"Unknown NSNumber type."];
            return nil;
            
    }

}
-(instancetype)dotSub:(NSNumber *)a {
    CHECK_NULL(_matrix);
    switch (*a.objCType) {
        case 'c':
        case 's':
        case 'i':
        case 'q':
        case 'l':
            if (NPMatrixDotSubLong(_matrix, [a longValue])) {
                return self ;
            }
            return nil;
            
        case 'f':
        case 'd':
            if ( NPMatrixDotSubLDouble(_matrix, [a doubleValue])) {
                return self;
            }
            return nil;
            
        default:
            [NSException raise:@"NPNumberTypeError" format:@"Unknown NSNumber type."];
            return nil;
            
    }

}

-(instancetype)matrixSum:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    if (NPMatrixSum(_matrix, A->_matrix))
        return self;
    
    return nil;
}

-(instancetype)matrixSub:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    if (NPMatrixSub(_matrix, A->_matrix))
        return self;
    
    return nil;
}

-(instancetype)matrixDotMultiplyMatrix:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    if (NPMatrixDotMutiplyMatrix(_matrix, A->_matrix))
        return self;
    
    return nil;
}

-(instancetype)matrixDotDivMatrix:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    if (NPMatrixDotDivMatrix(_matrix, A->_matrix))
        return self;
    
    return nil;
}

-(instancetype)useTemplate:(NPMatrix *)t {
    NPMatrixType *matrixtype=NPMatrixCreateFromTemplate(_matrix, t->_matrix);
    if (matrixtype==NULL) {
        return nil;
    }
    NPMatrixFree(_matrix);
    _matrix=matrixtype;
    return self;
}

#pragma mark Not impelemented yet..
-(instancetype)matrixByInvertMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class]alloc]init];
    if (matrix) {
        NPMatrixType *mat=NPMatrixCopy(_matrix);
        if (NPMatrixInv(mat)==NO) {
            NPMatrixFree(mat);
            return nil;
        }
        
        matrix->_matrix=mat;
    }
    
    return matrix;

}
-(instancetype)matrixByTransfomMatrix {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class]alloc]init];
    if (matrix) {
        NPMatrixType *mat=NPMatrixCopy(_matrix);
        if (NPMatrixTrans(mat)==NO) {
            NPMatrixFree(mat);
            return nil;
        }
        
        matrix->_matrix=mat;
    }
    
    return matrix;
}

-(instancetype)matrixByDotDiv:(NSNumber *)a {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix dotDiv:a];
    }
    return matrix;
}

-(instancetype)matrixByDotMultiply:(NSNumber *)a {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix dotMultiply:a];
    }
    return matrix;
}
-(instancetype)matrixBySum:(NSNumber *)a {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix dotSum:a];
    }
    return matrix;
}

-(instancetype)matrixBySub:(NSNumber *)a {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix dotSub:a];
    }
    return matrix;
}

-(instancetype)matrixByDotMultiplyMatrix:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix matrixDotMultiplyMatrix:A];
    }
    return matrix;
}

-(instancetype)matrixByDotDivMatrix:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        [matrix matrixDotDivMatrix:A];
    }
    return matrix;

}

-(instancetype)matrixByMatrixSum:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        if ([matrix matrixSum:A]==NO) {
            return nil;
        }
    }
    return matrix;
}
-(instancetype)matrixByMatrixSub:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    NPMatrix *matrix = [NPMatrix matrixWithMatrix:self];
    if (matrix) {
        if ([matrix matrixSub:A]==NO) {
            return nil;
        }
    }
    return matrix;
}

#pragma mark Not implemented yet...
-(instancetype)matrixByMatrixMultiply:(NPMatrix *)A {
    return [self matrixByMatrixMultiply:A usingType:self.type];
}

-(instancetype)matrixByMatrixMultiply:(NPMatrix *)A usingType:(NPMatrixTypeEnum)type {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class]alloc]init];
    if (matrix) {
        matrix->_matrix = NPMatrixCreateByMultiplyUsingType(_matrix, A->_matrix, type);
        if (matrix->_matrix==NULL) {
            return nil;
        }
    }
    
    return matrix;
}

-(instancetype)matrixByMatrixDiv:(NPMatrix *)A {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class]alloc]init];
    if (matrix) {
        matrix->_matrix = NPMatrixCreateByDiv(_matrix, A->_matrix);
        if (matrix->_matrix==NULL) {
            return nil;
        }
    }
    
    return matrix;
}

-(instancetype)matrixByUsingTemplate:(NPMatrix *)t {
    CHECK_NULL(_matrix);
    NPMatrix *matrix=[[[self class]alloc]init];
    matrix->_matrix = NPMatrixCreateFromTemplate(_matrix, t->_matrix);
    return matrix;
}

-(instancetype)modifyByUsingIntegerTypeBlock:(NPIntegerTypeBlock)block options:(NPOrderOptions)opt{
    CHECK_NULL(_matrix);
    if (NPMatrixModifyElementUsingLongTypeFunction(_matrix, long_operation, (__bridge void *)block, opt)) {
        return self;
    }
    
    return nil;
}

-(instancetype)modifyByUsingDoubleTypeBlock:(NPDoubleTypeBlock)block options:(NPOrderOptions)opt{
    CHECK_NULL(_matrix);
    if (NPMatrixModifyElementUsingLDoubleTypeFunction(_matrix, double_operation, (__bridge void *)block, opt)) {
        return self;
    }
    
    return nil;
}

-(NSNumber *)det {
    CHECK_NULL(_matrix);
    if (self.width != self.height) {
        [NSException raise:@"NPMatrixSizeError" format:@"Matrix should be a square."];
        return nil;
    }
    
    NSNumber *num=nil;
    switch (self.type) {
        case NPCharTypeMatrix:
        case NPShortTypeMatrix:
        case NPLongTypeMatrix:
        case NPUCharTypeMatrix:
        case NPUShortTypeMatrix:
        case NPULongTypeMatrix:
            num = [NSNumber numberWithLong:NPMatrixGetLongValueOfDeterminant(_matrix)];
            break;
            
        case NPFloatTypeMatrix:
        case NPDoubleTypeMatrix:
        case NPLongDoubleTypeMatrix:
            num = [NSNumber numberWithDouble:NPMatrixGetLDoubleValueOfDeterminat(_matrix)];
            
        default:
            break;
    }
    
    return num;
}

@end

@implementation NPMatrix (Color)

+(NSData *)rgbaDataByCombineMatrixOfRed:(NPMatrix *)r
                                  green:(NPMatrix *)g
                                   blue:(NPMatrix *)b
                                  alpha:(NPMatrix *)a {
    size_t memsize=r.width*r.height*4;
    
    if (memsize==0) {
        return nil;
    }
    
    NPRGBAMap *rgba=malloc(memsize);
    
    if (rgba==NULL) {
        return nil;
    }
    
    if (NPMatrixCombineToRGBA(rgba, memsize, r->_matrix, g->_matrix, b->_matrix, a->_matrix) ==NO) {
        free(rgba);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:rgba length:memsize];
}

+(NSArray *)matrixesOfRGBAFromData:(NSData *)rgba
                         pixelWide:(NSUInteger)width
                         pixelHigh:(NSUInteger)height {
    NPMatrix *rmat=[[NPMatrix alloc]init];
    NPMatrix *gmat=[[NPMatrix alloc]init];
    NPMatrix *bmat=[[NPMatrix alloc]init];
    NPMatrix *amat=[[NPMatrix alloc]init];
    NSArray *array=@[rmat, gmat, bmat, amat];
    
    if (NPMatrixCreateFromRGBA([rgba bytes], [rgba length],
                               height, width,
                               &rmat->_matrix, &gmat->_matrix,
                               &bmat->_matrix, &amat->_matrix) ==NO) {
        return nil;
    }
    
    return array;
}
@end

@implementation NPMatrix (CommonGraphicOperator)

-(instancetype)matrixByCannyOperatorWithGaussRadius:(size_t)radius sigma:(CGFloat)sigma {
    CHECK_NULL(_matrix);
    NPMatrixType *matrix=NPMatrixCreateByUsingCannyOperator(_matrix, radius, sigma);
    if (matrix) {
        NPMatrix *mat=[[NPMatrix alloc]init];
        if (mat) {
            mat->_matrix=matrix;
        }
        return mat;
    }
    
    return nil;
}

@end


