//
//  JMPortraitNavigationController.m
//  JMUIKit
//
//  Created by ZhengXianda on 2022/10/14.
//

#import "JMPortraitNavigationController.h"

@interface JMPortraitNavigationController ()

@end

@implementation JMPortraitNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
