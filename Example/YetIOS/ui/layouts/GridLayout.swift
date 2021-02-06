//
// Created by yangentao on 2021/2/3.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    var gridParams: GridParams? {
        get {
            return getAttr("__gridParam__") as? GridParams
        }
        set {
            setAttr("__gridParam__", newValue)
        }
    }

    var gridParamsEnsure: GridParams {
        if let L = self.gridParams {
            return L
        } else {
            let a = GridParams()
            self.gridParams = a
            return a
        }
    }

    @discardableResult
    func gridParams(_ block: (GridParams) -> Void) -> Self {
        block(gridParamsEnsure)
        return self
    }
}

public class GridParams {

    @GreatEQ(minValue: 1)
    public var columnSpan: Int = 1
    @GreatEQ(minValue: 1)
    public var rowSpan: Int = 1

    @GreatEQ(minValue: 0)
    public var width: CGFloat = 0
    @GreatEQ(minValue: 0)
    public var height: CGFloat = 0
    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none
    public var margins: Edge = Edge()

}

public extension GridParams {
    func width(_ w: CGFloat) -> Self {
        self.width = w
        return self
    }

    func height(_ h: CGFloat) -> Self {
        self.height = h
        return self
    }
}

//vertical layout only!
public class GridLayout: UIView {
    public var paddings: Edge = Edge() {
        didSet {
            setNeedsLayout()
        }
    }

//    public var axis: LayoutAxis = .vertical {
//        didSet {
//            setNeedsLayout()
//        }
//    }

