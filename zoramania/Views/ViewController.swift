//
//  ViewController.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import Foundation
import UIKit
import ProgressHUD

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionTop: NSLayoutConstraint!
    
    let walletDataManager = WalletDataManager()
    let columnLayout = ColumnFlowLayout(cellsPerRow: 2,
                                        minimumInteritemSpacing: 5,
                                        minimumLineSpacing: 10,
                                        sectionInset: UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5),
                                        titleHeight: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always

        ProgressHUD.animationType = .multipleCirclePulse
        walletDataManager.addresses.append("elsapo.eth")
        loadWalletInfo()
    }
            
    func loadWalletInfo() {
        ProgressHUD.show()
        self.tableView.reloadData()
        collectionTop.constant = 0
        walletDataManager.loadWalletInfo() { [weak self] refresh, error in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async { [weak self] in
                guard let aSelf = self else { return }
                if aSelf.walletDataManager.walletItems.count > 0 {
                    aSelf.collectionTop.constant = 0.0
                }
                aSelf.collectionView.reloadData()
                ProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func walletAction(forceHide: Bool = false) {
        var newTop = 0.0
        if collectionTop.constant == 0 && !forceHide {
            newTop = 200.0
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.collectionTop.constant = newTop
        } completion: { _ in }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walletDataManager.walletItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenPreviewCollectionCell", for: indexPath) as! TokenPreviewCollectionCell
        let metadata = walletDataManager.walletItems[indexPath.row]
        cell.lblName.text = metadata.name ?? ""
        cell.loadImage(imageStr: metadata.imageUrl)
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
        self.walletDataManager.addresses.remove(at: indexPath.row)
        tableView.reloadData()
        loadWalletInfo()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let address = textField.text, address.count > 0 {
            walletDataManager.addresses.append(address)
            tableView.reloadData()
            loadWalletInfo()
        }
        textField.text = ""
        textField.endEditing(true)
        walletAction(forceHide: true)
        return true
    }
}
