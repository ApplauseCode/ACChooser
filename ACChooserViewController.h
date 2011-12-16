//
//  ACChooserViewController.h
//  ACChooserSample
//
//  Created by Jeffrey Rosenbluth on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat sum_2(CGFloat *a, int n);

@interface ACChooserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIColor *cellColor;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, strong) UIColor *cellTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, assign) BOOL variableCellWidth;

@property (nonatomic, assign, readonly) int selectedCellIndex;
@property (nonatomic, weak) id delegate;

// the designated intializer
- (id)initWithFrame:(CGRect)frame;

- (void)useGradientWithColor: (UIColor *)color;

@end

@protocol ACchooserDelegate
@optional

- (void)chooserDidSelectCell:(ACChooserViewController *)chooser;

@end
