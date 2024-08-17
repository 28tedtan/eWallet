//
//  homeView.swift
//  eWallet
//
//  Created by Ted Tan on 17/8/24.
//

import SwiftUI

struct homeView: View {
    
    @State var name: String = "Ted"
    
    var body: some View {
        NavigationStack{
            VStack{
                
                
                Text("hey")
                
                
            }.navigationTitle("Welcome \(name)")
        }
    }
}

#Preview {
    homeView()
}
