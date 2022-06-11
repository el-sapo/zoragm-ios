//
//  ViewController.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import Foundation
import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let walletDataManager = WalletDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletDataManager.addresses.append("elsapo.eth")
        self.tableView.reloadData()
        walletDataManager.loadWalletInfo() { [weak self] refresh, error in
            guard let aSelf = self else {
                return
            }
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                aSelf.collectionView.reloadData()
            }
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walletDataManager.walletItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenPreviewCollectionCell", for: indexPath) as! TokenPreviewCollectionCell
        let metadata = walletDataManager.walletItems[indexPath.row]

        cell.lblName.text = metadata.name ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletDataManager.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableCell", for: indexPath) as! AddressTableCell
        cell.lblAddress.text = walletDataManager.addresses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.walletDataManager.addresses.remove(at: indexPath.row - 1)
        self.tableView.reloadData()
    }
}
