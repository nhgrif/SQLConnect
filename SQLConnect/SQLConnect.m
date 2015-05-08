#import "SQLConnect.h"

NSString * const SQLCONNECTION_VERSION_NUM = @"1.0.20150507";

// Returns YES if obj is nil or [NSNull null], else returns NO
BOOL isNull(id obj) {
    return (obj == nil || [obj isEqual:[NSNull null]]);
}

// If obj is null/nil per isNull(obj), returns replacement value, else returns object tested
id nullReplace(id obj, id replacement) {
    return (isNull(obj) ? replacement : obj);
}