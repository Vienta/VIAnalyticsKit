//
//  View2Controller.m
//  VIAnalyticsKit
//
//  Created by Vienta on 8/17/16.
//  Copyright © 2016 Vienta. All rights reserved.
//

#import "View2Controller.h"

@interface View2Controller ()

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation View2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hhh"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hhh"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.titles objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
