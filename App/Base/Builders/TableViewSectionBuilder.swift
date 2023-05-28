//
//  TableViewSectionBuilder.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 17.05.2023.
//

final class TableViewSectionBuilder: TableViewSectionProtocol {
    var headerBuilder: TableViewHeaderBuilderProtocol?
    var cellBuilder: TableViewCellBuilderProtocol
    
    init(
        headerBuilder: TableViewHeaderBuilderProtocol?,
        cellBuilder: TableViewCellBuilderProtocol
    ) {
        self.headerBuilder = headerBuilder
        self.cellBuilder = cellBuilder
    }
}
