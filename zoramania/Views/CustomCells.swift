//
//  CustomCells.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 10/6/22.
//

import UIKit
import WebKit

class TokenPreviewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblName: UILabel!
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
