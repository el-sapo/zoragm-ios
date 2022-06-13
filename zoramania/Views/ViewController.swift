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
    @IBOutlet weak var walletView: UIView!
    
    let walletViewHeight = 200.0
    let walletDataManager = WalletDataManager()
    let columnLayout = ColumnFlowLayout(cellsPerRow: 2,
                                        minimumInteritemSpacing: 5,
                                        minimumLineSpacing: 10,
                                        sectionInset: UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5),
                                        titleHeight: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup UI
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-1.png")!)
        self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "bg-1.png")!)
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        ProgressHUD.animationType = .multipleCirclePulse

        // load wallets info
        walletDataManager.loadDefaultWallets()
        loadWalletInfo()
    }
            
    func loadWalletInfo() {
        ProgressHUD.show()
        self.tableView.reloadData()
        collectionTop.constant = 0
        
        walletDataManager.loadWalletInfo() { [weak self] refresh, wError in
            DispatchQueue.main.async { [weak self] in
                guard let aSelf = self else { return }
                if let error = wError {
                    print(error)
                    aSelf.showAlert(title: "Failed to get wallet info", message: error)
                }
                if aSelf.walletDataManager.walletItems.count == 0 {
                    aSelf.collectionTop.constant = aSelf.walletViewHeight
                    aSelf.walletView.alpha = 1.0
                }
                aSelf.collectionView.reloadData()
                ProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func walletAction(forceHide: Bool = false) {
        var newTop = 0.0
        var alpha = 0.0
        if collectionTop.constant == 0 && !forceHide {
            newTop = 200.0
            alpha = 1.0
        }
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseIn]) { [weak self] in
            guard let aSelf = self else { return }
            aSelf.collectionTop.constant = newTop
            aSelf.walletView.alpha = alpha
            aSelf.view.layoutIfNeeded()
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

extension ViewController {
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
