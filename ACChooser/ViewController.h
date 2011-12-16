//
//  ViewController.h
//  ACChooser
//
//  Created by Jeffrey Rosenbluth on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACChooserViewController;
@interface ViewController : UIViewController

@property (strong, nonatomic) ACChooserViewController *chooser1;
@property (strong, nonatomic) ACChooserViewController *chooser2;
@property (strong, nonatomic) ACChooserViewController *chooser3;
@property (weak, nonatomic) IBOutlet UILabel *si1;
@property (weak, nonatomic) IBOutlet UILabel *si2;
@property (weak, nonatomic) IBOutlet UILabel *si3;

@end
