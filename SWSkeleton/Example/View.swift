//
//  View.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 11.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit

class View: BaseView {
    
    // MARK: - RegisterViewProtocol
    
    var view: UIView! {
        didSet {
            self.configure()
            self.configureColors()
            self.configureStaticTexts()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ({ self.view = self.xibSetupView() })()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ({ self.view = self.xibSetupView() })()
    }
}

extension View: RegisterViewProtocol {
    func configure() {
        
    }
    
    func configureColors() {
        
    }
    
    func configureStaticTexts() {
        
    }
}

extension View: DataProviderProtocol {
    typealias DataType = [Product]
    
    func set(data: [Product]) {
        Log.debug.log(data)
    }
}
