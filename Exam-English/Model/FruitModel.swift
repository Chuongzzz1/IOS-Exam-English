//
//  FruitModel.swift
//  Demo-CollectionView
//
//  Created by Trần Văn Chương on 28/03/2024.
//

import Foundation
struct FruitModel: Decodable {
        var nameFruit: String
        var imageFruit: String
        var priceFruit: Int
        var isChecked: Bool
    init(nameFruit: String, imageFruit: String, priceFruit: Int, isChecked: Bool) {
        self.nameFruit = nameFruit
        self.imageFruit = imageFruit
        self.priceFruit = priceFruit
        self.isChecked = isChecked
    }
}

