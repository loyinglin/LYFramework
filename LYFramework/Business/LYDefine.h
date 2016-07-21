//
//  LYDefine.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights rLYerved.
//

#ifndef LYDefine_h
#define LYDefine_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define DEFINE_IS_LIVE ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.loyinglin.live"])


// 不支持横屏
#ifndef LY_SCREEN_WIDTH
#define LY_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#endif


#ifndef LY_SCREENH_HEIGHT
#define LY_SCREENH_HEIGHT   [UIScreen mainScreen].bounds.size.height
#endif


#ifndef LY_IS_IPHONE
#define LY_IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif

#ifndef LY_IS_IPAD
#define LY_IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif



BOOL LYIOSVersionIsAbove9(void) {
    return NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_4;
}


BOOL LYIOSVersionIsAbove8(void) {
    return NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1;
}


BOOL LYIOSVersionIsAbove7(void) {
    return NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1;
}



/**
 * Checks whether the given object is a non-empty string.
 */
NS_INLINE BOOL LYIsStringWithText(id object) {
    return ([object isKindOfClass:[NSString class]] && [(NSString *)object length] > 0);
}

/**
 * Checks whether the given object is a non-empty array.
 */
NS_INLINE BOOL LYIsArrayWithItems(id object) {
    return ([object isKindOfClass:[NSArray class]] && [(NSArray *)object count] > 0);
}

/**
 * Checks whether the given object is a non-empty dictionary.
 */
NS_INLINE BOOL LYIsDictionaryWithItems(id object) {
    return ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] > 0);
}

/**
 * Checks whether the given object is a non-empty set.
 */
NS_INLINE BOOL LYIsSetWithItems(id object) {
    return ([object isKindOfClass:[NSSet class]] && [(NSSet *)object count] > 0);
}


/**
 * GeneratLY a random number between min and max.
 */
FOUNDATION_EXTERN uint32_t LYRandomNumber(uint32_t min, uint32_t max);

/**
 * GeneratLY a random data using `SecRandomCopyBytLY`.
 */
FOUNDATION_EXTERN NSData *LYRandomDataOfLength(NSUInteger length);

/**
 * GeneratLY a random string that contains 0-9a-zA-Z.
 */
FOUNDATION_EXTERN NSString *LYRandomStringOfLength(NSUInteger length);

/**
 * GeneratLY a random color.
 */
FOUNDATION_EXTERN UIColor *LYRandomColor(void);

/**
 * GeneratLY an UUID string, 36bits, e.g. @"B743154C-087E-4E7C-84AC-2573AAB940AD"
 */
FOUNDATION_EXTERN NSString *LYUUID(void);


//获取 Temp
#define lyPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define lyPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define lyPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]





#endif /* LYDefine_h */
