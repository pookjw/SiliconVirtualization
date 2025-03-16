//
//  EditMachineNumberTextField.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineNumberTextField.h"

@interface EditMachineNumberTextField () <NSTextViewDelegate>
@end

@implementation EditMachineNumberTextField

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSString *oldString = textView.string;
    NSString *newString = [oldString stringByReplacingCharactersInRange:affectedCharRange withString:replacementString];
    
    if (newString.length == 0) return YES;
    
    if (self.allowsDoubleValue) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        BOOL isNumber = [formatter numberFromString:newString] != nil;
        [formatter release];
        return isNumber;
    } else {
        NSCharacterSet *searchSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *trimmedString = [newString stringByTrimmingCharactersInSet:searchSet];
        return newString.length == trimmedString.length;
    }
}


@end
