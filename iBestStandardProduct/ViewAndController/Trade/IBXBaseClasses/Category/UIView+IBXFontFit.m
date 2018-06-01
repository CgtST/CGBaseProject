   //
//  UIView+IBXFontFit.m
//  QNApp
//
//  Created by xboker on 2017/3/29.
//  Copyright © 2017年 zscf. All rights reserved.
///
//

#import "UIView+IBXFontFit.h"
#import <objc/runtime.h>




@implementation UIView (IBXFontFit)

///无需实现功能, 静置

@end



@interface UIFont (IBXFontFit)

@end

@implementation UIFont (IBXFontFit)

+ (void)load {
    Method systemFont = class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
    Method mySystemFont  = class_getClassMethod([UIFont class], @selector(mySystemFontOfSize:));
    method_exchangeImplementations(systemFont, mySystemFont);
}

+ (UIFont *)mySystemFontOfSize:(CGFloat)fontSize {
    if (IS_320_WIDTH) {
        return [UIFont mySystemFontOfSize:fontSize * 0.84];
    }else if (IS_375_WIDTH) {
        return [UIFont mySystemFontOfSize:fontSize * 0.9];
    }else {
        return [UIFont mySystemFontOfSize:fontSize ];
    }
}

@end



@interface UILabel(IBXFontFit)

@end

@implementation UILabel (IBXFontFit)

+ (void)load {

    Method coderImp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myCoderImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(coderImp, myCoderImp);
    
    Method frameImpe  = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myFrameImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(frameImpe, myFrameImp);

}


- (id)myInitWithCoder:(NSCoder *)coder {
    [self myInitWithCoder:coder];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        if (IS_320_WIDTH) {
            self.font = [self.font fontWithSize:round(0.84 * fontNow)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
  
        }
    }
    return self;
}


- (id)myInitWithFrame:(CGRect)frame {
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        if (IS_320_WIDTH) {
            self.font = [self.font fontWithSize:round(0.84 * fontNow)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
        }
    }
    return self;
}




@end



@interface UIButton(IBXFontFit)

@end

@implementation UIButton (IBXFontFit)

+ (void)load {
    Method coderImp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myCoderImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(coderImp, myCoderImp);
    
    Method frameImpe  = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myFrameImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(frameImpe, myFrameImp);
}

- (id)myInitWithCoder:(NSCoder *)coder {
    [self myInitWithCoder:coder];
    if (self) {
        CGFloat fontNow = self.titleLabel.font.pointSize;
        if (IS_320_WIDTH) {
            self.font = [self.titleLabel.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
   
        }
        
    }
    return self;
}


- (id)myInitWithFrame:(CGRect)frame {
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontNow = self.titleLabel.font.pointSize;
        if (IS_320_WIDTH) {
            self.font = [self.titleLabel.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
        }
    }
    return self;
}

@end


@interface UITextField(IBXFontFit)

@end

@implementation UITextField (IBXFontFit)

+ (void)load {
    Method coderImp     = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myCoderImp   = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(coderImp, myCoderImp);
    
    
    Method frameImpe    = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myFrameImp   = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(frameImpe, myFrameImp);
    
}

- (id)myInitWithCoder:(NSCoder *)coder {
    [self myInitWithCoder:coder];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        
        if (IS_320_WIDTH) {
            self.font       = [self.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
        }
    }
    return self;
}


- (id)myInitWithFrame:(CGRect)frame {
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        if (IS_320_WIDTH) {
            self.font       = [self.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        } else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
        
        }
    }
    return self;
}

@end



@interface UITextView(IBXFontFit)

@end

@implementation UITextView (IBXFontFit)

+ (void)load {
    Method coderImp     = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myCoderImp   = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(coderImp, myCoderImp);
    
    
    Method frameImpe    = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myFrameImp   = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(frameImpe, myFrameImp);

}

- (id)myInitWithCoder:(NSCoder *)coder {
    [self myInitWithCoder:coder];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        if (IS_320_WIDTH) {
            self.font       = [self.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];
        }
    }
    return self;
}


- (id)myInitWithFrame:(CGRect)frame {
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontNow = self.font.pointSize;
        if (IS_320_WIDTH) {
            self.font       = [self.font fontWithSize:round(fontNow * 0.84)];
        }else if (IS_375_WIDTH) {
            self.font = [self.font fontWithSize:round(0.9 * fontNow)];
        }else {
            self.font = [self.font fontWithSize:round(1 * fontNow)];

        }
    }
    return self;
}

@end














