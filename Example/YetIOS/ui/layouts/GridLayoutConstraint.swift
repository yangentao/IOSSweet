//
// Created by entaoyang on 2019-02-12.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class GridLayoutConstraint {
    public unowned var view: UIView
    private var childViews = [UIView]()
    public var edge: Edge = Edge()
    public var cellWidth: CGFloat = 80
    public var cellHeight: CGFloat = 80
    public var verticalSpace: CGFloat = 8
    public var columns: Int = 4 {
        didSet {
            if columns < 1 {
                self.columns = 1
            }
        }
    }

    public init(_ v: UIView) {
        self.view = v
    }

    public func edge(l: CGFloat, t: CGFloat, r: CGFloat, b: CGFloat) {
        self.edge.left = l
        self.edge.top = t
        self.edge.right = r
        self.edge.bottom = b
    }

    public func cellSize(_ w: CGFloat, _ h: CGFloat) {
        self.cellWidth = w
        self.cellHeight = h
    }

    public func add(_ v: UIView) {
        childViews.append(v)
    }

    public var rowCount: Int {
        let c = self.childViews.count
        return c / self.columns + (c % self.columns == 0 ? 0 : 1)
    }

    public var totalHeight: CGFloat {
        var a: CGFloat = edge.top + edge.bottom
        let rows = self.rowCount
        if rows > 0 {
            a += self.cellHeight * rows
            a += self.verticalSpace * (rows - 1)
        }
        return a
    }

    public func install(_ isScrollContentView: Bool = false) {
        for n in childViews.indices {
            let v = childViews[n]
            self.view.addSubview(v)
            //from 0
            let row = (n + 1) / self.columns + ((n + 1) % self.columns == 0 ? 0 : 1) - 1
            //from 0
            let col = n % self.columns
            let L = v.layout
            L.size(self.cellWidth, self.cellHeight)
            L.topParent(edge.top + self.cellHeight * row + self.verticalSpace * row)
            //v.left = edge.left + col * cellWidth + col * horSpace
            //Parent.right(width) = edge.left + edge.right + self.columns * self.cellWidth + (self.columns -1) * horSpace
            //let X = edge.left + edge.right + self.columns * self.cellWidth
            //P.right = X + (self.columns -1) * horSpace
            //=> horSpace = (P.right - X ) / (self.columns -1)
            //=> v.left = edge.left + col * cellWidth + col * (P.right - X ) / (self.columns -1)
            // let Y = col / (self.columns -1)
            // v.left =  edge.left + col * cellWidth + Y * p.right - X * Y
            //v.left = P.right * Y + edge.left + col * cellWidth  - X * Y

            if self.columns <= 1 {
                L.centerXParent()
            } else if col == 0 {
                L.leftParent(self.edge.left)
            } else {
                let X = self.edge.left + self.edge.right + self.cellWidth * self.columns
                let Y: CGFloat = col.f / (self.columns - 1).f
                L.left.eqParent(.right).multi(Y).constant(self.edge.left + self.cellWidth * col - X * Y).active()
            }

        }
        if isScrollContentView {
            if let v = self.childViews.last {
                v.layout.bottomParent(-self.edge.bottom)
            }
        }
    }

}

public extension UIView {
    var layoutGridConstraint: GridLayoutConstraint {
        return GridLayoutConstraint(self)
    }
}