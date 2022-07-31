//
//  ActivityIndicator.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import SwiftUI
import UIKit

class Activity: ObservableObject {
    static var shared = Activity()
    
    @Published var isLoading = false
}

struct ActivityIndicator: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.40)
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
