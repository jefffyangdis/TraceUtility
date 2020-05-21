//
//  CaDefines.h
//  Cafair
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 admin. All rights reserved.
//

#ifndef CaDefines_h
#define CaDefines_h

#import <objc/runtime.h>

#define TUPrint(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__])
#define TUIvarCast(object, name, type) (*(type *)(void *)&((char *)(__bridge void *)object)[ivar_getOffset(class_getInstanceVariable(object_getClass(object), #name))])
#define TUIvar(object, name) TUIvarCast(object, name, id const)

#endif /* CaDefines_h */
