//
//  UIDiagramViewController.m
//  DiagramView
//
//  Created by Danil Tulin on 8/25/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import "UIDiagramView.h"

@interface UIDiagramView ()

@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation UIDiagramView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        self.title = title;
    }
    return self;
}

+ (instancetype)diagramViewWithFrame:(CGRect)frame title:(NSString *)title
{
    UIDiagramView *diagramView = [[UIDiagramView alloc] initWithFrame:frame title:title];
    return diagramView;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self addSubview:self.titleLabel];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)self.topColor.CGColor, (id)self.bottomColor.CGColor];
    gradient.cornerRadius = 10.0f;
    [self.layer insertSublayer:gradient atIndex:0];
    
    self.layer.cornerRadius = 10.0f;
}

#pragma mark - TitleLabel

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.text = self.title;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f];
        
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(10.0f, 5.0f, CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame));
    }
    return _titleLabel;
}

#pragma mark - Colors

- (UIColor *)topColor
{
    return [UIColor colorWithRed:1.0f green:211.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
}

- (UIColor *)bottomColor
{
    return [UIColor colorWithRed:1.0f green:162.0f/255.0f blue:.0f alpha:1.0f];
}

#pragma mark - NoDataLabel

- (UILabel *)noDataLabel
{
    if (!_noDataLabel)
    {
        _noDataLabel = [[UILabel alloc] init];
    }
    return _noDataLabel;
}

@end
