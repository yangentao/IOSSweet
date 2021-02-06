//
// Created by entaoyang on 2019-01-16.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    var ivBottomLine: Bool {
        get {
            return getAttr("view.bottomline") as? Bool ?? false
        }
        set {
            setAttr("view.bottomline", newValue)
        }
    }
    var ivBottomLineOffsetLeft: CGFloat {
        get {
            return getAttr("view.bottomline.offlset.left") as? CGFloat ?? 0
        }
        set {
            setAttr("view.bottomline.offlset.left", newValue)
        }
    }
    var ivBottomLineOffsetRight: CGFloat {
        get {
            return getAttr("view.bottomline.offlset.right") as? CGFloat ?? 0
        }
        set {
            setAttr("view.bottomline.offlset.right", newValue)
        }
    }

    var ivMoreArrow: Bool {
        get {
            return getAttr("moreArrow") as? Bool ?? false
        }
        set {
            setAttr("moreArrow", newValue)
        }
    }

    func ivMore() {
        self.ivMoreArrow = true
    }

    func itemStyle(_ height: CGFloat = Dim.itemHeightNormal) {
        self.linearParams(MatchParent, height)
        self.marginX(Dim.edge)
        self.ivBottomLine = true
        self.ivBottomLineOffsetLeft = Dim.edge
    }

    func itemStyleInput(_ height: CGFloat = Dim.itemHeightNormal) {
        self.linearParams(MatchParent, height)
        self.marginX(Dim.edgeInput)
        self.ivBottomLine = false
        if self is TextDetailView {
            self.ivMoreArrow = true
            self.marginRight = 0
        }
    }
}

open class ItemPage: TitlePage, UITableViewDataSource, UITableViewDelegate {
    public var tableView: UITableView = UITableView.Plain

    public var itemViews: [UIView] = [UIView]()

    public var rowHeight: CGFloat = 70

    open override func onCreateContent() {
        super.onCreateContent()
        self.tableView.backgroundColor = Color.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.contentView.addSubview(tableView)
        self.tableView.layout.fill()
        self.tableView.allowsMultipleSelection = false
        self.tableView.separatorStyle = .none

    }

    open override func afterCreateContent() {
        super.afterCreateContent()
        commit()
    }

    open func onItemClick(_ item: UIView) {

    }

    open func addItem(_ v: UIView) {
        itemViews.append(v)
    }

    open func commit() {
        self.tableView.reloadData()
    }

    open func setItems(_ data: [UIView]) {
        self.itemViews = data
        self.tableView.reloadData()
    }

    open func getItem(_ n: Int) -> UIView {
        return self.itemViews[n]
    }

    open func getInputText(_ tagS: String) -> String {
        return (findItem(tagS) as! InputView).editView.text?.trimed ?? ""
    }

    open func findItem(_ tagS: String) -> UIView? {
        let s = tagS.trim("*")
        for v in itemViews {
            if v.tagS == s {
                return v
            }
        }
        return nil
    }

    open func checkValid() -> Bool {
        for v in itemViews {
            if let ed = v as? InputView {
                if !ed.editView.checkValid {
                    return false
                }
            }
        }
        return true
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemViews.count
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = getItem(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse") ?? UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.contentView.removeAllChildView()
        cell.contentView.addSubview(item)
        cell.backgroundColor = .white

        if item.ivMoreArrow {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }

        let lp = item.linearParams
        let w = lp?.width ?? MatchParent
        let h = lp?.height ?? rowHeight

        let M = item.margins

        let LL = item.layout
        if (w <= 0) {
            LL.fillX(M?.left ?? 0, -(M?.right ?? 0))
        } else {
            LL.width(w)
            if lp?.gravityX == .center {
                LL.centerXParent()
            } else {
                LL.leftParent(M?.left ?? 0)
            }
        }
        if h > 0 {
            LL.height(h)
        } else {
            LL.height(rowHeight)
        }
        LL.topParent(M?.top ?? 0)

        if item.ivBottomLine {
            let lineView = UIView(frame: Rect.zero)
            lineView.tagS = "lineview"
            lineView.backgroundColor = Colors.separator
            cell.addSubview(lineView)
            lineView.layout.height(1).fillX(item.ivBottomLineOffsetLeft, -item.ivBottomLineOffsetRight).bottomParent(0)
        } else {
            for v in cell.subviews {
                if v.tagS == "lineview" {
                    v.removeFromSuperview()
                    break;
                }
            }
        }

        return cell
    }

    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.onItemClick(getItem(indexPath.row))
        return nil
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let v = getItem(indexPath.row)
        let h = v.linearParams?.height ?? rowHeight
        return h + v.marginTop + v.marginBottom
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

}

public extension ItemPage {
    @discardableResult
    func makeUser() -> UserView {
        let u = UserView()
        u.textView.text = ""
        u.statusView.text = ""
        u.iconView.namedImage(R.portrait)
        u.tagS = "user"
        addItem(u)
        return u
    }

    @discardableResult
    func makeButtonRed(_ text: String) -> UIButton {
        let b = UIButton.RedRound
        b.title = text
        b.linearParams(MatchParent, Theme.Button.heightLarge) {
            $0.gravityX(.center)
        }
        b.marginTop = 20
        b.marginBottom = 20
        b.marginX(Dim.edgeInput)
        addItem(b)
        return b
    }

    @discardableResult
    func makeButtonGreen(_ text: String) -> UIButton {
        let b = UIButton.GreenRound
        b.title = text
        b.linearParams(MatchParent, Theme.Button.heightLarge) {
            $0.gravityX(.center)
        }
        b.marginTop = 20
        b.marginBottom = 20
        b.marginX(Dim.edgeInput)
        addItem(b)
        return b
    }

    @discardableResult
    func makeEdit(_ hint: String, _ block: (InputView) -> Void) -> InputView {
        let v = makeEdit(hint)
        block(v)
        return v
    }

    @discardableResult
    func makeEdit(_ hint: String) -> InputView {
        let v = InputView()
        v.editView.hintText = hint
        addItem(v)
        v.tagS = hint.trim("*")
        return v
    }

    @discardableResult
    func makeTextDetail(_ text: String, _ detail: String, _ block: (TextDetailView) -> Void) -> TextDetailView {
        let v = makeTextDetail(text, detail)
        block(v)
        return v
    }

    @discardableResult
    func makeTextDetail(_ text: String, _ detail: String) -> TextDetailView {
        let a = TextDetailView()
        a.textView.text = text
        a.detailView.text = detail
        a.tagS = text.trim("*")
        addItem(a)
        return a
    }

    @discardableResult
    func makeIconText(_ image: String, _ text: String, _ block: (IconTextView) -> Void) -> IconTextView {
        let v = makeIconText(image, text)
        block(v)
        return v
    }

    @discardableResult
    func makeIconText(_ image: String, _ text: String) -> IconTextView {
        let a = IconTextView()
        a.textView.text = text
        a.iconView.nameThemed(image)
        a.tagS = text.trim("*")
        addItem(a)
        return a
    }

    @discardableResult
    func makeTextImage(_  text: String, _ image: String, _ block: (TextImageView) -> Void) -> TextImageView {
        let v = makeTextImage(text, image)
        block(v)
        return v
    }

    @discardableResult
    func makeTextImage(_  text: String, _ image: String) -> TextImageView {
        let a = TextImageView()
        a.textView.text = text
        if !image.isEmpty {
            a.imageView.namedImage(image)
        }
        a.tagS = text.trim("*")
        addItem(a)
        return a
    }

}