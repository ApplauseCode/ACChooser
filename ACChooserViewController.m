//
//  ACChooserViewController.m
//  ACChooserSample
//
//  Created by Jeffrey Rosenbluth on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ACChooserViewController.h"
#import <QuartzCore/QuartzCore.h>

// helper c-function to sum numbers in array but 1/2 the last one.
CGFloat sum_2(CGFloat *a, int n)
{
    CGFloat sum = 0.0;
    for (int i = 0; i < n-1; i++)
        sum += a[i];
    sum += 0.5 * a[n-1];
    return sum;
}

//Private ivars and methods

@interface ACChooserViewController ()
{
    CGFloat *cellWidths;
}
@property (nonatomic, strong) UITableView *horizontalTable;
@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign)  CGFloat currentOffset;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) int cellNumber;
@property (nonatomic, assign, readwrite) int selectedCellIndex;
@end

@implementation ACChooserViewController
@synthesize dataArray;
@synthesize cellColor;
@synthesize cellFont;
@synthesize cellTextColor;
@synthesize selectedTextColor;
@synthesize selectedBackgroundColor;
@synthesize variableCellWidth;
@synthesize horizontalTable;
@synthesize previousOffset;
@synthesize currentOffset;
@synthesize cellNumber;
@synthesize frame;
@synthesize selectedCellIndex;
@synthesize delegate;

// The Designated Initializer
- (id)initWithFrame:(CGRect)f;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        CGRect vert;
        CGPoint center;
        
        // find the coordinates of the origin of the vertical view to be rotated 90 degrees.
        center.x = CGRectGetMidX(f);
        center.y = CGRectGetMidY(f);
        vert.origin.x = center.x - 0.5 * f.size.height;
        vert.origin.y = center.y - 0.5 * f.size.width;
        vert.size.width = f.size.height;
        vert.size.height = f.size.width;
        [self setFrame:vert];
        
        // set default values for the appearance to the ACChooser.
        [self setCellNumber:1]; 
        [self setCellColor:[UIColor whiteColor]];
        [self setCellFont:[UIFont boldSystemFontOfSize:20]];
        [self setCellTextColor:[UIColor blackColor]];
        [self setSelectedTextColor:[self cellTextColor]];
        [self setSelectedBackgroundColor:[self cellColor]];
        [self setVariableCellWidth:YES];
    }
    return self;
}

// Override Apple's designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithFrame:CGRectZero];
}

- (void)useGradientWithColor: (UIColor *)color
{
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = [NSArray arrayWithObjects:(id)color.CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)color.CGColor, nil];
    layer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:1.0], nil];
    layer.startPoint = CGPointMake(0.0, 0.5);
    layer.endPoint = CGPointMake(1.0, 0.5);
    [layer setFrame:[[self view] frame]];
    [[[[self parentViewController] view] layer] insertSublayer:layer atIndex:1];
}

#pragma mark - View lifecycle

- (void)loadView
{
    int arraySize = [dataArray count]+2;
    CGFloat maxWidth = 0.0;
    cellWidths = (CGFloat *) malloc(arraySize * sizeof(CGFloat));
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSString *variableHeight;
        variableHeight = [dataArray objectAtIndex:i];
        CGFloat cellHeight = [variableHeight sizeWithFont:cellFont].width + 20.0;
        cellWidths[i+1] = cellHeight;
        maxWidth = (cellHeight > maxWidth) ? cellHeight : maxWidth;
    }
    if (!variableCellWidth)
        for (int i = 0; i < [dataArray count]; i++)
            cellWidths[i+1] = maxWidth;
    float startingCellWidth = frame.size.height * 0.5 - cellWidths[1] / 2.0;
    cellWidths[0] = startingCellWidth;
    float endingCellWidth = frame.size.height * 0.5 - cellWidths[arraySize-2] / 2.0;
    cellWidths[arraySize-1] = endingCellWidth;
    previousOffset = cellWidths[0] + 0.5 * cellWidths[1];
    horizontalTable = [[UITableView alloc] initWithFrame:frame];
    [horizontalTable setDelegate:self];
    [horizontalTable setDataSource:self];
    [horizontalTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [horizontalTable setShowsVerticalScrollIndicator:NO];
    [horizontalTable setBackgroundColor:[self cellColor]];
    [self setView:horizontalTable];
    [self tableView:horizontalTable didSelectRowAtIndexPath:(NSIndexPath *)[NSIndexPath indexPathForRow:1 inSection:0]];
    [horizontalTable setTransform:CGAffineTransformMakeRotation(- M_PI_2)];
}

- (void)viewDidUnload
{
    free(cellWidths);
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:selectedBackgroundColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path;
    [self setCellNumber:[indexPath row]];
    if (![self cellNumber]) [self setCellNumber:1];
    if ([self cellNumber] > [dataArray count]) [self setCellNumber:[dataArray count]];
    path = [NSIndexPath indexPathForRow:[self cellNumber] inSection:0];
    previousOffset = sum_2(cellWidths, [self cellNumber]);
    [horizontalTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; 
    selectedCellIndex = cellNumber - 1;
    //[tableView reloadData]; // sets text color and cell background back to normal
    [[[tableView cellForRowAtIndexPath:path] textLabel] setTextColor :selectedTextColor];
    [delegate chooserDidSelectCell: self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellWidths[[indexPath row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.contentView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.contentView setBackgroundColor:cellColor];
    [cell.textLabel setBackgroundColor:cellColor];
    if ([indexPath row] == 0 || [indexPath row] == ([dataArray count] + 1))
        [cell.textLabel setText:@""];
    else
    {
        [cell.textLabel setFont:cellFont];
        [cell.textLabel setTextColor:cellTextColor];
        [cell.textLabel setText:[dataArray objectAtIndex:([indexPath row] - 1)]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentOffset = [horizontalTable contentOffset].y + 0.5 * [scrollView frame].size.width;
    CGFloat offsetHolder = currentOffset;
    CGFloat cellNumberWidth = cellWidths[[self cellNumber]];
    BOOL withinCell = (fabs(currentOffset - previousOffset) <= (0.5 * cellNumberWidth));
    BOOL positiveScroll = (currentOffset > previousOffset);
    int currentCellCount = 0;
    while (offsetHolder > 0) {
        offsetHolder -= cellWidths[currentCellCount];
        currentCellCount++;
    }  
    CGFloat cellCenter = sum_2(cellWidths, currentCellCount);
    BOOL leftSide = (currentOffset < cellCenter);
    NSIndexPath *path;
    int direction = (positiveScroll) ? 1 : -1;
    int row;
    if (withinCell)
        row = [self cellNumber] + direction;
    else {
        if (positiveScroll) direction = (leftSide) ? 0 : 1;
        else direction = (leftSide) ? -1 : 0;
        row = currentCellCount - 1 + direction;
    }
    if (row < 1) row = 1;
    if (row > [dataArray count]) row = [dataArray count];
    path = [NSIndexPath indexPathForRow:row inSection:0];
    [self setCellNumber: row];
    selectedCellIndex = cellNumber - 1;
    previousOffset = sum_2(cellWidths, [self cellNumber]+1);
    [horizontalTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [horizontalTable reloadData]; // sets text color and cell background back to normal
    [[[horizontalTable cellForRowAtIndexPath:path] textLabel] setTextColor :selectedTextColor];
    [[[horizontalTable cellForRowAtIndexPath:path] contentView] setBackgroundColor:selectedBackgroundColor];
    [[[horizontalTable cellForRowAtIndexPath:path] textLabel] setBackgroundColor:selectedBackgroundColor];
    [delegate chooserDidSelectCell: self];
}

@end
