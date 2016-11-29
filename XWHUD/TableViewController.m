//
//  TableViewController.m
//  XWHUD
//
//  Created by Xin Wang on 11/29/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#import "TableViewController.h"
#import "XWHUD.h"

@interface TableViewController ()
@property (nonatomic, strong) NSArray<NSString *> *cellTitles;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"XWHUD";
    self.cellTitles = @[@"hide", @"show", @"showSuccess", @"showError"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.cellTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [XWHUD performSelectorOnMainThread:NSSelectorFromString(self.cellTitles[indexPath.row])
                            withObject:nil
                         waitUntilDone:NO];
}

@end
