//
//  PositionSelectionView.swift
//  TestTask
//
//  Created by Andrii Stetsenko on 10.06.2025.
//

import SwiftUI

struct PositionSelectionView: View {
    @ObservedObject var vm: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select your position")
                .body2Style()
                .foregroundStyle(Color.black_87)
            
            if vm.isLoading {
                ProgressView("Loading positions...")
            } else if let errorMessage = vm.errorMessage {
                Text("Error: \(errorMessage)")
                    .body1Style()
                    .foregroundStyle(Color.errorColor)
                    .padding(.leading, Spacing.large)
            } else {
                PositionsListView(positions: vm.positions, selectedPosition: $vm.selectedPosition)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let vm = SignUpViewModel()
    vm.positions = [
        Position(id: 1, name: "Frontend developer"),
        Position(id: 2, name: "Backend developer"),
        Position(id: 3, name: "Designer"),
        Position(id: 4, name: "QA")
    ]
    vm.selectedPosition = vm.positions.first
    
    return PositionSelectionView(vm: vm)
}
