//
//  NSObject+PlayControlHook.h
//  QQMusicExtension
//
//  Created by yellow on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PlayControlHook)

+ (void)hookPlayControl;

- (void)hook_pause;

@end

NS_ASSUME_NONNULL_END
