//
//  ViewController.m
//  RectArcAnimation
//
//  Created by yanguo sun on 2022/7/16.
//

#import "ViewController.h"

@interface ViewController (){
    CGFloat Width;
    CGFloat Height;
    int value;
    int stepValue;
    int maximumValue;
    int minimumValue;
}
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *bgImageView2;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Width = 160;
    Height = 40;
    value = 0;
    stepValue = +1;
    maximumValue = 20;

    minimumValue = 0;
    [self.view addSubview:self.bgImageView2];
    [self.view addSubview:self.bgImageView];

    self.timer = [NSTimer timerWithTimeInterval:.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self updateValue];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)updateValue {
    value += stepValue;
    if (value == maximumValue || value == minimumValue) {
        stepValue = -stepValue;
    }

    Height = 40 + value * 4;
    _bgImageView.frame = CGRectMake(100, 100, Width, Height);
    _bgImageView2.frame = CGRectMake(100, 100, Width, Height);
    _bgImageView.center = self.view.center;
    _bgImageView2.center = self.view.center;
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _bgImageView.bounds;
    UIBezierPath *path = [self.class makeRoundPath_2:_bgImageView.frame];
    maskLayer1.path = path.CGPath;
    _bgImageView.layer.mask = maskLayer1;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, Width, Height)];
        _bgImageView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:111.0/255.0 blue:121.0/255.0 alpha:1];
    }
    return _bgImageView;
}

- (UIImageView *)bgImageView2 {
    if (!_bgImageView2) {
        self.bgImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, Width, Height)];
        _bgImageView2.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:155.0/255.0 blue:120.0/255.0 alpha:1];

    }
    return _bgImageView2;
}

+ (UIBezierPath *)makeRoundPath_2:(CGRect)frame {
    CGFloat lineWidth = frame.size.height / 2; // 设置线宽为高度的一半 比较好看
    CGFloat w = frame.size.width - lineWidth;
    CGFloat h = frame.size.height - lineWidth;
    CGFloat r = (w*w/4 + h*h)/(2*h);
    CGFloat cosA = 1-h/r;
    CGFloat aaA = acos(cosA);
    CGFloat aA = M_PI_2 - aaA;
    CGFloat aB = M_PI_2 + aaA;

    CGFloat r1 = r- lineWidth / 2;
    CGFloat r2 = r + lineWidth / 2;
    CGFloat r3 = lineWidth / 2;

    CGPoint center1 = CGPointMake(frame.size.width/2, h - r + r3 );
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center1
                    radius:r1
                startAngle:aA
                  endAngle:aB
                 clockwise:YES];

    CGPoint center3 = CGPointMake(lineWidth / 2, lineWidth / 2);
    [path addArcWithCenter:center3
                    radius:r3
                startAngle:aB + M_PI
                  endAngle:aB
                 clockwise:NO];


    [path addArcWithCenter:center1
                    radius:r2
                startAngle:aB
                  endAngle:aA
                 clockwise:NO];

    CGPoint center4 = CGPointMake(frame.size.width - lineWidth / 2, lineWidth / 2);

    [path addArcWithCenter:center4
                    radius:r3
                startAngle:aA
                  endAngle:aA - M_PI
                 clockwise:NO];
    [path closePath];
    return path;
}
@end
