//
//  MCLDefines.h
//  MCLocation
//
//  Created by Malcolm Hall on 13/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#ifndef MCLocation_EXTERN
    #ifdef __cplusplus
        #define MCLocation_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MCLocation_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif

#ifndef MCLocation_USE_PRIVATE_API
    #define MCLocation_USE_PRIVATE_API 1
#endif

#import <MCLocation/MCLDefines+Namespace.h>
