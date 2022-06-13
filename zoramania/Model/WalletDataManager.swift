//
//  WalletDataManager.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import Foundation

class WalletDataManager {
    let walletKey = "wallets"
    var walletItems: [CustomMetadata] = []
    var addresses: [String] = [] {
        didSet {
            UserDefaults().set(addresses, forKey: walletKey)
        }
    }

    func loadDefaultWallets() {
        let defaults = UserDefaults().object(forKey: walletKey)
        if let wallets = defaults as? [String] {
            addresses = wallets
        }
    }
    
    func loadWalletInfo(refresh: @escaping (Bool, String?)->()) {
        if addresses.count > 0 {
            ZONetwork.shared.getWalletAddresses(addresses) { [weak self] result in
                guard let aSelf = self else { return }
                switch result {
                case .success(let metadataList):
                    aSelf.walletItems = metadataList
                    aSelf.walletItems.sort { meta1, meta2 in
                        meta1.collectionInfo?.collectionAddress ?? "" < meta2.collectionInfo?.collectionAddress ?? ""
                    }
                    refresh(true, nil)
                    print(metadataList.count)
                case .failure(let error):
                    refresh(true, error.localizedDescription)
                }
            }
        } else {
            walletItems = []
            refresh(true, nil)
        }
    }
}
