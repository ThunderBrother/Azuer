//
//  NSObject+Runtime.m
//  OTSKit
//
//  Created by Jerry on 16/8/25.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "NSObject+Runtime.h"
#import "OTSLog.h"

NSString *const OTSObjectTypeNotHandled = @"NSOBJECT_TYPE_NOT_HANDLED";
NSString *const OTSObjectTypeClass = @"NSOBJECT_TYPE_CLASS";

NSString *const OTSObjectTypeRawInt = @"NSOBJECT_TYPE_RAW_INT";
NSString *const OTSObjectTypeRawFloat = @"NSOBJECT_TYPE_RAW_FLOAT";
NSString *const OTSObjectTypeRawPointer = @"NSOBJECT_TYPE_RAW_POINTER";


@implementation NSObject (Runtime)

static char associatedObjectNamesKey;

- (void)setAssociatedObjectNames:(NSMutableSet *)associatedObjectNames {
    objc_setAssociatedObject(self, &associatedObjectNamesKey, associatedObjectNames,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet *)associatedObjectNames {
    NSMutableSet *array = objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array) {
        array = [NSMutableSet set];
        [self setAssociatedObjectNames:array];
    }
    return array;
}

- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy {
    [self.associatedObjectNames addObject:propertyName];
    objc_setAssociatedObject(self, (__bridge  objc_objectptr_t)propertyName, value, policy);
}

- (id)objc_getAssociatedObject:(NSString *)propertyName {
    for (NSString *key in self.associatedObjectNames) {
        if ([key isEqualToString:propertyName]) {
            return objc_getAssociatedObject(self, (__bridge objc_objectptr_t)key);
        }
    }
    return nil;
}

- (void)objc_removeAssociatedObjectForPropertyName: (NSString*)propertyName {
    [self objc_setAssociatedObject:propertyName value:nil policy:OBJC_ASSOCIATION_ASSIGN];
    [self.associatedObjectNames removeObject:propertyName];
}

- (void)objc_removeAssociatedObjects {
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    OTSLogW(@"setValue %@ forUndefinedKey %@",value,key);
}

- (void)setNilValueForKey:(NSString *)key {
    OTSLogW(@"setNilValue forKey %@",key);
}

- (NSArray*)properties {
    NSArray *storedProperties = [self objc_getAssociatedObject:@"ots_properties"];
    if (storedProperties) {
        return storedProperties;
    }
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
        free(properties);
        targetClass = [targetClass superclass];
    }
    [self objc_setAssociatedObject:@"ots_properties" value:props.copy policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    return props;
}

- (NSDictionary*)propertyInfos {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            
            const char *char_f = property_getName(property);
            
            NSString *resultPropertyName = [NSString stringWithUTF8String:char_f];
            NSString *resultPropertyType = nil;
            
            
            const char *type = property_getAttributes(property);
//            NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
            NSString * typeString = [NSString stringWithUTF8String:type];
            NSArray * attributes = [typeString componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringFromIndex:1];
            const char * rawPropertyType = [propertyType UTF8String];
            
            if (strcmp(rawPropertyType, @encode(float)) == 0) {
                resultPropertyType = OTSObjectTypeRawFloat;
            } else if (strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(NSUInteger)) == 0) {
                resultPropertyType = OTSObjectTypeRawInt;
            } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
                resultPropertyType = OTSObjectTypeRawPointer;
            }
            if ([typeAttribute hasPrefix:@"T@"]) {
                NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"\"(.*)\"" options:0 error:NULL];
                NSArray *matches = [pattern matchesInString:typeAttribute
                                                                options:0
                                                                  range:NSMakeRange(0, [typeAttribute length])];
                
                for (NSTextCheckingResult *match in matches) {
                    resultPropertyType = [typeAttribute substringWithRange:[match range]];
                    resultPropertyType = [resultPropertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    break;
                } 
                
                if (!resultPropertyType) {
                    resultPropertyType = OTSObjectTypeClass;
                }
            }
            [props setObject:(resultPropertyType?:OTSObjectTypeNotHandled) forKey:resultPropertyName ?: @""];
        }
        free(properties);
        targetClass = [targetClass superclass];
    }
    return props;
}

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod =class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        OTSLogE(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }
    
    Method altMethod =class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        OTSLogE(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }
    
    method_setImplementation(origMethod, class_getMethodImplementation(self, altSel));
    return YES;
}

+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel {
    Class c = object_getClass((id)self);
    return [c overrideMethod:origSel withMethod:altSel];
}

+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod =class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        OTSLogE(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }
    
    Method altMethod =class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        OTSLogE(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),class_getInstanceMethod(self, altSel));
    
    return YES;
}

+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel {
    Class c = object_getClass((id)self);
    return [c exchangeMethod:origSel withMethod:altSel];
}

@end
