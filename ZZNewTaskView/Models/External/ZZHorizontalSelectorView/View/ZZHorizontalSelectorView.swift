//
//  ZZHorizontalSelectorView.swift
//  ZZNewTaskView
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import Foundation

protocol ZZHorizontalSelector_VD: AnyObject {
    func fillUI()
}

class ZZHorizontalSelectorView {
    public var addNewItem: (()->Void)?
    
    public var viewModel: ZZHorizontalSelectorView_VMP! {
        didSet {
            viewModel.setView(delegate: self)
        }
    }
}
