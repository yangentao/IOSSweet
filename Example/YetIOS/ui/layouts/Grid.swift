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
    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none
    @GreatEQ(minValue: 1)
    public var spanColumns: Int = 1
    @GreatEQ(minValue: 1)
    public var spanRows: Int = 1

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
            colInfos = [GridColumnInfo](repeating: GridColumnInfo(width: 0, weight: 1), count: columns)
            setNeedsLayout()
        }
    }
    private var colInfos: [GridColumnInfo] = []
    private var rowInfos: [Int: GridRowInfo] = [:]

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
    @GreatEQ(minValue: 1)
    public var defaultRowHeight: CGFloat = 60 {
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

    public func setColumnInfo(_ col: Int, _ info: GridColumnInfo) {
        colInfos[col] = info
    }

    public func setRowInfo(_ row: Int, _ info: GridRowInfo) {
        self.rowInfos[row] = info
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
            let cells: Array2D<CellItem> = calcCellsVertical(childViews)
            calcWidthsVertical(cells)
            calcHeightsVertical(cells)
        } else {

        }

    }

    private func calcRectVertical(_ cells: Array2D<CellItem>) {

        for row in 0..<cells.rows {
            var y: CGFloat = paddings.top
            for i in 0..<row {
                y += cells[row, 0]!.height + vSpace
            }
            for col in 0..<cells.cols {
                guard let cell = cells[row, col] else {
                    continue
                }
                if col > 0 && cell === cells[row, col - 1] {
                    continue
                }
                if row > 0 && cell === cells[row - 1, col] {
                    continue
                }
                var x: CGFloat = paddings.left // (cell.width + hSpace) * cell.view.gridParams!.spanColumns
                for i in 0..<col {
//                    x += cells[row, col]
                }
                cell.left = x
                cell.right = y


            }
        }


    }

    private func calcHeightsVertical(_ cells: Array2D<CellItem>) {
        let totalHeight: CGFloat = self.bounds.height - self.vSpace * (cells.rows - 1) - paddings.top - paddings.bottom

        var allRowInfos: [GridRowInfo] = .init(repeating: GridRowInfo(height: defaultRowHeight, weight: 0), count: cells.rows)
        for (k, v) in self.rowInfos {
            allRowInfos[k] = v
        }
        let heightSum: CGFloat = allRowInfos.filter({ $0.weight == 0 && $0.value > 0 }).sumBy({ $0.value })
        let weightSum: CGFloat = allRowInfos.filter({ $0.weight > 0 }).sumBy({ $0.weight })
        let leftHeight = max(0, totalHeight - heightSum)
        for ri in allRowInfos {
            if ri.value > 0 {
                ri.realValue = ri.value
            } else if weightSum > 0 {
                ri.realValue = leftHeight * ri.weight / weightSum
            }
        }
        for row in 0..<cells.rows {
            for col in 0..<cells.cols {
                cells[row, col]?.height = allRowInfos[col].realValue
            }
        }

    }

    private func calcWidthsVertical(_ cells: Array2D<CellItem>) {
        let totalWidth: CGFloat = self.bounds.width - self.hSpace * (self.columns - 1) - paddings.left - paddings.right
        var weightSum: CGFloat = self.colInfos.sumBy {
            $0.weight
        }


        var leftWidth: CGFloat = totalWidth
        for ci in self.colInfos {
            if ci.value > 0 {
                leftWidth -= ci.value
                ci.realValue = ci.value
            } else if ci.weight > 0 {
                leftWidth -= ci.minWidth
            } else {
                ci.realValue = ci.minWidth
                leftWidth -= ci.minWidth
            }
        }
        let lsW = self.colInfos.filter({ $0.realValue != GRID_UNSPEC && $0.maxWidth > 0 }).sortedAsc({ $0.maxWidth })
        for ci in lsW {
            if weightSum > 0 {
                let wVal = ci.minWidth + leftWidth * ci.weight / weightSum
                if ci.maxWidth > ci.minWidth && wVal > ci.maxWidth {
                    weightSum -= ci.weight
                    leftWidth -= ci.maxWidth
                    ci.realValue = ci.maxWidth
                }
            }
        }
        let ls2 = self.colInfos.filter({ $0.realValue != GRID_UNSPEC }).sortedAsc({ $0.maxWidth })
        for ci in ls2 {
            if ci.weight > 0 && weightSum > 0 {
                ci.realValue = ci.minWidth + leftWidth * ci.weight / weightSum
            }
        }


        for row in 0..<cells.rows {
            for col in 0..<cells.cols {
                cells[row, col]?.width = self.colInfos[col].realValue
            }
        }

    }

    private func calcCellsVertical(_ viewList: [UIView]) -> Array2D<CellItem> {
        let maxRow: Int = viewList.sumBy {
            $0.gridParams!.spanRows
        }
        let cells: Array2D<CellItem> = .init(rows: maxRow, cols: self.columns)

        var row = 0
        var col = 0
        for v in viewList {
            posView(v, cells, &row, &col)
        }

        row = cells.rows - 1
        while row >= 0 {
            var allNull = true
            for i in 0..<cells.cols {
                if cells[row, i] != nil {
                    allNull = false
                }
            }
            if !allNull {
                break
            }
            row -= 1
        }
        let newCells: Array2D<CellItem> = .init(rows: row + 1, cols: self.columns)
        for r in 0...row {
            for c in 0..<self.columns {
                newCells[r, c] = cells[r, c]
            }
        }
        return newCells
    }

    private func posView(_ view: UIView, _ cells: Array2D<CellItem>, _ row: inout Int, _ col: inout Int) {
        let p = view.gridParams!
        let colSpan = min(p.spanColumns, self.columns)
        if col != 0 {
            if col + colSpan > self.columns {
                row += 1
                col = 0
            }
        }

        var ok = true
        for x in 0..<colSpan {
            for y in 0..<p.spanRows {
                ok = ok && cells[row + y, col + x] == nil
            }
        }
        if ok {
            let cell = CellItem(view)
            for x in 0..<colSpan {
                for y in 0..<p.spanRows {
                    cells[row + y, col + x] = cell
                }
            }
            col += colSpan
            if col >= self.columns {
                row += 1
                col = 0
            }
        } else {
            col += 1
            if col >= self.columns {
                row += 1
                col = 0
            }
            posView(view, cells, &row, &col)
        }

    }
}

