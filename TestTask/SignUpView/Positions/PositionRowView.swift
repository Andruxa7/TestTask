//
//  PositionRowView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct PositionRowView: View {
    let position: Position
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.0)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.secondaryColor : Color.clear)
                    )
                    .frame(width: 14, height: 14)
                    .onTapGesture(perform: onTap)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 1.0)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.backgroundColor : Color.clear)
                    )
                    .frame(width: 6, height: 6)
            }
            .frame(width: 48, height: 48)
            
            Text(position.name)
                .body1Style()
                .foregroundStyle(Color.black_87)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 48)
        
    }
}

#Preview {
    PositionRowView(position: Position(id: 1, name: "Lawyer"), isSelected: true, onTap: {
        print("position is selected")
    })
}
