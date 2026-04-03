//
//  ContentView.swift
//  MVVM-C
//
//  Created by Sudeb Sarkar on 02/04/26.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel(neworkManager: NetworkManager())
    var body: some View {
        NavigationStack {
            Group {
                if let error = viewModel.errorMessage {
                    Text(error)
                }else if viewModel.listData.isEmpty {
                    ProgressView()
                    Text("Loading...")
                }else {
                    VStack {
                        List(viewModel.listData) { item in
                            Text(item.name)
                        }
                    }
                }
                    
            }
            .task {
                await viewModel.fetchData()
            }
        }
       
    }
}

#Preview {
    ContentView()
}

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



struct User: Codable, Identifiable {
    let name: String
    let id: Int
}
