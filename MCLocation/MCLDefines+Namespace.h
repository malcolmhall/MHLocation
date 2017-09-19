//
//  MCLDefines+Namespace.h
//  MCLocation
//
//  Generated using MHNamespaceGenerator on 18/10/2016
//

#if !defined(__MCLocation_NS_SYMBOL) && defined(MCLocation_NAMESPACE)
    #define __MCLocation_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __MCLocation_NS_BRIDGE(ns, symbol) __MCLocation_NS_REWRITE(ns, symbol)
    #define __MCLocation_NS_SYMBOL(symbol) __MCLocation_NS_BRIDGE(MCLocation_NAMESPACE, symbol)
// Classes
    #define MCLAnnotationSegue __MCLocation_NS_SYMBOL(MCLAnnotationSegue)
    #define MCLAnnotationsTableBarButtonItem __MCLocation_NS_SYMBOL(MCLAnnotationsTableBarButtonItem)
    #define MCLEmptySegue __MCLocation_NS_SYMBOL(MCLEmptySegue)
    #define MCLFetchedResultsMapViewController __MCLocation_NS_SYMBOL(MCLFetchedResultsMapViewController)
    #define MCLManagedObject __MCLocation_NS_SYMBOL(MCLManagedObject)
    #define MCLMapTypeBarButtonItem __MCLocation_NS_SYMBOL(MCLMapTypeBarButtonItem)
    #define MCLMapViewController __MCLocation_NS_SYMBOL(MCLMapViewController)
// Categories
    #define MCL_predicateWithCoordinateRegion __MCLocation_NS_SYMBOL(MCL_predicateWithCoordinateRegion)
    #define MCL_requestLocationAuthorizationIfNotDetermined __MCLocation_NS_SYMBOL(MCL_requestLocationAuthorizationIfNotDetermined)
// Externs
#endif