fileprivate class CellItem {
    var view: UIView
    lazy var param: GridParams = view.gridParams!
    var left: CGFloat = 0
    var right: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0


    init(_ v: UIView) {
        self.view = v
    }
}

fileprivate let GRID_UNSPEC: CGFloat = -1

public class GridColumnInfo {
    public var weight: CGFloat = 0
    public var value: CGFloat = 0
    public var minWidth: CGFloat = 0
    public var maxWidth: CGFloat = 0

    fileprivate var realValue: CGFloat = GRID_UNSPEC

    public init(width: CGFloat, weight: CGFloat) {
        self.value = width
        self.weight = weight
    }
}

public class GridRowInfo {
    public var weight: CGFloat = 0
    public var value: CGFloat = 0

    fileprivate var realValue: CGFloat = GRID_UNSPEC

    public init(height: CGFloat, weight: CGFloat) {
        self.value = height
        self.weight = weight
    }
}


fileprivate class CellArray {
    var array: [CellItem] = []

    let cols: Int

    init(cols: Int) {
        assert(cols > 0)
        self.cols = cols
    }

    var rows: Int {
        (array.count + cols - 1) / cols
    }

    subscript(row: Int, col: Int) -> CellItem {
        get {
            return array[row * cols + col]
        }
        set {
            array[row * cols + col] = newValue
        }
    }
}