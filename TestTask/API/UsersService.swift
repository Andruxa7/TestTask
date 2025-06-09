//
//  UsersService.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(Error?)
    case emptyResponse
    case decodingError(Error)
    case httpStatus(Int)
    case responseError
    case notFound(String)
    case validationError(String, [String: [String]])
}

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}

class UsersService {
    func loadUsersData(pageToLoad: Int? = nil) async throws -> Users {
        guard var components = URLComponents(string: Environment.baseURL) else {
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
            throw NetworkError.invalidURL
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard !data.isEmpty else {
                    throw NetworkError.emptyResponse
                }
                let decodedData = try JSONDecoder().decode(Users.self, from: data)
                return decodedData
                
            case 404:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError.notFound(errorResponse.message)
                
            case 422:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                if let fails = errorResponse.fails {
                    throw NetworkError.validationError(errorResponse.message, fails)
                } else {
                    throw NetworkError.validationError(errorResponse.message, [:])
                }
                
            default:
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.serverError(error)
        }
    }
    
    func loadPositionsData() async throws -> [Position] {
        guard var components = URLComponents(string: Environment.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        components.path = Environment.positionsPath
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard !data.isEmpty else {
                    throw NetworkError.emptyResponse
                }
                let decodedData = try JSONDecoder().decode(Positions.self, from: data)
                return if decodedData.success { decodedData.positions } else { throw NetworkError.emptyResponse }
                
            case 404:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError.notFound(errorResponse.message)
                
            case 422:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                if let fails = errorResponse.fails {
                    throw NetworkError.validationError(errorResponse.message, fails)
                } else {
                    throw NetworkError.validationError(errorResponse.message, [:])
                }
                
            default:
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.serverError(error)
        }
    }
    
    func fetchToken() async throws -> String {
        guard var components = URLComponents(string: Environment.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        components.path = Environment.tokenPath
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard !data.isEmpty else {
                    throw NetworkError.emptyResponse
                }
                do {
                    let decodedData = try JSONDecoder().decode(Token.self, from: data)
                    return decodedData.success ? decodedData.token : try { throw NetworkError.emptyResponse }()
                } catch let decodingError as DecodingError {
                    throw NetworkError.decodingError(decodingError)
                }
                
            case 500:
                throw NetworkError.serverError(nil)
                
            default:
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.serverError(error)
        }
    }
    
    func performSignUp(token: String, username: String, email: String, phone: String, positionId: Int, photoData: Data?) async throws -> Bool {
        guard var components = URLComponents(string: Environment.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        components.path = Environment.usersPath
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Token")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let fields: [String: String] = [
            "name": username,
            "email": email,
            "phone": phone,
            "position_id": String(positionId)
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let photoData = photoData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(photoData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            guard !data.isEmpty else {
                throw NetworkError.emptyResponse
            }
            let decodedData = try JSONDecoder().decode(ErrorResponse.self, from: data)
            guard decodedData.success else {
                throw NetworkError.validationError(decodedData.message, decodedData.fails ?? [:])
            }
            return true
            
        case 500:
            throw NetworkError.serverError(nil)
            
        case 400..<500:
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NetworkError.validationError(errorResponse.message, errorResponse.fails ?? [:])
            
        default:
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }
    }
}
