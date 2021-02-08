//
// Created by entaoyang on 2019-02-12.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public class Dialog: UIViewController {
    fileprivate weak var superPage: UIViewController? = nil
    fileprivate var marginX: CGFloat = 30
    fileprivate var corner: CGFloat = 16
    fileprivate var gravityY: GravityY = .center

    fileprivate var titleView: UIView? = nil
    fileprivate var buttons = [DialogX.DialogAction]()
    fileprivate var bodyView: UIView? = nil
    fileprivate var bodyHeight: CGFloat = 0
    fileprivate var bodyEdge: Edge = Edge(left: 20, top: 10, right: 20, bottom: 10)

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

    public var textField: UITextField? {
        return view.firstView {
            $0 is UITextField
        } as? UITextField
    }

    @discardableResult
    public func gravity(_ g: GravityY) -> Dialog {
        switch g {
        case .center, .none:
            self.gravityY = .center
        case .top, .bottom, .fill:
            self.gravityY = g
            self.marginX = 0
            self.corner = 0
        }
        return self
    }

    @discardableResult
    public func input(_ text: String = "") -> Dialog {
        let edit = UITextField.Round
        edit.text = text
        edit.returnDone()
        bodyHeight = Theme.Edit.height
        self.body(edit)
        return self
    }

    @discardableResult
    public func message(_ msg: String) -> Dialog {
        let v = UILabel.Primary.backColor(Colors.fill).text(msg).lines(0).align(.center)
        body(v)
        return self
    }

    public func body(_ bodyView: UIView) {
        self.bodyView = bodyView
    }

    public func bodyEdge(_ l: CGFloat, _ t: CGFloat, _ r: CGFloat, _ b: CGFloat) -> Dialog {
        self.bodyEdge = Edge(left: l, top: t, right: r, bottom: b)
        return self
    }

    @discardableResult
    public func title(_ titleText: String) -> Dialog {
        self.titleView = UILabel(frame: .zero).text(titleText).align(.center).lines(1).backColor(Theme.themeColor).textColor(.white).font(Fonts.title)
        return self
    }

    public func dialogAction(_ a: DialogX.DialogAction) {
        buttons.append(a)
    }

    @discardableResult
    public func cancel(_ text: String = "取消") -> DialogX.DialogAction {
        let a = button(text) {
        }
        return a
    }

    @discardableResult
    public func button(_ text: String, _ block: @escaping BlockVoid) -> DialogX.DialogAction {
        let a = DialogX.DialogAction(text)
        a.callback = block
        dialogAction(a)
        return a
    }

    public func show() {
        self.superPage?.present(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.rgba(0, 0, 0, 50)

        let linearView = LinearLayout(.vertical).backColor(Colors.fill).roundLayer(self.corner)
        view += linearView

        let dialogWidth: CGFloat = min(350, UIScreen.width - 2 * marginX)

        if let v = titleView {
            linearView.appendChild(v, MatchParent, 46)
        }


        if let bv = bodyView {
            linearView += bv.linearParams(MatchParent, WrapContent) {
                $0.minHeight = 100
            }
        }
        if !buttons.isEmpty {
            if bodyView != nil {
                linearView += UIView(frame: .zero).backColor(Colors.separator).linearParams(MatchParent, 1)
            }
            linearView += LinearLayout(.horizontal).linearParams(MatchParent, 46).apply { panel in
                for n in buttons.indices {
                    if n != 0 {
                        panel += UIView(frame: .zero).backColor(Colors.separator).linearParams(1, MatchParent)
                    }
                    let item = buttons[n]
                    panel += UIButton(frame: Rect.zero).title(item.title).titleColor(item.color).linearParams(0, MatchParent) {
                        $0.weight = 1
                    }.click { [weak self] b in
                        if item.autoClose {
                            self?.close()
                        }
                        item.callback()
                        item.callback = {
                        }
                    }
                }
            }
        }
        logd("ConSize: ", linearView.contentSize)
        linearView.constraintsInstall { b in
            b.centerXParent().widthParent(constant: -marginX * 2)
//            b.height(linearView.contentSize.height)
            b.heightRatio(multi: 1)
            switch self.gravityY {
            case .center, .none, .fill:
                b.centerYParent()
            case .bottom:
                b.bottomParent()
            case .top:
                b.topParent(25)
//                linearView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            }
        }
        self.view.clickView { v in
            v.findMyController()?.dismiss(animated: true)
        }

    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
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

}

public extension Dialog {

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
        self.button("确定") {
            okCallback(self.textField?.text?.trimed ?? "")
        }.accent()
        self.show()
    }

    func showList<T>(items: [T], trans: @escaping (T) -> String, _ callback: @escaping (T) -> Void) {
        self.list(items).map(trans).show(callback)
    }

    func showList(items: [String], _ callback: @escaping (String) -> Void) {
        self.list(items).show(callback)
    }

    func list<T>(_ items: [T]) -> DialogList<T> {
        return DialogList(self, items)
    }

    func grid<T>(_ items: [T]) -> DialogGrid<T> {
        return DialogGrid(self, items)
    }
}

public class DialogGrid<T> {
    private var dlg: Dialog
    private var items: [T]

    private lazy var binder: (T) -> UIView = { item in
        let b = GridItemView(frame: Rect.zero)
        b.text = self.transform(item)
        b.image = self.imageBlock(item)
        return b
    }

    private lazy var transform: (T) -> String = {
        return "\($0)"
    }
    private lazy var imageBlock: (T) -> UIImage? = { _ in
        return nil
    }
    private let panel = UIView(frame: Rect.zero)
    private let gl: GridLayoutConstraint

    public init(_ dlg: Dialog, _ items: [T]) {
        self.dlg = dlg
        self.items = items
        self.gl = panel.layoutGridConstraint
        self.gl.columns = 3
    }

    public func show(_ block: @escaping (T) -> Void) {
        for item in items {
            let v = self.binder(item)
            v.clickView { a in
                a.findMyController()?.close()
                block(item)
            }
            gl.add(v)
        }

        let totalH = gl.totalHeight
        if totalH < 500 {
            gl.install()
            self.dlg.body(self.panel)
            self.dlg.bodyHeight = totalH
        } else {
            gl.install(true)
            let sv = UIScrollView(frame: .zero)
            sv.addSubview(panel)
            let L = panel.layout.fill()
            L.width.eqParent.active()
            self.dlg.body(sv)
            self.dlg.bodyHeight = 500

        }
        self.dlg.show()
    }

    public func cellWidth(_ v: CGFloat) -> DialogGrid<T> {
        self.gl.cellWidth = v
        return self
    }

    public func cellHeight(_ v: CGFloat) -> DialogGrid<T> {
        self.gl.cellHeight = v
        return self
    }

    public func verticalSpace(_ v: CGFloat) -> DialogGrid<T> {
        self.gl.verticalSpace = v
        return self
    }

    public func columns(_ n: Int) -> DialogGrid<T> {
        self.gl.columns = n
        return self
    }

    public func bind(_ block: @escaping (T) -> UIView) -> DialogGrid<T> {
        self.binder = block
        return self
    }

    public func map(_ block: @escaping (T) -> String) -> DialogGrid<T> {
        self.transform = block
        return self
    }

    public func image(_ block: @escaping (T) -> UIImage?) -> DialogGrid<T> {
        self.imageBlock = block
        return self
    }
}

public class DialogList<T> {
    private var dlg: Dialog
    private var items: [T]
    private var imageBlock: ((T) -> UIImage?)? = nil
    private var align: NSTextAlignment = .left
    private var itemHeight: CGFloat = 52

    private lazy var binder: (T) -> UIView = { item in
        let title = self.transform(item)
        if let block = self.imageBlock {
            let img = block(item)?.scaledTo(40)
            let v = IconTextView()
            v.textView.text = title
            v.iconView.image = img
            v.textView.textAlignment = self.align
            return v
        } else {
            let v = UILabel.Primary
            v.text = title
            v.textAlignment = self.align
            v.setupFeedback()
            return v
        }
    }

    private lazy var transform: (T) -> String = {
        return "\($0)"
    }

    public init(_ dlg: Dialog, _ items: [T]) {
        self.dlg = dlg
        self.items = items
    }

    public func show(_ callback: @escaping (T) -> Void) {

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
            self.dlg.bodyHeight = totalH
        } else {
            let sv = UIScrollView(frame: .zero)
            sv.addSubview(panel)
            let L = panel.layout.fill()
            L.width.eqParent.active()
            self.dlg.body(sv)
            self.dlg.bodyHeight = 500

        }
        self.dlg.show()
    }

    public func itemHeight(_ h: CGFloat) -> DialogList<T> {
        self.itemHeight = h
        return self
    }

    public func image(_ block: @escaping (T) -> UIImage?) -> DialogList<T> {
        self.imageBlock = block
        return self
    }

    public func imageName(_ block: @escaping (T) -> String) -> DialogList<T> {
        self.imageBlock = { item in
            return UIImage(named: block(item))
        }
        return self
    }

    public func bind(_ block: @escaping (T) -> UIView) -> DialogList<T> {
        self.binder = block
        return self
    }

    public func map(_ block: @escaping (T) -> String) -> DialogList<T> {
        self.transform = block
        return self
    }

    public func alignLeft() -> DialogList<T> {
        self.align = .left
        return self
    }

    public func alignRight() -> DialogList<T> {
        self.align = .right
        return self
    }

    public func alignCenter() -> DialogList<T> {
        self.align = .center
        return self
    }

}

public extension UIViewController {
    var dialog: Dialog {
        return Dialog(self)
    }

    func alert(_ msg: String) {
        self.dialog.showAlert(msg)
    }

    func alert(_ msg: String, _ block: @escaping BlockVoid) {
        self.dialog.showAlert(msg: msg, block)
    }
}


