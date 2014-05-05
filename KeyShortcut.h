/* Created by Mustafa Gezen on 23.04.2014 */
#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIKeyboardInput.h>
#import <UIKit/UITextInput.h>

@interface UIKeyboardImpl : UIView
    + (UIKeyboardImpl*)activeInstance;
    - (BOOL)isLongPress;
    - (void)handleDelete;
    - (void)insertText:(id)text;
    - (void)clearAnimations;
    - (void)clearTransientState;
    - (void)deleteFromInput;
    @property (readonly, assign, nonatomic) UIResponder <UITextInputPrivate> *privateInputDelegate;
    @property (readonly, assign, nonatomic) UIResponder <UITextInput> *inputDelegate;
    @property(readonly, nonatomic) id <UIKeyboardInput> legacyInputDelegate;
@end

@interface UIKBShape : NSObject
@end

@interface UIKBKey : UIKBShape
    @property(copy) NSString * representedString;
@end

static BOOL isLongPressed = false;
static UIPasteboard *pasteboard;
static NSString *copiedtext;
static id delegate;
static UITextRange *range;
static NSString *textRange;
static NSString *key;
static UITouch *touch;
