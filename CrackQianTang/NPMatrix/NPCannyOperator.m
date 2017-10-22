//
//  CannyCalc.m
//  CannyDemo
//
//  Created by Hydra on 15/8/9.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrixType.h"
#import "NPMatrixOperate.h"
#import "NPCommonMatrixes.h"
#import "NPMatrixUtilities.h"
#import "NPCommonAlgorithm.h"
#import "NPCannyOperator.h"

#import <math.h>

long sqrtself(NPMatrixType *self, long element, unsigned long x, unsigned long y, void *param, BOOL *stop) {
    return (long)sqrtl(element);
}

//  Non-Maximum Suppression
long nms(NPMatrixType *self, long element, unsigned long x, unsigned long y, void *param, BOOL *stop) {
    NPMatrixType **mats = (NPMatrixType **)param;
    
    NPMatrixType *gradAbs=mats[0];
    NPMatrixType *gradX=mats[1];
    NPMatrixType *gradY=mats[2];
    
    // Get rid of edge points.
    if (x==0 || y==0 || x==self->info.matrixWidth-1 || y==self->info.matrixHeight-1) {
        return 0;
    }
    
    long front, behind, e, dx, dy;
    
    NPMATRIX_GET_TYPE(long, e, gradAbs, x, y);
    NPMATRIX_GET_TYPE(long, dx, gradX, x, y);
    NPMATRIX_GET_TYPE(long, dy, gradY, x, y);
    if (dx==dy && dx==0) {
        return 0;
    }
    
    if (labs(dx)>labs(dy)) {
        long l,r,l1,r1;
        NPMATRIX_GET_TYPE(long, l, gradAbs, x-1, y);
        NPMATRIX_GET_TYPE(long, r, gradAbs, x+1, y);
        
        if (dx*dy>0) {
            NPMATRIX_GET_TYPE(long, l1, gradAbs, x-1, y-1);
            NPMATRIX_GET_TYPE(long, r1, gradAbs, x+1, y+1);
        } else {
            NPMATRIX_GET_TYPE(long, l1, gradAbs, x-1, y+1);
            NPMATRIX_GET_TYPE(long, r1, gradAbs, x+1, y-1);
        }
        
        front = l + (l1-l) * labs(dy) / labs(dx);
        behind = r + (r1-r) * labs(dy) / labs(dx);
        
    } else {
        long u,d, u1, d1;
        NPMATRIX_GET_TYPE(long, u, gradAbs, x, y-1);
        NPMATRIX_GET_TYPE(long, d, gradAbs, x, y+1);
        
        if (dx*dy>0) {
            NPMATRIX_GET_TYPE(long, u1, gradAbs, x-1, y-1);
            NPMATRIX_GET_TYPE(long, d1, gradAbs, x+1, y+1);
        } else {
            NPMATRIX_GET_TYPE(long, u1, gradAbs, x+1, y-1);
            NPMATRIX_GET_TYPE(long, d1, gradAbs, x-1, y+1);
        }
        
        front = u + (u1 - u) * labs(dx) / labs(dy);
        behind = d + (d1-d) *labs(dx) / labs(dy);
    }

    return (e > front && e >= behind) ? e : 0;
    
}

void select_threshold(NPMatrixType *mat, long *min_thresh, long *max_thresh) {
    //hist
    unsigned long max=512;
    unsigned long *hist = calloc(sizeof(long), max);
    bzero(hist, 256 * sizeof(long));
    
    for (unsigned long y=0; y<mat->info.matrixHeight; y++) {
        for (unsigned long x=0; x<mat->info.matrixWidth; x++) {
            long e;
            NPMATRIX_GET_TYPE(long, e, mat, x, y);
            if (e<0) {
#ifdef DEBUG
                assert(false);
#endif
                e=0;
            }
            
            // expand if needed
            while (e>=max) {
                unsigned long *hist_expand = calloc(sizeof(long), max * 2);
                memcpy(hist_expand, hist, max * sizeof(long));
                bzero(hist_expand + max, max * sizeof(long));
                free(hist);
                hist = hist_expand;
                max *= 2;
            }
            
            hist[e]++;
        }
    }
    
    // CDF
    for (unsigned long i=2; i<max; i++) {
        hist[i]+=hist[i-1];
    }
    
    
#ifdef DEBUG
    assert(hist[0] + hist[max-1]==mat->info.matrixWidth * mat->info.matrixHeight);
#endif
    
    // select th
    unsigned long maxTh=0, minTh=0;
    for (long i=1; i<max; i++) {
        if (hist[i]*100/hist[max-1] >= 79) {
            maxTh=i;
            break;
        }
    }
    
    minTh=maxTh * 0.4;
    
    // special considerations...
    if (maxTh == 0) {
        maxTh = 2;
    }
    
    if (minTh == 0) {
        minTh = 1;
    }
    
    /*minTh=1;
     maxTh=2;*/
    
    free(hist);
    
    *max_thresh=maxTh;
    *min_thresh=minTh;

}

#define CHECK_SUCCESS(s, l) if (!s) goto l

