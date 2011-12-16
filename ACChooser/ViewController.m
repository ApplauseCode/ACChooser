//
//  ViewController.m
//  ACChooser
//
//  Created by Jeffrey Rosenbluth on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ACChooserViewController.h"

@implementation ViewController

@synthesize chooser1;
@synthesize chooser2;
@synthesize chooser3;
@synthesize si1;
@synthesize si2;
@synthesize si3;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up the first chooser
	chooser1 = [[ACChooserViewController alloc] initWithFrame: CGRectMake(20, 40, 280, 28)];
    [chooser1 setDelegate:self];
    NSArray *data = [NSArray arrayWithObjects:@"ZERO", @"ONE", @"   TWO   ", @"THREE", @"  FOUR  ", @"FIVE", @"  SIX ", @"SEVEN", @"EIGHT", @"NINE", nil];
    [chooser1 setDataArray:data]; 
    [chooser1 setCellTextColor:[UIColor blackColor]];
    [chooser1 setSelectedTextColor:[UIColor blackColor]];
    [chooser1 setCellColor:[UIColor clearColor]]; 
    [chooser1 setSelectedBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:chooser1];
    [[self view] addSubview:[chooser1 view]];
    [chooser1 useGradientWithColor:[UIColor blackColor]];
    
    
    // set up the second chooser
    chooser2 = [[ACChooserViewController alloc] initWithFrame: CGRectMake(40, 180, 240, 20)];
    [chooser2 setDelegate:self];
    data = [NSArray arrayWithObjects:@"C", @"C \u266F/D\u266D", @"D", @"D \u266F/E\u266D", @"E", @"F", @"F \u266F/G\u266D",
            @"G", @"G \u266F/A\u266D", @"A",@"A \u266F/B\u266D",@"B",nil];
    [chooser2 setDataArray:data]; 
    [chooser2 setVariableCellWidth:NO];
    [chooser2 setCellFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16]];
    [chooser2 setCellTextColor:[UIColor colorWithRed:.45 green:.05 blue:.05 alpha:.7]];
    [chooser2 setSelectedTextColor:[UIColor colorWithRed:.25 green:0 blue:0 alpha:1]];
    [chooser2 setCellColor:[UIColor clearColor]]; 
    [chooser2 setSelectedBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:chooser2];
    [[self view] addSubview:[chooser2 view]];
    UIColor *bg = [UIColor colorWithRed:50.0/255 green:68.0/255 blue:99.0/255 alpha:1];
    [chooser2 useGradientWithColor:bg];
    
    // set up the third chosser
    chooser3 = [[ACChooserViewController alloc] initWithFrame: CGRectMake(0, 310, 320, 44)];
    [chooser3 setDelegate:self];
    data = [NSArray arrayWithObjects:@"Apple",@"Banana",@"Cherry",@"Grapefruit",@"Lemon",@"Mango", @"Pear",nil];
    [chooser3 setDataArray:data]; 
    [chooser3 setVariableCellWidth:YES];
    [chooser3 setCellFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:28]];
    [chooser3 setCellTextColor:[UIColor lightGrayColor]];
    [chooser3 setCellColor:[UIColor blackColor]]; 
    [chooser3 setSelectedBackgroundColor:[UIColor blackColor]];
    [chooser3 setSelectedTextColor:[UIColor whiteColor]];
    [self addChildViewController:chooser3];
    [[self view] addSubview:[chooser3 view]];
    
}

- (void)chooserDidSelectCell:(ACChooserViewController *)chooser
{
    if (chooser == chooser1)
        [si1 setText:[NSString stringWithFormat:@"Selected Index: %i",[chooser1 selectedCellIndex]]];
    else if(chooser == chooser2)
        [si2 setText:[NSString stringWithFormat:@"Selected Index: %i",[chooser2 selectedCellIndex]]];
    else if(chooser == chooser3)
        [si3 setText:[NSString stringWithFormat:@"Selected Index: %i",[chooser3 selectedCellIndex]]];
}

- (void)viewDidUnload
{
    [self setSi1:nil];
    [self setSi2:nil];
    [self setSi3:nil];
    [self setSi1:nil];
    [self setSi2:nil];
    [self setSi3:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
