//
//  UIDiagramViewController.m
//  DiagramView
//
//  Created by Danil Tulin on 8/25/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import "UIDiagramView.h"

#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface UIDiagramView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) BEMSimpleLineGraphView *lineGraphView;

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
    [self addSubview:self.lineGraphView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)self.topColor.CGColor, (id)self.bottomColor.CGColor];
    gradient.cornerRadius = 10.0f;
    [self.layer insertSublayer:gradient atIndex:0];
    
    self.layer.cornerRadius = 10.0f;
}

#pragma mark - BEMSimpleLineGraphView

- (BEMSimpleLineGraphView *)lineGraphView
{
    if (!_lineGraphView)
    {
        _lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(10.0f, 5.0f + CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame) - 20.0f, CGRectGetHeight(self.frame) - (10.0f + CGRectGetMaxY(self.titleLabel.frame)))];
        
        _lineGraphView.delegate = self;
        _lineGraphView.dataSource = self;
        
        _lineGraphView.enableBezierCurve = YES;
        
        _lineGraphView.enableReferenceXAxisLines = YES;
        _lineGraphView.enableReferenceYAxisLines = YES;
        
        _lineGraphView.enableYAxisLabel = YES;
        _lineGraphView.enableXAxisLabel = YES;

        _lineGraphView.colorTop = [UIColor clearColor];
        _lineGraphView.colorBottom = [UIColor clearColor];
        
        _lineGraphView.colorYaxisLabel = [UIColor whiteColor];
        _lineGraphView.colorXaxisLabel = [UIColor whiteColor];
        
//        _lineGraphView.animationGraphEntranceTime = 4.2f;
        
//        _lineGraphView.alphaTop = .0f;
//        _lineGraphView.alphaBottom = .0f;
    }
    return _lineGraphView;
}

- (void)reload
{
    [self.lineGraphView reloadGraph];
}

#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 7;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return (arc4random() % 50)/5 + 23;
}

- (nullable NSString *)lineGraph:(nonnull BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"12 AM";
            break;
            
        case 7/2:
            return @"12 PM";
            break;
            
        case 6:
            return @"12 AM";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - BEMSimpleLineGraphDelegate

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
