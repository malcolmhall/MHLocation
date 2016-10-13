//
//  MHLDefines.h
//  MHLocation
//
//  Created by Malcolm Hall on 13/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <MHLocation/MHLNamespaceDefines.h>

#ifndef MHLOCATION_EXTERN
    #ifdef __cplusplus
        #define MHLOCATION_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MHLOCATION_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif