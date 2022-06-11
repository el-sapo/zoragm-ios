//
//  WalletDataManager.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import Foundation

class WalletDataManager {
    var walletItems: [CustomMetadata] = []
    var addresses: [String] = []

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
                case .failure(_):
                    refresh(true, "failed to load")
                    print("failure")
                }
            }
        } else {
            refresh(true, nil)
        }
    }
}
