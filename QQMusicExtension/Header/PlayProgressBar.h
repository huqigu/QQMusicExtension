//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <SceneKit/SceneKit.h>

@class CALayer, LyricTipView, NSColor, NSDate, NSMutableArray, NSTrackingArea;

__attribute__((visibility("hidden")))
@interface PlayProgressBar : NSView
{
    BOOL isMouseDown;
    NSColor *leftColor;
    NSColor *baseColor;
    NSColor *bufferColor;
    NSColor *knobColor;
    double bufferValue;
    float knobSize;
    float tryBeginKnobSize;
    BOOL isVisiableBar;
    LyricTipView *lyricTipView;
    NSMutableArray *progressLyric;
    CALayer *_layerBackground;
    CALayer *_layerCache;
    CALayer *_layerPlay;
    CALayer *_layerKnob;
    CALayer *_layerTryBegin;
    BOOL canLyricSeekShow;
    NSDate *lastPostDate;
    double lastMouseUpValue;
    NSDate *lastLyricShowDate;
    double lastLyricShowValue;
    double minValue;
    double maxValue;
    double doubleValue;
//    id <ProgressBarSeekDelegate> _delegate;
    NSTrackingArea *_trackingArea;
    double _tryBeginTime;
}

@property(nonatomic) double tryBeginTime; // @synthesize tryBeginTime=_tryBeginTime;
@property(retain, nonatomic) NSTrackingArea *trackingArea; // @synthesize trackingArea=_trackingArea;
//@property(nonatomic) __weak id <ProgressBarSeekDelegate> delegate; // @synthesize delegate=_delegate;
@property(retain, nonatomic) NSColor *knobColor; // @synthesize knobColor;
@property(nonatomic) double bufferValue; // @synthesize bufferValue;
@property(nonatomic) double doubleValue; // @synthesize doubleValue;
@property(nonatomic) double maxValue; // @synthesize maxValue;
@property(nonatomic) double minValue; // @synthesize minValue;
@property(nonatomic) float knobSize; // @synthesize knobSize;
@property(nonatomic) BOOL canLyricSeekShow; // @synthesize canLyricSeekShow;
@property(nonatomic) double lastLyricShowValue; // @synthesize lastLyricShowValue;
@property(retain, nonatomic) NSDate *lastLyricShowDate; // @synthesize lastLyricShowDate;
@property(nonatomic) double lastMouseUpValue; // @synthesize lastMouseUpValue;
@property(retain, nonatomic) NSDate *lastPostDate; // @synthesize lastPostDate;
@property(retain, nonatomic) NSColor *baseColor; // @synthesize baseColor;
@property(retain, nonatomic) NSColor *bufferColor; // @synthesize bufferColor;
@property(retain, nonatomic) NSColor *leftColor; // @synthesize leftColor;
//- (void).cxx_destruct;
- (id)lyricText:(double)arg1;
- (void)onUpdateLyricData;
- (void)lyricClose;
- (void)lyricShow;
- (void)lyricShowDelay;
- (void)updatePlayProgress;
- (struct CGRect)calculateSlideRect;
- (double)mouseLocationValue:(struct CGPoint)arg1;
- (_Bool)mouseInTryBeginLyaer:(struct CGPoint)arg1;
- (void)onSkinChanged;
- (void)frameDidChangeNotification:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (BOOL)acceptsFirstMouse:(id)arg1;
- (BOOL)mouseDownCanMoveWindow;
- (void)mouseDragged:(id)arg1;
- (void)mouseExited:(id)arg1;
- (void)mouseEntered:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)updateTrackingAreas;
- (BOOL)isFlipped;
- (void)setCurrentDoubleValue:(double)arg1 buffer:(double)arg2;
- (id)initWithFrame:(struct CGRect)arg1;
- (BOOL)acceptsFirstResponder;
- (void)dealloc;
- (void)awakeFromNib;

@end

