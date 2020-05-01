//
//  SectionEntry.swift
//  iTunesCatalog
//
//  Created by Maria Yu on 4/30/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

struct SectionEntry<SectionTitle : Hashable, RowItem> {
    var sectionTitle : SectionTitle
    var rows : [RowItem]

    static func group(rows : [RowItem], by criteria : (RowItem) -> SectionTitle) -> [SectionEntry<SectionTitle, RowItem>] {
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(SectionEntry.init(sectionTitle:rows:))
    }
}

