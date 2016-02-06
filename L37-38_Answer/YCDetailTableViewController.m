//
//  YCDetailTableViewController.m
//  L37-38_Answer
//
//  Created by Yaroslav on 26/01/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCDetailTableViewController.h"

@interface YCDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end

@implementation YCDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(actionBackHome:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.nameLabel.text = self.student.firstName;
    self.familyLabel.text = self.student.lastName;
    self.dateLabel.text = self.student.yearBirth;
    self.genderLabel.text = self.student.gender;
    self.streetNameLabel.text = [self.student.addressDictionary valueForKey:@"throughfare"];
    self.streetNumberLabel.text = [self.student.addressDictionary valueForKey:@"subThoroughfare"];
    self.cityLabel.text = [self.student.addressDictionary valueForKey:@"locality"];
    self.countryLabel.text = [self.student.addressDictionary valueForKey:@"country"];
}

- (void)actionBackHome:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
