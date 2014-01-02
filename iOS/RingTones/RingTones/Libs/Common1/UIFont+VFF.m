//
//  UIFont+HeinekenFont.m
//  HeinikenLAC
//
//  Created by Duc Nguyen on 5/26/13.
//  Copyright (c) 2013 Bizzon Limited Company. All rights reserved.
//

#import "UIFont+VFF.h"

@implementation UIFont (HeinekenFont)




+(UIFont *) helveticaNeueMediumFontSize:(CGFloat) fontSize
{
    return [self fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}


+(UIFont *) helveticaNeueBoldFontSize:(CGFloat) fontSize
{
    return [self fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}


+(UIFont *) helveticaNeueCondensedBoldFontSize:(CGFloat) fontSize
{
    return [self fontWithName:@"HelveticaNeue-CondensedBold" size:fontSize];
}

+(UIFont *) helveticaNeueRegularFontSize:(CGFloat) fontSize
{
    return [self fontWithName:@"HelveticaNeue" size:fontSize];
}


+(UIFont *) helveticaNeueLightFontSize:(CGFloat) fontSize
{
    return [self fontWithName:@"HelveticaNeue-Light" size:fontSize];
}



@end
