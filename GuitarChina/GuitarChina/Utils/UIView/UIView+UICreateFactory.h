#import <Foundation/Foundation.h>

@interface UIView (UICreateFactory)

//Label

+ (UILabel *)createLabel;

+ (UILabel *)createLabel:(CGRect)frame;

+ (UILabel *)createLabel:(CGRect)frame
                    text:(NSString *)text
                    font:(UIFont *)font
               textColor:(UIColor *)textColor;

+ (UILabel *)createLabel:(CGRect)frame
                    text:(NSString *)text
                    font:(UIFont *)font
               textColor:(UIColor *)textColor
           numberOfLines:(NSInteger)numberOfLines
 preferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth;

//TextField

+ (UITextField *)createTextField;

+ (UITextField *)createTextField:(CGRect)frame;

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle
                            text:(NSString *)text
                       textColor:(UIColor *)color
                     placeholder:(NSString *)placeholder;

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle
                            text:(NSString *)text
                       textColor:(UIColor *)color
                     placeholder:(NSString *)placeholder
                   textAlignment:(NSTextAlignment)textAlignment;

//Button

+ (UIButton *)createButton;

+ (UIButton *)createButton:(CGRect)frame;

+ (UIButton *)createButton:(CGRect)frame
                buttonType:(UIButtonType)buttonType;

+ (UIButton *)createButton:(CGRect)frame
                    target:(id)target
                    action:(SEL)action;

+ (UIButton *)createButton:(CGRect)frame
                buttonType:(UIButtonType)buttonType
                    target:(id)target
                    action:(SEL)action;

//TextView

+ (UITextView *)createTextView;

+ (UITextView *)createTextView:(CGRect)frame;

//ImageView

+ (UIImageView *)createImageView;

+ (UIImageView *)createImageView:(CGRect)frame;

+ (UIImageView *)createImageView:(CGRect)frame
                     contentMode:(UIViewContentMode)contentMode;

+ (UIImageView *)createImageView:(CGRect)frame
                           image:(UIImage *)image
                     contentMode:(UIViewContentMode)contentMode;

//TableView

+ (UITableView *)createTableView;

+ (UITableView *)createTableView:(CGRect)frame;

+ (UITableView *)createTableView:(CGRect)frame
                      dataSource:(id<UITableViewDataSource>)dataSource
                        delegete:(id<UITableViewDelegate>)delegate;

+ (UITableView *)createTableView:(CGRect)frame
                           style:(UITableViewStyle)style
                      dataSource:(id<UITableViewDataSource>)dataSource
                        delegete:(id<UITableViewDelegate>)delegate;

@end
