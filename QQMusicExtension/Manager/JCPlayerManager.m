//
//  JCPlayerManager.m
//  QQMusicExtension
//
//  Created by yellow on 2020/12/7.
//

#import "JCPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>
#import "KSAudioPlayer.h"
#import "QMHoverTextField.h"
#import "MainBottomViewController.h"
#import "PlayProgressBar.h"
//酷狗音乐
// 搜索
//http://mobilecdngz.kugou.com/api/v3/search/song?tag=1&tagtype=%E5%85%A8%E9%83%A8&area_code=1&plat=0&sver=5&api_ver=1&showtype=14&tag_aggr=1&version=8904&keyword=%E5%91%A8%E6%9D%B0%E4%BC%A6&correct=1&page=1&pagesize=10
// 歌曲详情
//http://wwwapiretry.kugou.com/yy/index.php?r=play/getdata&hash=0a62227caab66f54d43ec084b4bdd81f&album_id=960399


// QQ音乐
//https://c.y.qq.com/soso/fcgi-bin/client_search_cp?ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=66412117289907226&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&w=%E5%91%A8%E6%9D%B0%E4%BC%A6&p=1&n=10&g_tk=5381&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0

// 注意header头
//https://i.y.qq.com/v8/playsong.html?songmid=0039MnYb0qxYhV
@interface JCPlayerManager ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) MainBottomViewController *mainVC;  // 主页面底部部分

@property (nonatomic, strong) PlayProgressBar *progressBar;   // 进度条

@property (nonatomic, strong) QMHoverTextField *songNameLabel;  // 歌曲名字

@end


@implementation JCPlayerManager

#pragma mark - Public Methods

+ (instancetype)shared {
    static JCPlayerManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[JCPlayerManager alloc] init];
            [_instance setIsStop:true];
            [_instance registerNotification];
            [_instance bindUI];
        }
    });
    return _instance;
}

- (void)preparePlayWithInfo:(SongInfo *)info {
    KSAudioPlayer *player = [[objc_getClass("KSNewAudioPlayerManager") sharedInstance] valueForKey:@"curPlayer"];
    [player pause];
    
    [self loadMobileWebView:info];
}

- (void)seek:(double)time {
    self.isStop = false;
    
    float totalSeconds = CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player.currentItem seekToTime:CMTimeMake(time / self.progressBar.maxValue * totalSeconds, 1.0) completionHandler:nil];
    [self.player play];
}

- (void)resume {
    self.isStop = false;
    [self.player play];
}

- (void)pause {
    self.isStop = false;
    [self.player pause];
}

- (void)stop {
    self.isStop = true;
    [self.player pause];
}

#pragma mark - Private Mthoeds
// 注册播放完成通知
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)bindUI {
    for (NSView *view in [NSApplication sharedApplication].keyWindow.contentView.subviews) {
        if ([view.nextResponder isKindOfClass:objc_getClass("MainBottomViewController")]) {
            self.mainVC = view.nextResponder;
            
            self.songNameLabel = [self.mainVC valueForKey:@"songNameLabel"];
            
            self.progressBar = [self.mainVC valueForKey:@"playProgressBar"];
        }
    }
}

// 加载试听url
- (void)loadMobileWebView:(SongInfo *)info {
    NSString *urlString = [NSString stringWithFormat:@"https://i.y.qq.com/v8/playsong.html?songmid=%@",info.song_Mid];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    
    [header setValue:@"application/x-www-form-urlencoded" forKey:@"content-type"];
    // 模拟手机网页请求
    [header setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 14_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1" forKey:@"User-Agent"];
    
    [request setAllHTTPHeaderFields:header];
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configureUIWithHtml:html info:info];
                [self playVipSongWithHtml:html];
            });
        }
    ];
    [dataTask resume];

}

// 设置歌曲信息UI
- (void)configureUIWithHtml:(NSString *)html info:(SongInfo *)info {
    
    NSString *coverUrl = [NSString stringWithFormat:@"https:%@",[self getCoverUrlStringWithHtml:html]];
    
    // 封面图
    [self.mainVC.songPicView setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:coverUrl]]];
    
    // 歌曲名字
    [self.songNameLabel setHightligtStringValue:info.song_Name];
    
    // 歌手
    [[self.mainVC valueForKey:@"singerNameView"] setValue:info.singerList forKey:@"singers"];

}

- (void)playVipSongWithHtml:(NSString *)html {
    
    NSString *playUrl = [self getPlayUrlStringWithHtml:html];
    
    [[JCPlayerManager shared] playWithUrlString:playUrl];
}

// 截取播放链接
- (NSString *)getPlayUrlStringWithHtml:(NSString *)html {
    
    NSString *regular = @"(?<=\\m4aUrl\":\").*?(?=\\\",)";
    
    NSRange range = [html rangeOfString:regular options:NSRegularExpressionSearch];
    
    if (range.location >= 0 && range.length > 0) {
        return [html substringWithRange:range];
    }else {
        return @"";
    }
}

// 截取封面图
- (NSString *)getCoverUrlStringWithHtml:(NSString *)html {
    NSString *regular = @"(?<=\\itemprop=\"image\" content=\").*?(?=\\\" /)";
    
    NSRange range = [html rangeOfString:regular options:NSRegularExpressionSearch];
    
    if (range.location >= 0 && range.length > 0) {
        return [html substringWithRange:range];
    }else {
        return @"";
    }
}

// 播放
- (void)playWithUrlString:(NSString *)playUrl {
    
    NSURL *url = [NSURL URLWithString:playUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:songItem];
    }else {
        self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            int current = CMTimeGetSeconds(time);
            int total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            
            [weakSelf.progressBar setCurrentDoubleValue:(float)current / (float)total * weakSelf.progressBar.maxValue buffer:0];
            [weakSelf.mainVC.songStartTimeLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d / %02d:%02d", current / 60, current % 60, total / 60, total % 60]];
        }];
    }
    self.isStop = false;
    [self.player play];
}

// 循环播放
- (void)didPlayToEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero completionHandler:nil];
    self.isStop = false;
    [self.player play];
}



@end
