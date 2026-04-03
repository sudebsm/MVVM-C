//
//  NetworkManager 2.swift
//  MVVM-C
//
//  Created by Sudeb Sarkar on 03/04/26.
//

import Foundation

protocol APIProtocol {
    func request<T: Decodable>(_ endPoint: APIEndPoint) async throws -> T
}

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
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
    
    func request<T: Decodable>(_ endPoint: APIEndPoint) async throws -> T {
        
        guard let request = endPoint.urlRequest else {
            throw NetworkError.invalidRequest
        }
 
        let (data, res) = try await session.data(for: request)
        
        guard let httpResponse = res as? HTTPURLResponse else {
            throw NetworkError.badResponse("Not an HTTP response")
        }
        
        let statusCode = httpResponse.statusCode
        
        guard (200...299).contains(statusCode) else {
            throw NetworkError.badResponse("Bad Response: \(statusCode)")
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}


enum APIEndPoint {
    case getUsers
    case createUser(name: String, email: String, mobile: String)
    case deleteUser
    case updateUser
}


extension APIEndPoint {
    
    var baseUrl: String {
        return "https://www.bukai95.com"
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .createUser:
            return "/createUser"
        case .deleteUser:
            return "/deleteUser"
        case .updateUser:
            return "/updateUser"
        }
    }
    
    var method: String {
        switch self {
        case .getUsers:
            return "GET"
        case .createUser:
            return "POST"
        case .deleteUser:
            return "DELETE"
        case .updateUser:
            return "PUT"
        }
    }
    
    var httpBody: Data? {
        
        switch self {
            case .getUsers:
            return nil
        case .createUser(let name, let email, let mobile):
            let dict = ["name": name, "email": email, "mobile": mobile]
            return try? JSONSerialization.data(withJSONObject: dict)
        case .deleteUser:
            return nil
        case .updateUser:
            return nil
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseUrl + path) else {
            return nil
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.httpBody = httpBody
        
        if httpBody != nil {
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return req
        
    }
}
