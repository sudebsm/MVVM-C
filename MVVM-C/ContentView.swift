//
//  ContentView.swift
//  MVVM-C
//
//  Created by Sudeb Sarkar on 02/04/26.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel(neworkManager: NetworkManager())
    @State var navPath: NavigationPath?
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




struct User: Codable, Identifiable {
    let name: String
    let id: Int
}
