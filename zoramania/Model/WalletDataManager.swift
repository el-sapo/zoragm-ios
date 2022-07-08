//
//  WalletDataManager.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import Foundation
import Combine

class WalletDataManager {
    let walletKey = "wallets"
    var walletItems: [CustomMetadata] = []
    var addresses: [String] = [] {
        didSet {
            UserDefaults().set(addresses, forKey: walletKey)
        }
    }

    // set list of observers in case you want to add more calls to api
    var observers: [AnyCancellable] = []
    var action = PassthroughSubject<String?, Never>()
    
    func loadDefaultWallets() {
        let defaults = UserDefaults().object(forKey: walletKey)
        if let wallets = defaults as? [String] {
            addresses = wallets
        }
    }
    
    func loadWalletInfo() {
        guard addresses.count > 0 else {
            walletItems = []
            action.send(nil)
            return
        }
        ZONetwork.shared.getWalletAddresses(addresses)
             .sink(receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                         print("finished")
                    case .failure(let error):
                        self?.action.send(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] metadataList in
                    guard let aSelf = self else { return }
            
                    aSelf.walletItems = metadataList
                    aSelf.walletItems.sort { meta1, meta2 in
                        meta1.collectionInfo?.collectionAddress ?? "" < meta2.collectionInfo?.collectionAddress ?? ""
                    }
                    self?.action.send(nil)
                    print(metadataList.count)
                })
             .store(in: &observers)
    }
}
