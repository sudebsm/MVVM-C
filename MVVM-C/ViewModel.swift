//
//ViewModel.swift
//  MVVM-C
//
//  Created by Sudeb Sarkar on 04/04/26.
//

import Foundation

@Observable
class ViewModel {
    private var neworkManager: APIProtocol
    var listData: [User] = []
    var errorMessage: String?

    init(neworkManager: APIProtocol = NetworkManager()) {
        self.neworkManager = neworkManager
    }
    @MainActor
    func fetchData() async {
        do {
            listData  = try await neworkManager.request(.getUsers)
        } catch(let error as NetworkError) {
            errorMessage = String(describing: error)
         } catch {
             errorMessage = error.localizedDescription
        }
    }
}
