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
    #define MCLAnnotationSegue __MCORELOCATION_NAMESPACE_APPLY(MCLAnnotationSegue)
    #define MCLAnnotationsTableBarButtonItem __MCORELOCATION_NAMESPACE_APPLY(MCLAnnotationsTableBarButtonItem)
    #define MCLEmptySegue __MCORELOCATION_NAMESPACE_APPLY(MCLEmptySegue)
    #define MCLFetchedResultsMapViewController __MCORELOCATION_NAMESPACE_APPLY(MCLFetchedResultsMapViewController)
    #define MCLManagedObject __MCORELOCATION_NAMESPACE_APPLY(MCLManagedObject)
    #define MCLMapTypeBarButtonItem __MCORELOCATION_NAMESPACE_APPLY(MCLMapTypeBarButtonItem)
    #define MCLMapViewController __MCORELOCATION_NAMESPACE_APPLY(MCLMapViewController)
    #define MCLMapViewControllerLayoutGuide __MCORELOCATION_NAMESPACE_APPLY(MCLMapViewControllerLayoutGuide)
// Categories
    #define MCL __MCORELOCATION_NAMESPACE_APPLY(MCL)
    #define mcl_coordinateRegionWithMapView __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_coordinateRegionWithMapView)
    #define mcl_coordinateSpanWithMapView __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_coordinateSpanWithMapView)
    #define mcl_predicateWithCoordinateRegion __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_predicateWithCoordinateRegion)
    #define mcl_requestLocationAuthorizationIfNotDetermined __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_requestLocationAuthorizationIfNotDetermined)
    #define mcl_setCenterCoordinate __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_setCenterCoordinate)
    #define mcl_zoomLevel __MCORELOCATION_NAMESPACE_APPLY_LOWER(mcl_zoomLevel)
// Externs
#endif
