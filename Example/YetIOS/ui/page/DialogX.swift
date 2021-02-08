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

    fileprivate var buttons = [DialogAction]()
    public var titleView: UIView? = nil
    public var bodyView: UIView = UIView(frame: .zero)
    public var bodyParams: LinearParams = LinearParams().width(MatchParent).height(WrapContent)

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
        if !titleText.isEmpty {
            self.titleView = UILabel.Primary.text(titleText).align(.center).lines(1).backColor(Colors.backgroundTertiary).textColor(.white).font(Fonts.title)
        }
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

        view += LinearLayout(.vertical).backColor(Colors.backgroundSecondary).roundLayer(self.corner).apply { ll in
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
//            bodyView.backColor(.cyan)

            if !buttons.isEmpty {
                ll += UIView(frame: .zero).backColor(Colors.separator).linearParams(MatchParent, 1)
                ll += LinearLayout(.horizontal).linearParams(MatchParent, 46).apply { panel in
                    for (idx, item) in buttons.enumerated() {
                        if idx != 0 {
                            panel += UIView(frame: .zero).backColor(Colors.separator).linearParams(1, MatchParent)
                        }
                        panel += UIButton.Default.title(item.title).titleColor(item.color).linearParams(0, MatchParent) {
                            $0.weight = 1
                        }.click { [weak self] b in
                            self?.invokeAction(item)
                        }
                    }
                }
            }


        }.clickView { _ in
        }

    }

    private func invokeAction(_ item: DialogAction) {
        if item.autoClose {
            self.close()
        }
        item.callback()
        //回调有可能是强引用, 清除回调
        for a in self.buttons {
            a.callback = {
            }
        }
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.onDismiss()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let c = NotificationCenter.default
        c.addObserver(self, selector: #selector(keyboardWillShow(n:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        c.addObserver(self, selector: #selector(keyboardWillHide(n:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let c = NotificationCenter.default
        c.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        c.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    public func keyboardWillShow(n: Notification) {
        guard  let ed = self.view.findActiveEdit() else {
            return
        }
        let editRect = ed.screenFrame
        if let kbFrame: CGRect = n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let offset: CGFloat = editRect.origin.y + editRect.size.height - kbFrame.origin.y + 10
            if offset > 0 {
                let duration = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
                UIView.animate(withDuration: duration) {
                    self.view.frame = CGRect(x: 0.0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }
        }

    }

    @objc
    public func keyboardWillHide(n: Notification) {
        let duration: Double = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        UIView.animate(withDuration: duration) {
            self.view.frame = self.view.bounds
        }
    }

    public enum ActionStyle {
        case normal, cancel, ok, safe, danger, risk, accent
    }

    public class DialogAction {
        public var autoClose: Bool = true
        public var title: String
        public var color: UIColor = Theme.Text.primaryColor
        public var callback: BlockVoid = {
        }

        public init(_ title: String) {
            self.title = title
        }

        public convenience init(_ style: ActionStyle, _ title: String) {
            self.init(title)
            switch style {
            case .cancel, .normal:
                color = Theme.Text.primaryColor
            case .ok:
                color = Colors.link
            case .safe:
                color = Theme.safeColor
            case .risk, .danger:
                color = Theme.dangerColor
            case .accent:
                color = Theme.accent
            }
        }
    }

    public class DialogListX<T> {
        private var dlg: DialogX
        private var items: [T]
        private var imageBlock: ((T) -> UIImage?)? = nil
        private var align: NSTextAlignment = .left
        private var itemHeight: CGFloat = 52

        public init(_ dlg: DialogX, _ items: [T]) {
            self.dlg = dlg
            self.items = items
        }

        private lazy var binder: (T) -> UIView = { item in
            let title = self.transform(item)
            if let block = self.imageBlock {
                let img = block(item) //?.scaledTo(40)
                let v = ImageLabelView(frame: .zero).horizontal(margins:Edge().all(0), space: 1)
                v.labelView.text = title
                v.imageView.image = img
                return v
            } else {
                let v = TextItemView(frame: .zero)
                v.text = title
                v.textAlignment = self.align
                v.setupFeedback()
                return v
            }
        }

        private lazy var transform: (T) -> String = {
            return "\($0)"
        }
    }

    public class DialogGrid<T> {
        private var dlg: DialogX
        private var items: [T]
        private let panel = GridLayout(frame: .zero)
        private lazy var binder: (T) -> UIView = { item in
            if let imgBlock = self.imageBlock {
                let b = ImageLabelView(frame: .zero).vertical(margins: Edge().all(0), space: 1, labelHeight: 18)
                b.labelView.text = self.transform(item)
                b.imageView.image = imgBlock(item)
                return b
            } else {
                let b = TextItemView(frame: .zero).align(.center).stylePrimary()
                b.text = self.transform(item)
                return b
            }
        }

        private lazy var transform: (T) -> String = {
            return "\($0)"
        }
        private var imageBlock: ((T) -> UIImage)? = nil

        public init(_ dlg: DialogX, _ items: [T]) {
            self.dlg = dlg
            self.items = items
            self.panel.columns = 3
            self.panel.paddings = Edge().hor(8).ver(12)
            self.panel.spaceHor = 1
            self.panel.spaceVer = 8
            self.panel.setRowInfoDefault(value: 66, weight: 0)
        }


    }
}

public extension DialogX.DialogGrid {
    func show(_ block: @escaping (T) -> Void) {
        for item in items {
            let v = self.binder(item)
            v.clickView { a in
                a.findMyController()?.close()
                block(item)
            }
            v.gridParams { p in
//                p.height = 50
//                p.width = 50
                p.gravityX = .fill
                p.gravityY = .fill
            }
            panel += v
        }

        let totalH: CGFloat = panel.fixedHeight
        if totalH < 500 {
            self.dlg.body(self.panel)
            self.dlg.bodyParams.height = totalH
        } else {
            let sv = UIScrollView(frame: .zero)
            sv.addSubview(panel)
//            sv.constraintsInstall{ c in
//                c.edgesParent()
//            }
            panel.constraints { c in
                c.edgesParent()
                c.widthParent()
            }
            self.dlg.body(sv)
            self.dlg.bodyParams.height = 500

        }
        self.dlg.show()
    }

    func columns(_ n: Int) -> Self {
        self.panel.columns = n
        return self
    }

    func bind(_ block: @escaping (T) -> UIView) -> Self {
        self.binder = block
        return self
    }

    func map(_ block: @escaping (T) -> String) -> Self {
        self.transform = block
        return self
    }

    func image(_ block: @escaping (T) -> UIImage) -> Self {
        self.imageBlock = block
        return self
    }
}

public extension DialogX.DialogListX {
    func show(_ callback: @escaping (T) -> Void) {

        let panel = LinearLayout(.vertical)
        var first = true
        for item in items {
            if !first {
                panel.appendChild(UIView.SepratorLine, MatchParent, 1)
            }
            let v = self.binder(item)
            v.clickView { a in
                a.findMyController()?.close()
                callback(item)
            }
            panel.appendChild(v, MatchParent, itemHeight - 1)
            first = false
        }

        let totalH = panel.heightSumFixed
        if totalH < 500 {
            self.dlg.body(panel)
            self.dlg.bodyParams.height = totalH
        } else {
            let sv = UIScrollView(frame: .zero)
            sv.addSubview(panel)
            panel.constraints { p in
                p.edgesParent()
                p.widthParent()
            }
            self.dlg.body(sv)
            self.dlg.bodyParams.height = 500
        }
        self.dlg.show()
    }

    func itemHeight(_ h: CGFloat) -> Self {
        self.itemHeight = h
        return self
    }

    func image(_ block: @escaping (T) -> UIImage?) -> Self {
        self.imageBlock = block
        return self
    }

    func imageName(_ block: @escaping (T) -> String) -> Self {
        self.imageBlock = { item in
            return UIImage(named: block(item))
        }
        return self
    }

    func bind(_ block: @escaping (T) -> UIView) -> Self {
        self.binder = block
        return self
    }

    func map(_ block: @escaping (T) -> String) -> Self {
        self.transform = block
        return self
    }

    func align(_ a: NSTextAlignment) -> Self {
        self.align = a
        return self
    }
}

public extension DialogX {
    func showList<T>(items: [T], trans: @escaping (T) -> String, _ callback: @escaping (T) -> Void) {
        self.list(items).map(trans).show(callback)
    }

    func showList(items: [String], _ callback: @escaping (String) -> Void) {
        self.list(items).show(callback)
    }

    func list<T>(_ items: [T]) -> DialogListX<T> {
        return DialogX.DialogListX(self, items)
    }

    func grid<T>(_ items: [T]) -> DialogX.DialogGrid<T> {
        return DialogX.DialogGrid(self, items)
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
        let a = button(.cancel, text) {
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
        let a = DialogAction(style, text)
        a.callback = block
        dialogAction(a)
        return a
    }
}

public extension DialogX {
    @discardableResult
    func message(_ msg: String) -> Self {
        let v = UILabel.Primary.text(msg).lines(0).align(.center)
        if msg.count > 20 {
            v.align(.left)
        }

        bodyView = v
        bodyParams.minHeight = 80
        bodyParams.margins = Edge().hor(20).ver(20)
        return self
    }

    @discardableResult
    func input(_ text: String = "") -> Self {
        let edit = UITextField.Round
        edit.text = text
        edit.returnDone()
        bodyParams.height = Theme.Edit.height
        bodyParams.margins.hor(20).ver(10)
        self.body(edit)
        return self
    }
}


public extension DialogX {
    func showAlert(_ msg: String) {
        self.showAlert(msg: msg, {})
    }

    func showAlert(msg: String, _ closeCallback: @escaping BlockVoid) {
        self.showAlert(title: "", msg: msg, closeCallback)
    }

    func showAlert(title: String, msg: String) {
        self.showAlert(title: title, msg: msg, {})
    }

    func showAlert(title: String, msg: String, _ closeCallback: @escaping BlockVoid) {
        self.title(title)
        self.message(msg)
        self.cancel("确定")
        self.onDismiss = closeCallback
        self.show()
    }

    func showConfirm(msg: String, _ okCallback: @escaping BlockVoid) {
        self.message(msg)
        self.cancel()
        self.button("确定", okCallback)
        self.show()
    }

    func showConfirm(title: String, msg: String, _ okCallback: @escaping BlockVoid) {
        self.title(title)
        self.message(msg)
        self.cancel()
        self.button("确定", okCallback)
        self.show()
    }

    func showInput(title: String, text: String, _ okCallback: @escaping (String) -> Void) {
        self.title(title)
        self.input(text)
        self.cancel()
        self.button("确定") { [weak self] in
            okCallback(self?.textField?.text?.trimed ?? "")
        }.accent()
        self.show()
    }
}


public extension DialogX.DialogAction {

    func risk() {
        color = Theme.dangerColor
    }

    func safe() {
        color = Theme.safeColor
    }

    func accent() {
        color = Theme.accent
    }

    func normal() {
        color = Theme.Text.primaryColor
    }
}

public extension UIViewController {
    var dialog: DialogX {
        return DialogX(self)
    }

    func alert(_ msg: String) {
        self.dialog.showAlert(msg)
    }

    func alert(_ msg: String, _ block: @escaping BlockVoid) {
        self.dialog.showAlert(msg: msg, block)
    }
}
