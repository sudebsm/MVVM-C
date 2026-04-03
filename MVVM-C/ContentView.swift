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
             listData  = try await neworkManager.fetchUserData(urlStr: "https://www.bukai95.com/users1")
        } catch(let error as NetworkError) {
            errorMessage = String(describing: error)
         } catch {
             errorMessage = error.localizedDescription
        }
    }
}

protocol APIProtocol {
    func fetchUserData<T: Decodable>(urlStr: String) async throws -> [T]
}

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case badResponse(String)
    case networkError(String)
    case unknown

}

class NetworkManager : APIProtocol {
   
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUserData<T: Decodable>(urlStr: String) async throws -> [T] {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        let request = URLRequest(url: url)
        
        let (data, res) = try await session.data(for: request)
        
        guard let httpResponse = res as? HTTPURLResponse else {
            throw NetworkError.badResponse("Not an HTTP response")
        }
        
        let statusCode = httpResponse.statusCode
        
        guard (200...299).contains(statusCode) else {
            throw NetworkError.badResponse("Bad Response: \(statusCode)")
        }
        do {
            let model = try JSONDecoder().decode([T].self, from: data)
            return model
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    
}



struct User: Codable, Identifiable {
    let name: String
    let id: Int
}
