//
//  PositionsListView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct PositionsListView: View {
    let positions: [Position]
    @Binding var selectedPosition: Position?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(positions) { position in
                PositionRowView(
                    position: position,
                    isSelected: selectedPosition?.id == position.id,
                    onTap: { selectedPosition = position }
                )
            }
        }
    }
}

struct PositionsListView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedPosition: Position?
        
        var body: some View {
            let vm = SignUpViewModel()
            vm.positions = [
                Position(id: 1, name: "Frontend developer"),
                Position(id: 2, name: "Backend developer"),
                Position(id: 3, name: "Designer"),
                Position(id: 4, name: "QA")
            ]
            
            return PositionsListView(positions: vm.positions, selectedPosition: $selectedPosition)
                .onAppear {
                    selectedPosition = vm.positions.first
                }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