    @GreatEQ(minValue: 1)
    public var columns: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }


    @GreatEQ(minValue: 0)
    public var spaceHor: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    @GreatEQ(minValue: 0)
    public var spaceVer: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }


    public private(set ) var contentSize: CGSize = .zero {
        didSet {
            if oldValue != contentSize {
                processScroll()
            }
        }
    }

    private var defaultColumnInfo: GridCellInfo = GridCellInfo(value: 0, weight: 1)
    private var defaultRowInfo: GridCellInfo = GridCellInfo(value: 60, weight: 0)
    private var columnInfoMap: [Int: GridCellInfo] = [:]
    private var rowInfoMap: [Int: GridCellInfo] = [:]

    public func setColumnInfoDefault(value: CGFloat, weight: CGFloat) {
        defaultColumnInfo = GridCellInfo(value: value, weight: weight)
        setNeedsLayout()
    }

    public func setRowInfoDefault(value: CGFloat, weight: CGFloat) {
        defaultRowInfo = GridCellInfo(value: value, weight: weight)
        setNeedsLayout()
    }

    public func setColumnInfo(_ col: Int, value: CGFloat, weight: CGFloat) {
        columnInfoMap[col] = GridCellInfo(value: value, weight: weight)
        setNeedsLayout()
    }

    public func setRowInfo(_ row: Int, value: CGFloat, weight: CGFloat) {
        self.rowInfoMap[row] = GridCellInfo(value: value, weight: weight)
        setNeedsLayout()
    }


    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        processScroll()
    }

    private func processScroll() {
        if let pv = self.superview as? UIScrollView {
            pv.contentSize = contentSize
        }
    }

    public override func layoutSubviews() {
        let childViews = self.subviews.filter {
            $0.gridParams != nil
        }
        if childViews.isEmpty {
            return
        }
//        if axis == .vertical {
        let cells: CellMatrix = calcCellsVertical(childViews)
        calcWidthsVertical(cells)
        calcHeightsVertical(cells)
        let maxY = calcRectVertical(cells)
        self.contentSize = Size(width: self.bounds.width, height: maxY - self.bounds.minY)
//        } else {

//        }

    }

    private func calcRectVertical(_ cells: CellMatrix) -> CGFloat {
        var maxY: CGFloat = self.bounds.minY

        for row in 0..<cells.rows {
            var y: CGFloat = paddings.top
            for i in 0..<row {
                y += (cells[i, 0]?.height ?? 0) + spaceVer
            }
            for col in 0..<cells.cols {
                guard let cell = cells[row, col], let view = cell.view, let param = view.gridParams else {
                    continue
                }
                if col > 0 && cell.view === cells[row, col - 1]?.view {
                    continue
                }
                if row > 0 && cell.view === cells[row - 1, col]?.view {
                    continue
                }
                var x: CGFloat = paddings.left // (cell.width + hSpace) * cell.view.gridParams!.spanColumns
                for i in 0..<col {
                    x += (cells[row, i]?.width ?? 0) + spaceHor
                }

                var ww: CGFloat = 0
                for c in col..<(col + param.columnSpan) {
                    ww += cells[row, c]?.width ?? 0
                    ww += spaceHor
                }
                ww -= spaceHor

                var hh: CGFloat = 0
                for r in row..<(row + param.rowSpan) {
                    hh += cells[r, col]?.height ?? 0
                    hh += spaceHor
                }
                hh -= spaceHor
//                let h = (cell.height + vSpace) * param.spanRows - vSpace
                let rect = Rect(x: x, y: y, width: ww, height: hh)
                if let view = cell.view {
                    view.frame = placeView(view, rect)
                }
                maxY = max(maxY, rect.maxY)
            }
        }
        return maxY
    }

    private func placeView(_ view: UIView, _ rect: Rect) -> Rect {
        let param = view.gridParamsEnsure
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat

        switch param.gravityX {
        case .none, .fill:
            w = rect.width
            x = rect.minX
            break
        case .left:
            w = param.width
            x = rect.minX
        case .right:
            w = param.width
            x = rect.maxX - w
            break
        case .center:
            w = param.width
            x = rect.center.x - w / 2
            break
        }
        switch param.gravityY {
        case .none, .fill:
            h = rect.height
            y = rect.minY
        case .top:
            h = param.height
            y = rect.minY
        case .bottom:
            h = param.height
            y = rect.maxY - h
        case .center:
            h = param.height
            y = rect.center.y - h / 2
        }
        var r = Rect(x: x, y: y, width: w, height: h)
        r.origin.x += param.margins.left
        r.origin.y += param.margins.top
        r.size.width -= param.margins.left + param.margins.right
        r.size.height -= param.margins.top + param.margins.bottom
        return r
    }

    private func calcHeightsVertical(_ cells: CellMatrix) {
        var rowInfos: [GridCellInfo] = .init(repeating: GridCellInfo(other: defaultRowInfo), count: cells.cols)
        for (k, v) in self.rowInfoMap {
            rowInfos[k] = v
        }

        let totalValue: CGFloat = self.bounds.height - self.spaceVer * (cells.rows - 1) - paddings.top - paddings.bottom
        var weightSum: CGFloat = 0
        var ls: [GridCellInfo] = []
        var ls2: [GridCellInfo] = []
        var leftValue: CGFloat = totalValue

        for r in 0..<cells.rows {
            let info = rowInfos[r]
            info.realValue = GRID_UNSPEC
            if info.weight > 0 {
                weightSum += info.weight
                if info.value > 0 {
                    ls += info
                } else {
                    ls2 += info
                }
            } else {
                info.realValue = info.value
                leftValue -= info.value
            }
        }
        for info in ls.sortedAsc({ $0.value }) {
            let v = leftValue * info.weight / weightSum
            if v < info.value {
                info.realValue = info.value
            } else {
                info.realValue = v
            }
            leftValue -= info.realValue
            weightSum -= info.weight
        }
        for info in ls2 {
            info.realValue = leftValue * info.weight / weightSum
        }
        for row in 0..<cells.rows {
            for col in 0..<cells.cols {
                cells[row, col]?.height = rowInfos[row].realValue
            }
        }
    }


    private func calcWidthsVertical(_ cells: CellMatrix) {
        var columnInfos: [GridCellInfo] = .init(repeating: GridCellInfo(other: defaultColumnInfo), count: cells.cols)
        for (k, v) in self.columnInfoMap {
            columnInfos[k] = v
        }

        let totalValue: CGFloat = self.bounds.width - self.spaceHor * (self.columns - 1) - paddings.left - paddings.right
        var leftValue: CGFloat = totalValue

        var weightSum: CGFloat = 0
        var ls: [GridCellInfo] = []
        var ls2: [GridCellInfo] = []

        for c in 0..<self.columns {
            let info = columnInfos[c]
            info.realValue = GRID_UNSPEC
            if info.weight > 0 {
                weightSum += info.weight
                if info.value > 0 {
                    ls += info
                } else {
                    ls2 += info
                }
            } else {
                info.realValue = info.value
                leftValue -= info.value
            }
        }
        // weight > 0 and value > 0
        for info in ls.sortedAsc({ $0.value }) {
            let v = leftValue * info.weight / weightSum
            if v < info.value {
                info.realValue = info.value
            } else {
                info.realValue = v
            }
            leftValue -= info.realValue
            weightSum -= info.weight
        }
        for info in ls2 {
            info.realValue = leftValue * info.weight / weightSum
        }


        for row in 0..<cells.rows {
            for col in 0..<cells.cols {
                cells[row, col]?.width = columnInfos[col].realValue
            }
        }
    }


    private func calcCellsVertical(_ viewList: [UIView]) -> CellMatrix {
        let cellMatrix = CellMatrix(cols: self.columns)
        var row = 0
        var col = 0
        for v in viewList {
            pos(v, matrix: cellMatrix, row: &row, col: &col)
        }
        return cellMatrix
    }

    private func pos(_ v: UIView, matrix: CellMatrix, row: inout Int, col: inout Int) {
        let param = v.gridParams!
        while matrix[row, col] != nil {
            col += 1
            if col >= self.columns {
                row += 1
                col = 0
            }
        }
        let colSpan = min(self.columns, param.columnSpan)
        if col == 0 || col + colSpan - 1 < self.columns {
            for r in 0..<param.rowSpan {
                for c in 0..<colSpan {
                    matrix[row + r, col + c] = CellItem(v)
                }
            }
            return
        }
        matrix[row, col] = CellItem(nil)
        col += 1
        if col >= self.columns {
            row += 1
            col = 0
        }
        pos(v, matrix: matrix, row: &row, col: &col)

    }
}

