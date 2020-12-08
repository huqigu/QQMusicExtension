//
//  NSObject+PlayControlHook.m
//  QQMusicExtension
//
//  Created by yellow on 2020/12/7.
//

#import "NSObject+PlayControlHook.h"
#import "JCSwizzledHelper.h"
#import <SceneKit/SceneKit.h>
#import <objc/message.h>
#import "JCPlayerManager.h"
#import "KSAudioPlayer.h"

static KSAudioPlayer *player;  // QQMusic的播放器

@implementation NSObject (PlayControlHook)

+ (void)hookPlayControl {
    // 播放
    hookMethod(objc_getClass("KSAudioPlayer"), @selector(play:seekTime:), [self class], @selector(hook_play:seekTime:));
    // 快进
    hookMethod(objc_getClass("KSAudioPlayer"), @selector(seek:), [self class], @selector(hook_seek:));
    // 暂停
    hookMethod(objc_getClass("KSAudioPlayer"), @selector(pause), [self class], @selector(hook_pause));
    // 继续
    hookMethod(objc_getClass("KSAudioPlayer"), @selector(resume), [self class], @selector(hook_resume));
    
    player = [[objc_getClass("KSNewAudioPlayerManager") sharedInstance] valueForKey:@"curPlayer"];
}

- (BOOL)hook_play:(id)arg1 seekTime:(double)arg2 {
    if ([JCPlayerManager shared].isStop == false) {
        [[JCPlayerManager shared] seek:arg2];
        [player pause];
        return true;
    }
    [[JCPlayerManager shared] stop];
    return [self hook_play:arg1 seekTime:arg2];
}

- (void)hook_seek:(double)arg1 {
    if ([JCPlayerManager shared].isStop == false) {
        [[JCPlayerManager shared] seek:arg1];
        [player pause];
        return;
    }
    
    [[JCPlayerManager shared] stop];
    [self hook_seek:arg1];
}

- (void)hook_pause {
    if ([JCPlayerManager shared].isStop == false) {
        [[JCPlayerManager shared] pause];
        return;
    }
    [self hook_pause];
}

- (void)hook_resume {
    if ([JCPlayerManager shared].isStop == false) {
        [[JCPlayerManager shared] resume];
        [player pause];
        return;
    }
    [self hook_resume];
}

@end
