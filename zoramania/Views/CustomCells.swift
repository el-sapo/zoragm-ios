//
//  CustomCells.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import UIKit
import WebKit
import SDWebImage

class TokenPreviewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblName: UILabel!
    
    func loadImage(imageStr: String?) {
        guard let imgStr = imageStr else { return }
        print(imgStr)
        if imgStr.contains("ipfs") {
            imgPreview.isHidden = true
            webView.isHidden = false
            // loading ipfs images in UIView does not work well, so we load them in web
            webView.load(URLRequest(url: URL(string: imgStr)!))
        } else if imgStr.contains("http") {
            imgPreview.isHidden = false
            webView.isHidden = true
            imgPreview.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "placeholder"))
        } else if imgStr.contains("data:image/svg+xml;base64") {
            imgPreview.isHidden = true
            webView.isHidden = false
            print(self.webView.frame.width)
            let htmlImage = "<img width=100% height=100% src=\"\(imgStr)\"/>"
            webView.loadHTMLString(htmlImage, baseURL: nil)
        } else {
            imgPreview.isHidden = true
            webView.isHidden = true
        }
    }
}

class AddressTableCell: UITableViewCell {
    @IBOutlet weak var lblAddress: UILabel!    
}

class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int
    let titleHeight: CGFloat
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero, titleHeight: CGFloat = 0.0) {
        self.cellsPerRow = cellsPerRow
        self.titleHeight = titleHeight
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth + titleHeight)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
