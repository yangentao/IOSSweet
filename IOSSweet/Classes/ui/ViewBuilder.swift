//
// Created by yangentao on 2021/1/31.
//

import Foundation
import UIKit
import SwiftSweet

public var MStackView: UIStackView {
    UIStackView(frame: .zero)
}
public var HStackView: UIStackView {
    MStackView.axis(.horizontal)
}
public var VStackView: UIStackView {
    MStackView.axis(.vertical)
}

public func HStack(dist: UIStackView.Distribution, align: UIStackView.Alignment) -> UIStackView {
    MStackView.axis(.horizontal).distribution(dist).align(align)
}

public func VStack(dist: UIStackView.Distribution, align: UIStackView.Alignment) -> UIStackView {
    MStackView.axis(.vertical).distribution(dist).align(align)
}

public extension UIStackView {
    func axis(_ ax: NSLayoutConstraint.Axis) -> Self {
        self.axis = ax
        return self
    }

    func distribution(_ d: UIStackView.Distribution) -> Self {
        self.distribution = d
        return self
    }

    func align(_ a: UIStackView.Alignment) -> Self {
        self.alignment = a
        return self
    }

    func space(_ n: CGFloat) -> Self {
        self.spacing = n
        return self
    }

    func arrange(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let b = block()
        let viewList: [UIView] = b.itemsTyped()
        let ls = viewList.filter {
            $0 !== self
        }
        for childView in ls {
            addArrangedSubview(childView)
        }
        return self
    }
}


public var MLabel: UILabel {
    UILabel(frame: .zero)
}

public var MActivityIndicatorView: UIActivityIndicatorView {
    UIActivityIndicatorView(frame: .zero)
}

//public var  MAlertView: UIAlertView {
//    UIAlertView(frame: .zero)
//}

public var MCollectionReusableView: UICollectionReusableView {
    UICollectionReusableView(frame: .zero)
}
public var MControl: UIControl {
    UIControl(frame: .zero)
}

public var MImageView: UIImageView {
    UIImageView(frame: .zero)
}

public var MInputView: UIInputView {
    UIInputView(frame: .zero, inputViewStyle: UIInputView.Style.default)
}

public var MNavigationBar: UINavigationBar {
    UINavigationBar(frame: .zero)
}

public var MPickerView: UIPickerView {
    UIPickerView(frame: .zero)
}

public var MPopoverBackgroundView: UIPopoverBackgroundView {
    UIPopoverBackgroundView(frame: .zero)
}


public var MProgressView: UIProgressView {
    UIProgressView(frame: .zero)
}

public var MScrollView: UIScrollView {
    UIScrollView(frame: .zero)
}

public var MSearchBar: UISearchBar {
    UISearchBar(frame: .zero)
}


public var MTabBar: UITabBar {
    UITabBar(frame: .zero)
}

public var MTableViewCell: UITableViewCell {
    UITableViewCell(frame: .zero)
}

public var MTableViewHeaderFooterView: UITableViewHeaderFooterView {
    UITableViewHeaderFooterView(frame: .zero)
}

public var MToolbar: UIToolbar {
    UIToolbar(frame: .zero)
}


public var MVisualEffectView: UIVisualEffectView {
    UIVisualEffectView(frame: .zero)
}

//public var  MWebView: UIWebView {
//    UIWebView(frame: .zero)
//}

public var MCollectionView: UICollectionView {
    UICollectionView(frame: .zero)
}

public var MTableView: UITableView {
    UITableView(frame: .zero)
}

public var MTextView: UITextView {
    UITextView(frame: .zero)
}


public var MButton: UIButton {
    UIButton(frame: .zero)
}


public var MDatePicker: UIDatePicker {
    UIDatePicker(frame: .zero)
}


public var MPageControl: UIPageControl {
    UIPageControl(frame: .zero)
}


public var MRefreshControl: UIRefreshControl {
    UIRefreshControl(frame: .zero)
}


public var MSegmentedControl: UISegmentedControl {
    UISegmentedControl(frame: .zero)
}


public var MSlider: UISlider {
    UISlider(frame: .zero)
}


public var MStepper: UIStepper {
    UIStepper(frame: .zero)
}


public var MSwitch: UISwitch {
    UISwitch(frame: .zero)
}


public var MTextField: UITextField {
    UITextField(frame: .zero)
}


//public var  MSearchTextField: UISearchTextField {
//    UISearchTextField(frame: .zero)
//}


public var MCollectionViewCell: UICollectionViewCell {
    UICollectionViewCell(frame: .zero)
}

