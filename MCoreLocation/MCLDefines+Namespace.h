//
//  MCLDefines+Namespace.h
//  MCoreLocation
//
//  Generated using MHNamespaceGenerator on 18/10/2016
//

#if !defined(__MCoreLocation_NS_SYMBOL) && defined(MCoreLocation_NAMESPACE)
    #define __MCoreLocation_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __MCoreLocation_NS_BRIDGE(ns, symbol) __MCoreLocation_NS_REWRITE(ns, symbol)
    #define __MCoreLocation_NS_SYMBOL(symbol) __MCoreLocation_NS_BRIDGE(MCoreLocation_NAMESPACE, symbol)
// Classes
    #define MCLAnnotationSegue __MCoreLocation_NS_SYMBOL(MCLAnnotationSegue)
    #define MCLAnnotationsTableBarButtonItem __MCoreLocation_NS_SYMBOL(MCLAnnotationsTableBarButtonItem)
    #define MCLEmptySegue __MCoreLocation_NS_SYMBOL(MCLEmptySegue)
    #define MCLFetchedResultsMapViewController __MCoreLocation_NS_SYMBOL(MCLFetchedResultsMapViewController)
    #define MCLManagedObject __MCoreLocation_NS_SYMBOL(MCLManagedObject)
    #define MCLMapTypeBarButtonItem __MCoreLocation_NS_SYMBOL(MCLMapTypeBarButtonItem)
    #define MCLMapViewController __MCoreLocation_NS_SYMBOL(MCLMapViewController)
// Categories
    #define MCL_predicateWithCoordinateRegion __MCoreLocation_NS_SYMBOL(MCL_predicateWithCoordinateRegion)
    #define MCL_requestLocationAuthorizationIfNotDetermined __MCoreLocation_NS_SYMBOL(MCL_requestLocationAuthorizationIfNotDetermined)
// Externs
#endif
