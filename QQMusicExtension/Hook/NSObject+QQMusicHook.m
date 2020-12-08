//
//  NSObject+QQMusicHook.m
//  QQMusicExtension
//
//  Created by yellow on 2020/12/2.
//

#import "NSObject+QQMusicHook.h"
#import "JCSwizzledHelper.h"
#import "SongInfo.h"
#import <SceneKit/SceneKit.h>
#import <objc/message.h>
#import "JCPlayerManager.h"

@implementation NSObject (QQMusicHook)


+ (void)hookQQMusic {
    // 双击cell播放
    hookMethod(objc_getClass("SongListController"), @selector(tableViewDoubleClick), [self class], @selector(hook_tableViewDoubleClick));
    // 点击cell上播放按钮
    hookMethod(objc_getClass("SongListController"), @selector(cellPlayButtonPressed), [self class], @selector(hook_cellPlayButtonPressed));
    // 返回单个cell
    hookMethod(objc_getClass("SongListController"), @selector(tableView:viewForTableColumn:row:), [self class], @selector(hook_tableView:viewForTableColumn:row:));
    // 获取row对应的SongInfo
    hookMethod(objc_getClass("SongListController"), @selector(getSongInfoWithRow:), [self class], @selector(hook_getSongInfoWithRow:));
    
}

- (void)hook_tableViewDoubleClick  {
    NSTableView *tableView = [self valueForKey:@"tableView"];
    NSInteger row = [tableView clickedRow];
    SongInfo *info = [self hook_getSongInfoWithRow:row];
    if (!info.isVip) {
        [[JCPlayerManager shared] stop];
        [self hook_tableViewDoubleClick];
    }else {
        [[JCPlayerManager shared] preparePlayWithInfo:info];
    }
}

- (void)hook_cellPlayButtonPressed {
    NSTableView *tableView = [self valueForKey:@"tableView"];
    NSInteger row = [[tableView valueForKey:@"hoverRow"] integerValue];
    SongInfo *info = [self hook_getSongInfoWithRow:row];
    if (!info.isVip) {
        [[JCPlayerManager shared] stop];
        [self hook_cellPlayButtonPressed];
    }else {
        [[JCPlayerManager shared] preparePlayWithInfo:info];
    }
}

- (id)hook_tableView:(id)arg1 viewForTableColumn:(id)arg2 row:(long long)arg3 {
    NSTableCellView *cell = [self hook_tableView:arg1 viewForTableColumn:arg2 row:arg3];
    SongInfo *info = [self hook_getSongInfoWithRow:arg3];
    if (info.isVip) {
        cell.alphaValue = 0.3f;
    }else {
        cell.alphaValue = 1.0f;
    }
    return cell;
}

- (id)hook_getSongInfoWithRow:(long long)arg1 {
    SongInfo *info = [self hook_getSongInfoWithRow:arg1];
    return info;
}
@end



