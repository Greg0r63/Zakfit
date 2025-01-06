//
//  AlimentaryPreferenceViewModel.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Foundation

class AlimentaryPreferenceViewModel: ObservableObject {
    @Published var alimentaryPreferences: [AlimentaryPreference] = []
    
    func fecthAlimentaryPreferences() {
        guard let url = URL(string: "http://127.0.0.1:8080/alipreferences") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedAlimentaryPreferences = try JSONDecoder().decode([AlimentaryPreference].self, from: data)
                    DispatchQueue.main.async {
                        self.alimentaryPreferences = decodedAlimentaryPreferences
                        print("Data décodées: \(data)")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}
