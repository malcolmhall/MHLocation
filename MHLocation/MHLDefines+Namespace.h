//
//  MHLDefines+Namespace.h
//  MHLocation
//
//  Generated using MHNamespaceGenerator on 18/10/2016
//

#if !defined(__MHLOCATION_NS_SYMBOL) && defined(MHLOCATION_NAMESPACE)
    #define __MHLOCATION_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __MHLOCATION_NS_BRIDGE(ns, symbol) __MHLOCATION_NS_REWRITE(ns, symbol)
    #define __MHLOCATION_NS_SYMBOL(symbol) __MHLOCATION_NS_BRIDGE(MHLOCATION_NAMESPACE, symbol)
// Classes
    #define MHLAnnotationSegue __MHLOCATION_NS_SYMBOL(MHLAnnotationSegue)
    #define MHLAnnotationsTableBarButtonItem __MHLOCATION_NS_SYMBOL(MHLAnnotationsTableBarButtonItem)
    #define MHLEmptySegue __MHLOCATION_NS_SYMBOL(MHLEmptySegue)
    #define MHLFetchedResultsMapViewController __MHLOCATION_NS_SYMBOL(MHLFetchedResultsMapViewController)
    #define MHLManagedObject __MHLOCATION_NS_SYMBOL(MHLManagedObject)
    #define MHLMapTypeBarButtonItem __MHLOCATION_NS_SYMBOL(MHLMapTypeBarButtonItem)
    #define MHLMapViewController __MHLOCATION_NS_SYMBOL(MHLMapViewController)
// Categories
    #define mhl_predicateWithCoordinateRegion __MHLOCATION_NS_SYMBOL(mhl_predicateWithCoordinateRegion)
    #define mhl_requestLocationAuthorizationIfNotDetermined __MHLOCATION_NS_SYMBOL(mhl_requestLocationAuthorizationIfNotDetermined)
// Externs
#endif
