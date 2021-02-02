//
// Created by yangentao on 2021/1/30.
//

import Foundation
import UIKit


public class ConstraintsBuilder {
    unowned var view: UIView
    var items:[ConstraintItem] = []

    init(_ view: UIView) {
        self.view = view
    }
}

public extension ConstraintsBuilder {

    func append(_ item: ConstraintItem) -> ConstraintsBuilder {
        item.itemView = view
        items.append(item)
        return self
    }

    //center
    @discardableResult
    func centerXOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewCenterX.eq(viewName).constant(constant))
    }


    @discardableResult
    func centerYOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewCenterY.eq(viewName).constant(constant))
    }


    //relative position
    @discardableResult
    func toLeftOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewRight.eq(viewName, .left).constant(constant))
    }

    @discardableResult
    func toRightOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewLeft.eq(viewName, .right).constant(constant))
    }

    @discardableResult
    func below(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewTop.eq(viewName, .bottom).constant(constant))
    }

    @discardableResult
    func above(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewBottom.eq(viewName, .top).constant(constant))
    }


    //edges


    @discardableResult
    func leftOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewLeft.eq(viewName).constant(constant))
    }


    @discardableResult
    func rightOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewRight.eq(viewName).constant(constant))
    }


    @discardableResult
    func topOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewTop.eq(viewName).constant(constant))
    }


    @discardableResult
    func bottomOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewBottom.eq(viewName).constant(constant))
    }


    @discardableResult
    func fillXOf(_ viewName: String, _ leftConstant: CGFloat = 0, _ rightConstant: CGFloat = 0) -> ConstraintsBuilder {
        leftOf(viewName, leftConstant)
        return rightOf(viewName, rightConstant)
    }


    @discardableResult
    func fillYOf(_ viewName: String, _ topConstant: CGFloat = 0, _ bottomConstant: CGFloat = 0) -> ConstraintsBuilder {
        topOf(viewName, topConstant)
        return bottomOf(viewName, bottomConstant)
    }


    //height
    @discardableResult
    func heightOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewHeight.eq(viewName).constant(constant))
    }


    @discardableResult
    func heightLe(_ width: CGFloat) -> ConstraintsBuilder {
        append(ViewHeight.le(width))
    }

    @discardableResult
    func heightGe(_ height: CGFloat) -> ConstraintsBuilder {
        append(ViewHeight.ge(height))
    }

    @discardableResult
    func height(_ height: CGFloat) -> ConstraintsBuilder {
        append(ViewHeight.eq(height))
    }

    @discardableResult
    func heightEdit() -> ConstraintsBuilder {
        height(ControlSize.editHeight)
    }

    @discardableResult
    func heightText() -> ConstraintsBuilder {
        height(ControlSize.textHeight)
    }

    @discardableResult
    func heightButton() -> ConstraintsBuilder {
        height(ControlSize.buttonHeight)
    }


    //width
    @discardableResult
    func widthOf(_ viewName: String, _ constant: CGFloat = 0) -> ConstraintsBuilder {
        append(ViewWidth.eq(viewName).constant(constant))
    }


    @discardableResult
    func widthLe(_ width: CGFloat) -> ConstraintsBuilder {
        append(ViewWidth.le(width))
    }

    @discardableResult
    func widthGe(_ width: CGFloat) -> ConstraintsBuilder {
        append(ViewWidth.ge(width))
    }

    @discardableResult
    func width(_ width: CGFloat) -> ConstraintsBuilder {
        append(ViewWidth.eq(width))
    }

    @discardableResult
    func size(_ sz: CGFloat) -> ConstraintsBuilder {
        width(sz).height(sz)
    }

    @discardableResult
    func size(_ w: CGFloat, _ h: CGFloat) -> ConstraintsBuilder {
        width(w).height(h)
    }

    @discardableResult
    func widthFit(_ c: CGFloat = 0) -> ConstraintsBuilder {
        let sz = view.sizeThatFits(CGSize.zero)
        width(sz.width + c)
        return self
    }

    @discardableResult
    func heightFit(_ c: CGFloat = 0) -> ConstraintsBuilder {
        let sz = view.sizeThatFits(CGSize.zero)
        height(sz.height + c)
        return self
    }

    @discardableResult
    func sizeFit() -> ConstraintsBuilder {
        let sz = view.sizeThatFits(CGSize.zero)
        width(sz.width)
        height(sz.height)
        return self
    }

    @discardableResult
    func heightByScreen(_ c: CGFloat = 0) -> ConstraintsBuilder {
        let sz = view.sizeThatFits(Size(width: UIScreen.width, height: 0))
        height(sz.height + c)
        return self
    }
}

public extension ConstraintsBuilder {
    @discardableResult
    func centerXParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        centerXOf(ParentViewName, constant)
    }

    @discardableResult
    func centerYParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        centerYOf(ParentViewName, constant)
    }

    @discardableResult
    func centerParent(_ xConstant: CGFloat = 0, _ yConstant: CGFloat = 0) -> ConstraintsBuilder {
        centerXParent(xConstant)
        return centerYParent(yConstant)
    }

    @discardableResult
    func leftParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        leftOf(ParentViewName, constant)
    }

    @discardableResult
    func rightParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        rightOf(ParentViewName, constant)
    }

    @discardableResult
    func topParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        topOf(ParentViewName, constant)
    }

    @discardableResult
    func bottomParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        bottomOf(ParentViewName, constant)
    }

    @discardableResult
    func fillX(_ leftConstant: CGFloat = 0, _ rightConstant: CGFloat = 0) -> ConstraintsBuilder {
        fillXOf(ParentViewName, leftConstant, rightConstant)
    }

    @discardableResult
    func fillY(_ topConstant: CGFloat = 0, _ bottomConstant: CGFloat = 0) -> ConstraintsBuilder {
        fillYOf(ParentViewName, topConstant, bottomConstant)
    }

    @discardableResult
    func fill(leftConstant: CGFloat = 0, rightConstant: CGFloat = 0, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0) -> ConstraintsBuilder {
        fillX(leftConstant, rightConstant)
        return fillY(topConstant, bottomConstant)
    }

    @discardableResult
    func heightParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        heightOf(ParentViewName, constant)
    }

    @discardableResult
    func widthParent(_ constant: CGFloat = 0) -> ConstraintsBuilder {
        widthOf(ParentViewName, constant)
    }

}
