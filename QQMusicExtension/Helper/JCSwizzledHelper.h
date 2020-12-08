//
//  JCSwizzledHelper.h
//  QQMusicExtension
//
//  Created by yellow on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCSwizzledHelper : NSObject

/**
 替换对象方法

 @param originalClass 原始类
 @param originalSelector 原始类的方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的方法
 */
void hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

/**
 替换类方法
 
 @param originalClass 原始类
 @param originalSelector 原始类的类方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的类方法
 */
void hookClassMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

@end

NS_ASSUME_NONNULL_END
