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
                ZONetwork.shared.getWalletAddresses(["elsapo.eth"]) { result in
                    switch result {
                    case .success(let metadataList):
                        print(metadataList.count)
                    case .failure(_):
                        print("failure")
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
