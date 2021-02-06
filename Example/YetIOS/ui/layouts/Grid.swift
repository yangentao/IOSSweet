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
    public var width: CGFloat = 60
    public var height: CGFloat = 60
    @GreatEQ(minValue: 1)
    public var columnSpan: Int = 1
    @GreatEQ(minValue: 1)
    public var rowSpan: Int = 1

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

public class Grid: UIView {
    public var paddings: Edge = Edge() {
        didSet {
            setNeedsLayout()
        }
    }

    public var axis: LayoutAxis = .vertical {
        didSet {
            setNeedsLayout()
        }
    }
    public var gravityX: GravityX = .fill {
        didSet {
            setNeedsLayout()
        }
    }
    public var gravityY: GravityY = .fill {
        didSet {
            setNeedsLayout()
        }
    }
    @GreatEQ(minValue: 1)
    public var columns: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }


    @GreatEQ(minValue: 0)
    public var hSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    @GreatEQ(minValue: 0)
    public var vSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }


    private var contentSize: CGSize = .zero {
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

    public func setDefaultColumnInfo(value: CGFloat, weight: CGFloat) {
        defaultColumnInfo = GridCellInfo(value: value, weight: weight)
        setNeedsLayout()
    }

    public func setDefaultRowInfo(value: CGFloat, weight: CGFloat) {
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
        if axis == .vertical {
            let cells: CellMatrix = calcCellsVertical(childViews)
            logd("MapCount: ", cells.map.count)
            logd("Cols:", cells.cols)
            logd("Rows:", cells.rows)
            logd("Keys:", cells.map.keys)
            logd("Map:", cells.map)
            calcWidthsVertical(cells)
            calcHeightsVertical(cells)
            calcRectVertical(cells)
        } else {

        }

    }

    private func calcRectVertical(_ cells: CellMatrix) {
        for row in 0..<cells.rows {
            for col in 0..<cells.cols {
//                logd(row, col, " W = ", cells[row, col]?.width, "  H = ", cells[row, col]?.height)
                print("\(cells[row, col]?.view?.tagS ?? "nil")(", cells[row, col]?.width ?? 0, ", ", cells[row, col]?.height ?? 0, ")", terminator: " ")
            }
            print()
        }

        for row in 0..<cells.rows {
            var y: CGFloat = paddings.top
            for i in 0..<row {
                y += (cells[i, 0]?.height ?? 0) + vSpace
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
                    x += (cells[row, i]?.width ?? 0) + hSpace
                }

                var ww: CGFloat = 0
                for c in col..<(col + param.columnSpan) {
                    ww += cells[row, c]?.width ?? 0
                    ww += hSpace
                }
                ww -= hSpace

                var hh: CGFloat = 0
                for r in row..<(row + param.rowSpan) {
                    hh += cells[r, col]?.height ?? 0
                    hh += hSpace
                }
                hh -= hSpace
//                let h = (cell.height + vSpace) * param.spanRows - vSpace
                let rect = Rect(x: x, y: y, width: ww, height: hh)
                logd("Rect: ", rect)
                cell.view?.frame = rect
            }
        }


    }

    private func calcHeightsVertical(_ cells: CellMatrix) {
        var rowInfos: [GridCellInfo] = .init(repeating: GridCellInfo(other: defaultRowInfo), count: cells.cols)
        for (k, v) in self.rowInfoMap {
            rowInfos[k] = v
        }

        let totalValue: CGFloat = self.bounds.height - self.vSpace * (cells.rows - 1) - paddings.top - paddings.bottom
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

        let totalValue: CGFloat = self.bounds.width - self.hSpace * (self.columns - 1) - paddings.left - paddings.right
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
        map.keys
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
