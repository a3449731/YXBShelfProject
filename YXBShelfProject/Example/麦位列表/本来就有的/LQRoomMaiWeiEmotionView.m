//
//  LQRoomMaiWeiEmotionView.m
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/5.
//

#import "LQRoomMaiWeiEmotionView.h"
#import <SDWebImage/SDWebImage.h>

@interface LQRoomMaiWeiEmotionView()
@property (nonatomic, strong) SDAnimatedImageView *emotionImgView;
@property (nonatomic, assign) NSUInteger emotionCount;
@end
@implementation LQRoomMaiWeiEmotionView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = UIColor.clearColor;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    //魔法表情
    self.emotionImgView = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
    self.emotionImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.emotionImgView.userInteractionEnabled = YES;
    self.emotionImgView.animationRepeatCount = 1;
    self.emotionImgView.shouldCustomLoopCount = true;
    [self addSubview:self.emotionImgView];
    [self.emotionImgView addObserver:self forKeyPath:@"currentFrameIndex" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)setRoomEmotionUrl:(NSString *)roomEmotionUrl{
    _roomEmotionUrl = roomEmotionUrl;
    self.emotionImgView.hidden = false;
    // 这样取图写的什么👻，不是我写的。
    SDAnimatedImage *animeImage = [SDAnimatedImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_roomEmotionUrl]]];
    self.emotionCount = animeImage.animatedImageFrameCount;
    self.emotionImgView.image = animeImage;
    NSLog(@"你到底播放没播放，%@", animeImage);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentFrameIndex"]) {
        int current = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
        BOOL finished = (current == self.emotionCount - 1);
        if (finished) {
            [self.emotionImgView stopAnimating];
            self.emotionImgView.hidden = true;
        }
    }
}
-(void)dealloc{
    [self.emotionImgView removeObserver:self forKeyPath:@"currentFrameIndex"];
}
@end
