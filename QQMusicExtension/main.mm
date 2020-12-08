//
//  main.c
//  QQMusicExtension
//
//  Created by yellow on 2020/12/2.
//
#import <Foundation/Foundation.h>
#import "NSObject+QQMusicHook.h"
#import "NSObject+PlayControlHook.h"

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"++++++++ QQMusicExtension loaded ++++++++");
    
    [NSObject hookQQMusic];
    [NSObject hookPlayControl];
}
