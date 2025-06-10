//
//  Extensions.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import Foundation
import UIKit

var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

// Extension to formattedPhoneNumber in UsersListItem
extension String {
    func formattedPhoneNumber() -> String {
        let cleaned = self.filter { "+0123456789".contains($0) }
        
        guard cleaned.hasPrefix("+380"), cleaned.count == 13 else {
            return self
        }
        
        let startIndex = cleaned.index(cleaned.startIndex, offsetBy: 3)
        let operatorCode = cleaned[cleaned.index(startIndex, offsetBy: 0)..<cleaned.index(startIndex, offsetBy: 3)]
        let part1 = cleaned[cleaned.index(startIndex, offsetBy: 3)..<cleaned.index(startIndex, offsetBy: 6)]
        let part2 = cleaned[cleaned.index(startIndex, offsetBy: 6)..<cleaned.index(startIndex, offsetBy: 8)]
        let part3 = cleaned[cleaned.index(startIndex, offsetBy: 8)..<cleaned.index(startIndex, offsetBy: 10)]
        
        return "+38 (\(operatorCode)) \(part1) \(part2) \(part3)"
    }
}

// Extension to uniqued Array in UserViewViewModel
extension Array where Element: Identifiable {
    func uniqued(on keyPath: KeyPath<Element, Element.ID>) -> [Element] {
        var seen = Set<Element.ID>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
