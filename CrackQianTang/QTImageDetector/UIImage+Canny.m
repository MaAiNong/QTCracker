//
//  UIImage+Canny.m
//  CannyDemo
//
//  Created by Hydra on 15/8/16.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "UIImage+Canny.h"
#import "QTPixels2Elements.h"


@implementation UIImage (Canny)

-(instancetype)cannyImageWithGaussFilter:(size_t)size sigma:(CGFloat)sigma {
    CGImageRef inputCGImage = [self CGImage];
    NSUInteger width =  CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width,     sizeof(UInt32));
    

    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context =     CGBitmapContextCreate(pixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    

    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
    

    CGColorSpaceRelease(colorSpace);
    
    NSData *data=[NSData dataWithBytesNoCopy:pixels length:height*width*sizeof(UInt32)];
    NPMatrix *rmat,*gmat,*bmat,*amat;
    NSArray *array=[NPMatrix matrixesOfRGBAFromData:data pixelWide:width pixelHigh:height];
    rmat=array[0];
    gmat=array[1];
    bmat=array[2];
    amat=array[3];
    
    NPMatrix *grey=[[[rmat dotMultiply:@0.299] matrixSum:[gmat dotMultiply:@0.587]] matrixSum:[bmat dotMultiply:@0.114]];
    
    grey=[grey matrixByCannyOperatorWithGaussRadius:size sigma:sigma];
    
    data=[NPMatrix rgbaDataByCombineMatrixOfRed:grey green:grey blue:grey alpha:amat];
    memcpy(pixels, [data bytes], [data length]);
    
    CGImageRef cgimage=CGBitmapContextCreateImage(context);
    
    UIImage *img = [UIImage imageWithCGImage:cgimage];
    
    CGImageRelease(cgimage);
    CGContextRelease(context);
    
    return img;
    
}

-(NPMatrix *)cannyMatrixWithGaussFilter:(size_t)size sigma:(CGFloat)sigma {
    CGImageRef inputCGImage = [self CGImage];
    NSUInteger width =  CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width,     sizeof(UInt32));
    
    
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context =     CGBitmapContextCreate(pixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
    
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    NSData *data=[NSData dataWithBytesNoCopy:pixels length:height*width*sizeof(UInt32)];
    NPMatrix *rmat,*gmat,*bmat,*amat;
    NSArray *array=[NPMatrix matrixesOfRGBAFromData:data pixelWide:width pixelHigh:height];
    rmat=array[0];
    gmat=array[1];
    bmat=array[2];
    amat=array[3];
    
    NPMatrix *grey=[[[rmat dotMultiply:@0.299] matrixSum:[gmat dotMultiply:@0.587]] matrixSum:[bmat dotMultiply:@0.114]];
    
    grey=[grey matrixByCannyOperatorWithGaussRadius:size sigma:sigma];
    
    
    return grey;

}

-(NSArray<NPMatrix*>*)imagePixels;
{
    CGImageRef inputCGImage = [self CGImage];
    NSUInteger width =  CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width,     sizeof(UInt32));
    
    
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context =     CGBitmapContextCreate(pixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
    
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    NSData *data=[NSData dataWithBytesNoCopy:pixels length:height*width*sizeof(UInt32)];
    NPMatrix *rmat,*gmat,*bmat,*amat;
    NSArray *array=[NPMatrix matrixesOfRGBAFromData:data pixelWide:width pixelHigh:height];
    rmat=array[0];
    gmat=array[1];
    bmat=array[2];
    amat=array[3];
    
    return array;
}

-(QTGameMap*)QTGameMap
{
    QTGameMap* map = nil;
    
    NSArray* array = [QTPixels2Elements getQTElementsByPiexls:[self imagePixels]];
    
    if (array&&array.count>0) {
        map = [[QTGameMap alloc] init];
        [map insertArray:array];
    }
    return map;
}
@end
