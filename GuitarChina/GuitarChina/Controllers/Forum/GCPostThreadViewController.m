//
//  GCPostThreadViewController.m
//  GuitarChina
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCPostThreadViewController.h"

@interface GCPostThreadViewController ()

@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

- (IBAction)selectTypeAction:(UITapGestureRecognizer *)sender;

@end

@implementation GCPostThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectTypeAction:(UITapGestureRecognizer *)sender {
}
@end
