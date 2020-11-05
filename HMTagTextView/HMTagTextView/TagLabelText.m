//
//  TagLabelText.m
//  HMTagTextView
//
//  Created by 郝贺明 on 2020/10/29.
//

#import "TagLabelText.h"
#import "UITextField+CS.h"
#import "UIButton+ClickBlock.h"

#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight     [[UIScreen mainScreen] bounds].size.height
#define rgb(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kWhiteFourFiveColor    rgb(255, 255, 255, 0.45)//社区文字颜色:白，不透明度45%
#define ISNULLSTR(str) (str == nil || (NSObject *)str == [NSNull null] || str.length == 0 || [str isEqualToString:@"(null)"]||[str isEqualToString:@"<null>"])

@interface TagLabelText()<UITextFieldDelegate>
{
    NSInteger i;
}
@property (nonatomic,strong)UITextField *contentText;
@property (nonatomic,strong)NSString *textStr;
//@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)NSMutableArray *tagsArray;
@property (nonatomic,copy)void(^deleteBlock)(UIView *backTagV) ;
@end

@implementation TagLabelText

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChildViews];
    }
    return self;
}

-(void)setChildViews
{
    i = 0;
    self.contentText = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMinY(self.frame)+100, ScreenWidth-20, 30)];
    [self addSubview:self.contentText];
    self.contentText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Multiple labels should be separated by newlines or Spaces" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:kWhiteFourFiveColor}]; ///新的实现复制代
    self.contentText.backgroundColor = rgb(70, 74, 102, 1);
    [self.contentText addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.contentText.delegate = self;
    [self.contentText setTextColor:[UIColor lightGrayColor]];
    self.contentText.font = [UIFont systemFontOfSize:12];

    
}
//监听改变方法
- (void)textFieldTextDidChange:(UITextField *)textChange
{
    [self dealWithTextfieldData:textChange];
}
-(void)textFieldDidDeleteBackward:(UITextField *)textField
{
    if (ISNULLSTR(self.contentText.text)&&ISNULLSTR(self.textStr)) {
        if (self.tagsArray.count>0) {
            // 没数据时点键盘上的叉号删除前面的标签
            UIView *beforeI = self.tagsArray.lastObject;
            [beforeI removeFromSuperview];
            self.deleteBlock(beforeI);
        }
    }
    self.textStr = textField.text;
}
-(void)dealWithTextfieldData:(UITextField*)textChange
{
    CGFloat wd = [self getWidthWithText:textChange.text height:30 font:12];
    NSLog(@"文字改变：%f",wd);
    if ([textChange.text containsString:@" "]) {

        
      UIView *tagV = [self creatTagWithWidth:wd contentText:textChange.text touchBlcok:^(UIView *backTagV){
          
          NSInteger viewIndex = [self.tagsArray indexOfObject:backTagV];
          
          if(viewIndex == self.tagsArray.count-1)
          {
              // 删除的是末尾的
              [self.tagsArray removeObjectAtIndex:self->i-1];
              [self detectWhetherArrayIsNone];
              self->i--;
              UIView *before1 = self.tagsArray.lastObject;

              
              if((before1.frame.origin.x+before1.frame.size.width+10)>ScreenWidth) {
                  [self.contentText setFrame:CGRectMake(16, CGRectGetMaxY(before1.frame)+10, ScreenWidth-20, 30)];
              }else{
                  if (self.tagsArray.count == 0) {
                      [self.contentText setFrame:CGRectMake(16, CGRectGetMinY(self.frame)+100, ScreenWidth-20, 30)];
                  }else{
                      [self.contentText setFrame:CGRectMake(CGRectGetMaxX(before1.frame)+10, CGRectGetMinY(before1.frame), ScreenWidth-10-before1.frame.origin.x-before1.frame.size.width, 30)];
                  }
              }
          }else{
              // 不是末尾
              if(viewIndex == 0)
              {
                  // 删除的第一个
                  self->i--;
                  [self.tagsArray removeObject:backTagV];
                  [self detectWhetherArrayIsNone];
                  for(NSInteger indexs = viewIndex; indexs <= self.tagsArray.count-1;indexs++)
                  {
                      UIView *behind1 = self.tagsArray[indexs];
                      if (indexs == 0) {
                          
                          behind1.frame = CGRectMake(16, CGRectGetMinY(self.frame)+100, behind1.frame.size.width, behind1.frame.size.height);
                      }else{
                          UIView *before1 = self.tagsArray[indexs-1];
                          if(before1.frame.origin.x+before1.frame.size.width+10+behind1.frame.size.width+10>ScreenWidth)
                          {
                              behind1.frame = CGRectMake(16, CGRectGetMaxY(before1.frame)+10, behind1.frame.size.width, behind1.frame.size.height);
                          }
                          else
                          {
                              behind1.frame = CGRectMake(CGRectGetMaxX(before1.frame)+10, before1.frame.origin.y, behind1.frame.size.width, behind1.frame.size.height);
                          }
                      }
                      
                      if(behind1.frame.origin.x+behind1.frame.size.width+10>ScreenWidth) {
                          self.contentText.frame = CGRectMake(16, CGRectGetMaxY(behind1.frame)+10, ScreenWidth-20, 30);
                      }else{
                          self.contentText.frame = CGRectMake(CGRectGetMaxX(behind1.frame)+5, behind1.frame.origin.y, ScreenWidth-(behind1.frame.origin.x + behind1.frame.size.width+5), 30);
                      }
                      
                  }
              }
              else
              {
                  // 删除的是中间的
                  self->i--;
                  [self.tagsArray removeObject:backTagV];
                  [self detectWhetherArrayIsNone];
                  for(NSInteger indexs = viewIndex; indexs <= self.tagsArray.count-1;indexs++)
                  {
                      
                      UIView *before1 = self.tagsArray[indexs-1];
                      UIView *behind1 = self.tagsArray[indexs];
                      NSLog(@"==长度==%f",before1.frame.origin.x+before1.frame.size.width+10+behind1.frame.size.width+10);
                      if(before1.frame.origin.x+before1.frame.size.width+10+behind1.frame.size.width+10>ScreenWidth)
                      {
                          behind1.frame = CGRectMake(16, CGRectGetMaxY(before1.frame)+10, behind1.frame.size.width, behind1.frame.size.height);
                      }
                      else
                      {
                          behind1.frame = CGRectMake(CGRectGetMaxX(before1.frame)+10, before1.frame.origin.y, behind1.frame.size.width, behind1.frame.size.height);
                      }
                      
                      if(behind1.frame.origin.x+behind1.frame.size.width+10>ScreenWidth) {
                          self.contentText.frame = CGRectMake(16, CGRectGetMaxY(behind1.frame)+10, ScreenWidth-20, 30);
                      }else{
                          self.contentText.frame = CGRectMake(CGRectGetMaxX(behind1.frame)+5, behind1.frame.origin.y, ScreenWidth-(behind1.frame.origin.x + behind1.frame.size.width+5), 30);
                      }
                      
                  }
                 
                 
              }
            
          }
          
         
          
        }];
        tagV.tag = i;
        if (i==0) {
            tagV.frame = CGRectMake(16, CGRectGetMinY(self.frame)+100, wd+41, 24);
            [self addSubview:tagV];

            [textChange setFrame:CGRectMake(wd+41+20, textChange.frame.origin.y, ScreenWidth-10-wd-41, 30)];
            textChange.text = @"";
            [self.tagsArray addObject:tagV];
        }else{

            UIView *before = self.tagsArray[i-1];
            if ((before.frame.origin.x+before.frame.size.width+10+wd+41)>ScreenWidth) {
                tagV.frame = CGRectMake(10, CGRectGetMaxY(before.frame)+10, wd+41, 24);
            }else{
                tagV.frame = CGRectMake(CGRectGetMaxX(before.frame)+10, CGRectGetMinY(before.frame), wd+41, 24);
            }
          
            [self addSubview:tagV];
            
            if(tagV.frame.origin.x+tagV.frame.size.width+10>ScreenWidth) {
                self.contentText.frame = CGRectMake(16, CGRectGetMaxY(tagV.frame)+10, ScreenWidth-10-wd+41, 30);
            }else{
                self.contentText.frame = CGRectMake(CGRectGetMaxX(tagV.frame)+5, tagV.frame.origin.y, ScreenWidth-10-wd+41, 30);
            }
              
            textChange.text = @"";
            [self.tagsArray addObject:tagV];
        }
        i++;
    }else{

    }
    
}
-(void)detectWhetherArrayIsNone
{
   
}
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}
-(UIView*)creatTagWithWidth:(float)width contentText:(NSString*)text touchBlcok:(void(^)(UIView *backTagV))click// view加41
{
    UIView *contentV = [[UIView alloc]init];
    contentV.backgroundColor = rgb(69, 74, 104, 1);
    contentV.layer.cornerRadius = 12;
    contentV.layer.masksToBounds = YES;
    
    UILabel *tagL = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, width, 22)];
    tagL.font = [UIFont systemFontOfSize:12];
    tagL.textAlignment = NSTextAlignmentLeft;
    tagL.textColor = [UIColor whiteColor];
    tagL.tag = 1001;
    tagL.text = text;
    tagL.textAlignment = NSTextAlignmentLeft;
    [contentV addSubview:tagL];
    
    UIButton *delete = [[UIButton alloc]init];
    [delete setImage:[UIImage imageNamed:@"issueTagDelete"] forState:UIControlStateNormal];
    delete.frame = CGRectMake(width+15, 4, 16, 16);
    [contentV addSubview:delete];
  
    __weak typeof(self)weakSelf = self;
    [delete handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        click(contentV);
        [contentV removeFromSuperview];
    }];
    weakSelf.deleteBlock = click;
    return contentV;
}

-(void)transportDataWithview:(UIView*)view Blaock:(dispatch_block_t)blos
{
    
}
-(NSMutableArray *)tagsArray
{
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}
@end
