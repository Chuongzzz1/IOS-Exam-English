//
//  LoadData.swift
//  Demo-CollectionView
//
//  Created by Trần Văn Chương on 28/03/2024.
//

import Foundation
class LoadData {
    // MARK: Singleton
    static let share = LoadData()
    
    init() { }
    // MARK: - Variable
//    private var data: FruitModel?
    // MARK: - Func
    func loadData () -> [FruitModel]? {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let datas = try decoder.decode([FruitModel].self, from: data)
            return datas
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
