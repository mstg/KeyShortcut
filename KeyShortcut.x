/* Created by Mustafa Gezen on 23.04.2014 */
#include "KeyShortcut.h"

%hook UIKeyboardLayoutStar
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        pasteboard = [UIPasteboard generalPasteboard];
        touch = [touches anyObject];
        key = [[[self keyHitTest:[touch locationInView:touch.view]] representedString] lowercaseString];

        UIKeyboardImpl *impl = [%c(UIKeyboardImpl) activeInstance];

        delegate = impl.privateInputDelegate ?: impl.inputDelegate;
        isLongPressed = [impl isLongPress];

        if (isLongPressed) {
            // A: Select all
            if ([key isEqualToString:@"a"]) {
                if ([delegate respondsToSelector:@selector(selectAll:)]) {
                    [delegate selectAll:nil];

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                } else if ([delegate respondsToSelector:@selector(selectAll)]) {
                    [delegate selectAll];

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            // C: Copy marked text
            } else if ([key isEqualToString:@"c"]) {
                if ([delegate respondsToSelector:@selector(selectedTextRange)]) {
                    range = [delegate selectedTextRange];
                    textRange = [delegate textInRange:range];

                    [pasteboard setString:textRange];

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            // X: Cut marked text
            } else if ([key isEqualToString:@"x"]) {
                if ([delegate respondsToSelector:@selector(selectedTextRange)]) {
                    range = [delegate selectedTextRange];
                    textRange = [delegate textInRange:range];

                    [pasteboard setString:textRange];

                    [impl deleteFromInput];
                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            // V: Paste marked text
            } else if ([key isEqualToString:@"v"]) {
                if ([delegate respondsToSelector:@selector(selectedTextRange)]) {
                    copiedtext = [pasteboard string];

                    if (copiedtext) {
                        [impl insertText:copiedtext];
                    }

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            // Z: Undo
            } else if ([key isEqualToString:@"z"]) {
                if ([[delegate undoManager] canUndo]) {
                    [[delegate undoManager] undo];

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            // R: Redo
            } else if ([key isEqualToString:@"r"]) {
                if ([[delegate undoManager] canRedo]) {
                    [[delegate undoManager] redo];

                    [impl clearTransientState];
                    [impl clearAnimations];

                    return;
                }
            }
        }

        %orig;
    }
%end

%ctor {
    dlopen("/Library/MobileSubstrate/DynamicLibraries/SwipeSelection.dylib", RTLD_NOW);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/SwipeSelectionPro.dylib", RTLD_NOW);
}