NPMatrixType* NPMatrixCreateByUsingCannyOperator(NPMatrixType *mat, size_t gauss_radius, long double sigma) {
    
    
    NPMatrixType *lmat=NPMatrixCopyToType(mat, NPLongTypeMatrix);
    
    NPMatrixType *gauss = gauss_radius ? NPMatrixCreateGaussTemplate(gauss_radius, sigma) : NULL;
    NPMatrixType *fmat= gauss ? NPMatrixCreateFromTemplate(lmat, gauss) : lmat;
    
    NPMatrixFree(gauss);
    
    if (fmat != lmat) {
        NPMatrixFree(lmat);
    }
    
    NPMatrixType *sobleX=NPMatrixCreateSobleXTemplate();
    NPMatrixType *sobleY=NPMatrixCreateSobleYTemplate();
    
    NPMatrixType *gradX=NPMatrixCreateFromTemplate(fmat, sobleX);
    NPMatrixType *gradY=NPMatrixCreateFromTemplate(fmat, sobleY);
    
    NPMatrixDotDivLong(gradX, 4);
    NPMatrixDotDivLong(gradY, 4);
    
    NPMatrixFree(fmat);
    NPMatrixFree(sobleX);
    NPMatrixFree(sobleY);
    
    NPMatrixType *gradX2=NPMatrixCopy(gradX);
    NPMatrixType *gradY2=NPMatrixCopy(gradY);
    
    
    NPMatrixDotMutiplyMatrix(gradX2, gradX2);
    NPMatrixDotMutiplyMatrix(gradY2, gradY2);
    
    NPMatrixSum(gradX2, gradY2);
    NPMatrixModifyElementUsingLongTypeFunction(gradX2, sqrtself, NULL, NPDefaultOrder);
    NPMatrixType *absGrad = gradX2;
    
    NPMatrixFree(gradY2);
    gradX2=NULL;
    
    
    // select threshold
    long minTh, maxTh;
    
    select_threshold(absGrad, &minTh, &maxTh);
    
    // NMS
    NPMatrixType *nmsMatrix=NPMatrixCreate(absGrad->info.matrixHeight, absGrad->info.matrixWidth, NPLongTypeMatrix);
    NPMatrixType *nmsCalcMats[3]={absGrad, gradX, gradY};
    
    NPMatrixModifyElementUsingLongTypeFunction(nmsMatrix, nms, nmsCalcMats, NPDefaultOrder);
    
    NPMatrixFree(gradX);
    NPMatrixFree(gradY);
    NPMatrixFree(absGrad);
    
    
    
    // double threshold operate
    
    NPMatrixType *resultMatrix = NPMatrixCreateZeroMatrix(mat->info.matrixHeight,
                                                          mat->info.matrixWidth,
                                                          NPUCharTypeMatrix);
    
    unsigned char neighbours = 8;
    CYPoint neighbour[8] = {
                            {.x=-1, .y=-1},
                            {.x=-1, .y= 0},
                            {.x=-1, .y= 1},
                            {.x= 0, .y=-1},
                            {.x= 0, .y= 1},
                            {.x= 1, .y=-1},
                            {.x= 1, .y= 0},
                            {.x= 1, .y= 1},
                           };
    
    size_t pointsMax = MIN(2048, nmsMatrix->info.matrixWidth*nmsMatrix->info.matrixHeight);
    CYPoint *scanPoints = calloc(sizeof(CYPoint), pointsMax);
    
    for (unsigned long y=1; y<nmsMatrix->info.matrixHeight-1; y++) {
        for (unsigned long x=1; x<nmsMatrix->info.matrixWidth-1; x++) {
            long e;
            NPMATRIX_GET_TYPE(long, e, nmsMatrix, x, y);
            if (e >= maxTh) {
                NPMATRIX_PUT_TYPE(unsigned char, 255, resultMatrix, x, y);
            } else if (e>=minTh) {
                // trace un-determined edge points.
                unsigned long cur=0, tail=1;
                BOOL isTraceValid = false;
                
                scanPoints[0].x=x;
                scanPoints[0].y=y;
                NPMATRIX_PUT_TYPE(long, 0, nmsMatrix, x, y);
                
                while (cur < tail) {
                    
                    for (unsigned long i=0; i<neighbours; i++) {
                        long nextX=scanPoints[cur].x + neighbour[i].x;
                        long nextY=scanPoints[cur].y + neighbour[i].y;
                        
                        if (nextX < 0 || nextX >= nmsMatrix->info.matrixWidth ||
                            nextY < 0 || nextY >= nmsMatrix->info.matrixHeight) {
                            continue;
                        }
                        
                        long p;
                        NPMATRIX_GET_TYPE(long, p, nmsMatrix, nextX, nextY);
                        if (p >= maxTh) {
                            isTraceValid = true;
                        } else if (p >= minTh) {
#ifdef DEBUG
                            if(tail >= nmsMatrix->info.matrixHeight * nmsMatrix->info.matrixWidth) {
                                assert(false);
                            }
#endif
                            
                            if (tail >= pointsMax) {
                                // expand list
                                size_t pointsMaxNext = MIN(pointsMax * 2, nmsMatrix->info.matrixHeight * nmsMatrix->info.matrixWidth);
                                CYPoint *scanPoints_expand = calloc(sizeof(CYPoint), pointsMaxNext);
                                bzero(scanPoints_expand + pointsMax, (pointsMaxNext-pointsMax) * sizeof(CYPoint));
                                memcpy(scanPoints_expand, scanPoints, pointsMax * sizeof(CYPoint));
                                free(scanPoints);
                                scanPoints=scanPoints_expand;
                                pointsMax=pointsMaxNext;
                            }
                            
                            scanPoints[tail].x=nextX;
                            scanPoints[tail].y=nextY;
                            NPMATRIX_PUT_TYPE(long, 0, nmsMatrix, nextX, nextY);
                            tail++;
                        }
                    }
                    cur++;
                }
                
                if (isTraceValid) {
                    for (unsigned long i=0; i<tail; i++) {
                        NPMATRIX_PUT_TYPE(unsigned char, 255, resultMatrix, scanPoints[i].x, scanPoints[i].y);
                    }
                }
                
            }
            
        }
    }
    
    free(scanPoints);
    NPMatrixFree(nmsMatrix);
    
    return resultMatrix;
    
}