fileprivate class CellItem {
    var view: UIView?
    lazy var param: GridParams? = view?.gridParams
    var left: CGFloat = 0
    var right: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0


    init(_ v: UIView?) {
        self.view = v
    }
}

fileprivate let GRID_UNSPEC: CGFloat = -1

public class GridCellInfo {
    @GreatEQ(minValue: 0)
    public var weight: CGFloat = 0
    @GreatEQ(minValue: 0)
    public var value: CGFloat = 0

    fileprivate var realValue: CGFloat = GRID_UNSPEC

    public init(value: CGFloat, weight: CGFloat) {
        self.value = value
        self.weight = weight
    }

    public convenience init(other: GridCellInfo) {
        self.init(value: other.value, weight: other.weight)
    }
}


fileprivate struct Coords: Hashable {
    let row: Int
    let col: Int
}

fileprivate class CellMatrix {
    var map: [Coords: CellItem] = [:]

    let cols: Int

    init(cols: Int) {
        assert(cols > 0)
        self.cols = cols
    }

    var rows: Int {
        if let a = map.keySet.max(by: { a, b in
            a.row < b.row
        }) {
            return a.row + 1
        }
        return 0
    }

    subscript(row: Int, col: Int) -> CellItem? {
        get {
            return map[Coords(row: row, col: col)]
        }
        set {
            map[Coords(row: row, col: col)] = newValue
        }
    }
}
