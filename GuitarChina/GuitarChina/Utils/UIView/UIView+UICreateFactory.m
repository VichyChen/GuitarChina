
#import "UIView+UICreateFactory.h"

@implementation UIView (UICreateFactory)

#pragma mark - Label

+ (UILabel *)createLabel {
    return [[UILabel alloc] initWithFrame:CGRectZero];
}

+ (UILabel *)createLabel:(CGRect)frame {
    return [[UILabel alloc] initWithFrame:frame];
}

+ (UILabel *)createLabel:(CGRect)frame
                    text:(NSString *)text
                    font:(UIFont *)font
               textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    
    return label;
}

+ (UILabel *)createLabel:(CGRect)frame
                    text:(NSString *)text
                    font:(UIFont *)font
               textColor:(UIColor *)textColor
           numberOfLines:(NSInteger)numberOfLines
 preferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    
    return label;
}

#pragma mark - TextField

+ (UITextField *)createTextField {
    return [[UITextField alloc] initWithFrame:CGRectZero];
}

+ (UITextField *)createTextField:(CGRect)frame {
    return [[UITextField alloc] initWithFrame:frame];
}

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    
    return textField;
}

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle
                     placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    textField.placeholder = placeholder;
    
    return textField;
}

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle
                            text:(NSString *)text
                       textColor:(UIColor *)color
                     placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    textField.placeholder = placeholder;
    
    return textField;
}

+ (UITextField *)createTextField:(CGRect)frame
                     borderStyle:(UITextBorderStyle)borderStyle
                            text:(NSString *)text
                       textColor:(UIColor *)color
                     placeholder:(NSString *)placeholder
                   textAlignment:(NSTextAlignment)textAlignment {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    textField.placeholder = placeholder;
    textField.textAlignment = textAlignment;
    
    return textField;
}

#pragma mark - Button

+ (UIButton *)createButton {
    return [[UIButton alloc] initWithFrame:CGRectZero];
}

+ (UIButton *)createButton:(CGRect)frame {
    return [[UIButton alloc] initWithFrame:frame];
}

+ (UIButton *)createButton:(CGRect)frame
                      text:(NSString *)text {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton *)createButton:(CGRect)frame
                    target:(id)target
                    action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButton:(CGRect)frame
                      text:(NSString *)text
                    target:(id)target
                    action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButton:(CGRect)frame
                buttonType:(UIButtonType)buttonType
                      text:(NSString *)text
                    target:(id)target
                    action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark TextView

+ (UITextView *)createTextView {
    return [[UITextView alloc] initWithFrame:CGRectZero];
}

+ (UITextView *)createTextView:(CGRect)frame {
    return [[UITextView alloc] initWithFrame:frame];
}

#pragma mark - ImageView

+ (UIImageView *)createImageView {
    return [[UIImageView alloc] initWithFrame:CGRectZero];
}

+ (UIImageView *)createImageView:(CGRect)frame {
    return [[UIImageView alloc] initWithFrame:frame];
}

+ (UIImageView *)createImageView:(CGRect)frame
                     contentMode:(UIViewContentMode)contentMode {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = contentMode;
    
    return imageView;
}

+ (UIImageView *)createImageView:(CGRect)frame
                           image:(UIImage *)image
                     contentMode:(UIViewContentMode)contentMode {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.contentMode = contentMode;
    
    return imageView;
}

#pragma mark - TableView

+ (UITableView *)createTableView {
    return [[UITableView alloc] initWithFrame:CGRectZero];
}

+ (UITableView *)createTableView:(CGRect)frame {
    return [[UITableView alloc] initWithFrame:frame];
}

+ (UITableView *)createTableView:(CGRect)frame
                      dataSource:(id<UITableViewDataSource>)dataSource
                        delegete:(id<UITableViewDelegate>)delegate {
    return [UIView createTableView:frame
                             style:UITableViewStylePlain
                        dataSource:dataSource
                          delegete:delegate];
}

+ (UITableView *)createTableView:(CGRect)frame
                           style:(UITableViewStyle)style
                      dataSource:(id<UITableViewDataSource>)dataSource
                        delegete:(id<UITableViewDelegate>)delegate {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    
    return tableView;
}

#pragma mark - Line

+ (UIView *)createHorizontalLine:(CGFloat)length
                         originX:(CGFloat)originX
                         originY:(CGFloat)originY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, length, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

+ (UIView *)createHorizontalLine:(CGFloat)length
                         originX:(CGFloat)originX
                         originY:(CGFloat)originY
                           color:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, length, 1)];
    view.backgroundColor = color;
    
    return view;
}

+ (UIView *)createVerticalLine:(CGFloat)length
                       originX:(CGFloat)originX
                       originY:(CGFloat)originY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 1, length)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

+ (UIView *)createVerticalLine:(CGFloat)length
                       originX:(CGFloat)originX
                       originY:(CGFloat)originY
                         color:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 1, length)];
    view.backgroundColor = color;
    
    return view;
}

#pragma mark - BarButtonItem

+ (UIBarButtonItem *)createCustomBarButtonItem:(NSString *)image
                                   normalColor:(UIColor *)normalColor
                              highlightedColor:(UIColor *)highlightedColor
                                        target:(id)target
                                        action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    button.adjustsImageWhenHighlighted = YES;
    [button setImage:[[UIImage imageNamed:image] imageWithTintColor:normalColor]
            forState:UIControlStateNormal];
    [button setImage:[[UIImage imageNamed:image] imageWithTintColor:highlightedColor]
            forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

@end
