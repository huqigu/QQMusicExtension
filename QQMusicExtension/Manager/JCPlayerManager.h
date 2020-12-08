//
//  JCPlayerManager.h
//  QQMusicExtension
//
//  Created by yellow on 2020/12/7.
//

#import <Foundation/Foundation.h>
#import "SongInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface JCPlayerManager : NSObject

@property (nonatomic, assign) BOOL isStop;

+ (instancetype)shared;
- (void)preparePlayWithInfo:(SongInfo *)info;
- (void)seek:(double)time;
- (void)resume;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
