//
//  ZZHorizontalSelectorView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import Foundation
import UIKit

protocol ZZHorizontalSelector_VD: AnyObject {
    func fillUI()
}

class ZZHorizontalSelectorView {
    
    @IBOutlet private weak var addButton: NSButton!
    @IBOutlet private weak var collectionView: NSCollectionView!
    
    @objc private func addTapped() {
        addNewItem?()
    }
    
    public var addNewItem: (()->Void)?
    
    public var viewModel: ZZHorizontalSelectorView_VMP! {
        didSet {
            viewModel.setView(delegate: self)
        }
    }
}

extension ZZHorizontalSelectorView: ZZHorizontalSelector_VD {
    func fillUI() {
        addButton.isHidden = !viewModel.canAddNewItem
        
        // populate collectionView (datasouece + reload)
        
        viewModel.selectedIndexes.forEach({ _ in
            // preselect selected items
        })
    }
}
