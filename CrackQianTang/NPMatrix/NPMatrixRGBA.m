//
//  NPMatrixRGBA.m
//  CannyDemo
//
//  Created by Hydra on 15/8/10.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPMatrixRGBA.h"

bool NPMatrixCreateFromRGBA(const NPRGBAMap *rgba, size_t size_map,
                            unsigned long height, unsigned long width,
                            NPMatrixType **rmat,
                            NPMatrixType **gmat,
                            NPMatrixType **bmat,
                            NPMatrixType **amat) {
    
    if (rmat==NULL || gmat==NULL || bmat==NULL || amat==NULL ||
        rgba==NULL) {
        return false;
    }
    
    if (height * width * sizeof(NPRGBAMap) != size_map) {
        return false;
    }
    
    NPMatrixType *rgbamat[4] = {NULL, NULL, NULL, NULL};
    for (int i=0; i<4; i++) {
        rgbamat[i]=NPMatrixCreate(height, width, NPUCharTypeMatrix);
        if (rgbamat[i]==NULL) {
            for (int j=0; j<i; j++) {
                NPMatrixFree(rgbamat[j]);
            }
            return false;
        }
    }
    
    unsigned char *red=rgbamat[0]->buf;
    unsigned char *green=rgbamat[1]->buf;
    unsigned char *blue=rgbamat[2]->buf;
    unsigned char *alpha=rgbamat[3]->buf;
    
    for (int i=0; i<size_map/sizeof(NPRGBAMap); i++) {
        red[i]=rgba[i].red;
        green[i]=rgba[i].green;
        blue[i]=rgba[i].blue;
        alpha[i]=rgba[i].alpha;
    }
    
    *rmat=rgbamat[0];
    *gmat=rgbamat[1];
    *bmat=rgbamat[2];
    *amat=rgbamat[3];
    
    return true;
}

bool NPMatrixCombineToRGBA(NPRGBAMap *rgba, size_t size_map,
                           NPMatrixType *rmat,
                           NPMatrixType *gmat,
                           NPMatrixType *bmat,
                           NPMatrixType *amat) {
    
    if (rmat==NULL || gmat==NULL || bmat==NULL || amat==NULL ||
        rgba==NULL) {
        return false;
    }

    if (rmat->info.matrixHeight != gmat->info.matrixHeight || rmat->info.matrixWidth != gmat->info.matrixWidth ||
        rmat->info.matrixHeight != bmat->info.matrixHeight || rmat->info.matrixWidth != bmat->info.matrixWidth ||
        rmat->info.matrixHeight != amat->info.matrixHeight || rmat->info.matrixWidth != amat->info.matrixWidth ) {
        return false;
    }
    
    unsigned long height = rmat->info.matrixHeight;
    unsigned long width = rmat->info.matrixWidth;
    
    if (height * width * sizeof(NPRGBAMap) != size_map) {
        return false;
    }
    
    BOOL shouldFree[4]={false, false, false, false};
    BOOL suc=true;
    NPMatrixType *mats[4] = {rmat, gmat, bmat, amat};
    for (int i=0; i<4; i++) {
        if (mats[i]->info.type != NPUCharTypeMatrix) {
            mats[i]=NPMatrixCopyToType(mats[i], NPUCharTypeMatrix);
            if (mats[i]==NULL) {
                suc=false;
                goto err;
            }
            shouldFree[i]=true;
        }
    }
    
    unsigned char *red,*green,*blue,*alpha;
    
    red=mats[0]->buf;
    green=mats[1]->buf;
    blue=mats[2]->buf;
    alpha=mats[3]->buf;
    
    for (int i=0; i<size_map/sizeof(NPRGBAMap); i++) {
        rgba[i].red=red[i];
        rgba[i].green=green[i];
        rgba[i].blue=blue[i];
        rgba[i].alpha=alpha[i];
    }

err:
    for (int i=0; i<4; i++) {
        if (shouldFree[i]) {
            NPMatrixFree(mats[i]);
        }
    }
    
    return suc;
    
}
