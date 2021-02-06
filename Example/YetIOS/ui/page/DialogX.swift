//
// Created by yangentao on 2021/2/6.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public class DialogX: UIViewController {
    fileprivate weak var superPage: UIViewController? = nil
    fileprivate var marginX: CGFloat = 30
    fileprivate var corner: CGFloat = 12
    fileprivate var gravityY: GravityY = .center

    fileprivate var titleView: UIView? = nil
    fileprivate var buttons = [DialogAction]()
    fileprivate var bodyView: UIView = UIView(frame: .zero)
    var bodyParams: LinearParams = LinearParams().width(MatchParent).height(WrapContent)

    public var onDismiss: BlockVoid = {
    }

    public init(_ superPage: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.superPage = superPage
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @discardableResult
    public func title(_ titleText: String) -> Self {
        self.titleView = UILabel.Primary.text(titleText).align(.center).lines(1).backColor(Theme.themeColor).textColor(.white).font(Fonts.title)
        return self
    }


    @discardableResult
    public func body<T: UIView>(_ bodyView: T) -> T {
        self.bodyView = bodyView
        return bodyView
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.rgba(0, 0, 0, 50)
        self.view.frame = Rect(x: 20, y: 100, width: 200, height: 200)
        self.view.clickView { [weak self] _ in
            self?.dismiss(animated: true)
        }

        view += LinearLayout(.vertical).backColor(Theme.dialogBack).roundLayer(self.corner).apply { ll in
            ll.constraints {
                $0.centerParent()
                $0.width.geConst(200)
                $0.width.leConst(350)
                $0.width.eqParent(constant: -marginX * 2).priority(.defaultHigh)
            }
            ll.keepContent(.vertical)

            if let v = titleView {
                ll += v.linearParams(MatchParent, 46)
            }
            ll.addView(bodyView).linearParams = bodyParams
            bodyView.backColor(.cyan)

            if !buttons.isEmpty {
                ll += UIView(frame: .zero).backColor(Colors.separator).linearParams(MatchParent, 1)
                ll += LinearLayout(.horizontal).linearParams(MatchParent, 46).backColor(.blue).apply { panel in
                    for (idx, item) in buttons.enumerated() {
                        if idx != 0 {
                            panel += UIView(frame: .zero).backColor(Colors.separator).linearParams(1, MatchParent)
                        }
                        panel += UIButton.Default.title(item.title).backColor(.green).titleColor(item.color).linearParams(0, MatchParent) {
                            $0.weight = 1
                        }.click { [weak self] b in
                            if item.autoClose {
                                self?.close()
                            }
                            item.callback()
                        }
                    }
                }
            }


        }.clickView { _ in
        }

    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task.foreDelay(seconds: 5) {
//            self.dismiss(animated: true)
        }
    }


}

public extension DialogX {
    func show() {
        self.superPage?.present(self)
    }

    var textField: UITextField? {
        return view.firstView {
            $0 is UITextField
        } as? UITextField
    }
}

public extension DialogX {
    func dialogAction(_ a: DialogAction) {
        buttons.append(a)
    }

    @discardableResult
    func cancel(_ text: String = "取消") -> DialogAction {
        let a = button(text) {
        }
        return a
    }

    @discardableResult
    func button(_ text: String, _ block: @escaping BlockVoid) -> DialogAction {
        let a = DialogAction(text)
        a.callback = block
        dialogAction(a)
        return a
    }

    @discardableResult
    func button(_ style: ActionStyle, _ text: String, _ block: @escaping BlockVoid) -> DialogAction {
        let a = DialogAction(text)
        a.theme(style)
        a.callback = block
        dialogAction(a)
        return a
    }
}

public extension DialogX {
    @discardableResult
    func message(_ msg: String) -> DialogX {
        let v = UILabel.Primary.text(msg).lines(0).alignCenter()
        if msg.count > 20 {
            v.align(.left)
        }

        bodyView = v
        bodyParams.minHeight = 80
        bodyParams.margins = Edge().hor(20).ver(20)
        return self
    }
}
