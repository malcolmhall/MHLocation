//
//  MCLDefines.h
//  MCoreLocation
//
//  Created by Malcolm Hall on 13/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#ifndef MCoreLocation_EXTERN
    #ifdef __cplusplus
        #define MCoreLocation_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MCoreLocation_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif

#ifndef MCoreLocation_USE_PRIVATE_API
    #define MCoreLocation_USE_PRIVATE_API 1
#endif

#import <MCoreLocation/MCLDefines+Namespace.h>
