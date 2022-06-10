//
//  ContentView.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 8/6/22.
//

import SwiftUI

struct ContentView: View {
    @State var networkResult = ""

    var body: some View {
        Text(networkResult)
            .onAppear {
                ZONetwork.shared.getTopCollections()
                ZONetwork.shared.getWalletAddress(["elsapo.eth"])
            }
                
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
