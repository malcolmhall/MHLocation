//
//  MCLDefines+Namespace.h
//  MCoreLocation
//
//  Generated using MHNamespaceGenerator on 19/09/2017
//

#if !defined(__MCORELOCATION_NAMESPACE_APPLY) && defined(MCORELOCATION_NAMESPACE) && defined(MCORELOCATION_NAMESPACE_LOWER)
    #define __MCORELOCATION_NAMESPACE_REWRITE(ns, s) ns ## _ ## s
    #define __MCORELOCATION_NAMESPACE_BRIDGE(ns, s) __MCORELOCATION_NAMESPACE_REWRITE(ns, s)
    #define __MCORELOCATION_NAMESPACE_APPLY(s) __MCORELOCATION_NAMESPACE_BRIDGE(MCORELOCATION_NAMESPACE, s)
	#define __MCORELOCATION_NAMESPACE_APPLY_LOWER(s) __MCORELOCATION_NAMESPACE_BRIDGE(MCORELOCATION_NAMESPACE_LOWER, s)
// Classes
    #define MCLManagedObject __MCORELOCATION_NAMESPACE_APPLY(MCLManagedObject)
// Categories
    #define MCL __MCORELOCATION_NAMESPACE_APPLY(MCL)
    #define mcl_requestLocationAuthorizationIfNotDetermined __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_requestLocationAuthorizationIfNotDetermined)
// Externs
#endif
