//
//  UsersService.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case serverError(Error)
    case emptyResponse
    case decodingError(Error)
    case httpStatus(Int)
    case responseError
}

// MARK: - UsersService
class UsersService {
    
    func loadUsersData(pageToLoad: Int? = nil) async throws -> Users {
        guard var components = URLComponents(string: Environment.baseURL) else {
            print("Error: Invalid URL")
            throw NetworkError.invalidURL
        }
        
        components.path = Environment.usersPath
        
        var queryItems: [URLQueryItem] = []
        
        if let pageToLoad = pageToLoad {
            queryItems.append(URLQueryItem(name: Environment.pageParam, value: pageToLoad.description))
        }
        
        queryItems.append(URLQueryItem(name: Environment.countParam, value: Environment.countItems.description))
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            print("Error: Invalid URL")
            throw NetworkError.invalidURL
        }
        
        print("Requesting URL: \(url.absoluteString)")
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't get HTTPURLResponse")
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard !data.isEmpty else {
                    print("Error: empty response from server")
                    throw NetworkError.emptyResponse
                }
                let decodedData = try JSONDecoder().decode(Users.self, from: data)
                return decodedData
            default:
                print("Error httpStatus code")
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }
            
        } catch let decodingError as DecodingError {
            print("Error parsing JSON: \(decodingError)")
            throw NetworkError.decodingError(decodingError)
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            throw NetworkError.serverError(error)
        }
    }
}
