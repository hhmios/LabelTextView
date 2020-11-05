//
//  ViewController.m
//  HMTagTextView
//
//  Created by 郝贺明 on 2020/10/29.
//

#import "TagLabelText.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    TagLabelText *textV = [[TagLabelText alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:textV];
}


@end
