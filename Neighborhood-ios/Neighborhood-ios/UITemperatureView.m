//
//  UITemperatureView.m
//  Neighborhood-ios
//
//  Created by Danil Tulin on 8/24/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import "UITemperatureView.h"

@interface UITemperatureView ()

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *predscriptionLabel;

@end

@implementation UITemperatureView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self addSubview:self.valueLabel];
    [self addSubview:self.predscriptionLabel];
}

- (void)setValue:(float)value
{
    _value = value;
    
    self.valueLabel.text = [[NSNumber numberWithFloat:value] stringValue];
    [self.valueLabel sizeToFit];
    
    self.valueLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.valueLabel.frame), CGRectGetHeight(self.valueLabel.frame));
    self.predscriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.valueLabel.frame), 0, CGRectGetWidth(self.predscriptionLabel.frame), CGRectGetHeight(self.predscriptionLabel.frame));
    
    CGPoint center = self.center;
    [self sizeToFit];
    self.center = center;
}

- (void)sizeToFit
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX(self.predscriptionLabel.frame), CGRectGetHeight(self.predscriptionLabel.frame));
}

#pragma mark - valueLabel

- (UILabel *)valueLabel
{
    if (!_valueLabel)
    {
        _valueLabel = [[UILabel alloc] init];
        
        _valueLabel.font = self.font;
        _valueLabel.textColor = [UIColor darkGrayColor];
    }
    return _valueLabel;
}

#pragma mark - PredscriptionLabel

- (UILabel *)predscriptionLabel
{
    if (!_predscriptionLabel)
    {
        _predscriptionLabel = [[UILabel alloc] init];
        
        _predscriptionLabel.text = @"°С";
    
        _predscriptionLabel.font = self.font;
        _predscriptionLabel.textColor = [UIColor darkGrayColor];
        
        [_predscriptionLabel sizeToFit];
    }
    return _predscriptionLabel;
}

#pragma mark - font

- (UIFont *)font
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:58.0f];
//    return [UIFont systemFontOfSize:36.0f weight:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline].pointSize];
}

@end
