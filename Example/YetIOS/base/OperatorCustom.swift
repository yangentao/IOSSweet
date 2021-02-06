//
// Created by yangentao on 2021/2/6.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation

//addALL
infix operator ++=: ComparisonPrecedence

//IN
infix operator =*: ComparisonPrecedence
//NOT IN
infix operator !=*: ComparisonPrecedence

//pair, allow nil
infix operator >>: ComparisonPrecedence

//pair, NOT allow nil
infix operator =>: ComparisonPrecedence