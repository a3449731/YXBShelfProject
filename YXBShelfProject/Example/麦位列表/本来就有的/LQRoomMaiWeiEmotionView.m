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
    self.emotionImgView.shouldCustomLoopCount = true;
    self.emotionImgView.animationRepeatCount = 1;
    [self addSubview:self.emotionImgView];
}
-(void)setRoomEmotionUrl:(NSString *)roomEmotionUrl{
    _roomEmotionUrl = roomEmotionUrl;
    self.emotionImgView.hidden = false;
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_roomEmotionUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if ([image sd_isAnimated]) {
            weakSelf.emotionImgView.image = image;
            weakSelf.emotionImgView.hidden = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(image.images.count * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.emotionImgView.image = nil;
                weakSelf.emotionImgView.hidden = YES;
            });
        }
    }];
}

@end
