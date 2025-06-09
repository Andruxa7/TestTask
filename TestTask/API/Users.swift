//
//  Users.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 03.05.2025.
//

import Foundation

// MARK: - Users
struct Users: Codable {
    let success: Bool
    let totalPages, totalUsers, count, page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case count, page, links, users
    }
}

// MARK: - Links
struct Links: Codable {
    let nextURL: String?
    let prevURL: String?
    
    enum CodingKeys: String, CodingKey {
        case nextURL = "next_url"
        case prevURL = "prev_url"
    }
}

// MARK: - User
struct User: Codable, Identifiable {
    let id: Int
    let name, email, phone: String
    let position: String
    let positionID, registrationTimestamp: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionID = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}

// MARK: - Positions
struct Positions: Codable {
    let success: Bool
    let positions: [Position]
}

// MARK: - Position
struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Token
struct Token: Codable {
    let success: Bool
    let token: String
}

// MARK: - SaveToken
struct SaveToken {
    let token: String
    let time: Date = Date()
}
