//
//  ReusableProtocol.swift
//  lico
//
//  Created by Krizhanovskii on 9/22/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import Foundation
import UIKit

/// This protocols and extension helps to fastes work with TableView and collcetionView
/// For fast setup cell design
/// - no need to add cell in storyboard or xib.
/// - need register from code

///EXAMPLE:
/*
// registe cell
func registerCells() {
    self.tableView.register(SWPartnersLinksCell.self)
}

// get cell
let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SWPartnersLinksCell
*/

/// RegisterCellProtocol view protocol helps to resiter cell for table view or colection view
public protocol RegisterCellProtocol {
    func configure() // optional.
}

/// optional func configure
public extension RegisterCellProtocol {
    public func configure() {}
}

/// return String ident fron self name
public extension RegisterCellProtocol where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }

    public static var nibName: String {
        return String(describing: self)
    }
}

public protocol RegisterHeaderFooterViewProtocol: RegisterCellProtocol {}

/// Register and dequeue cell from table
public extension UITableView {
    /// reload table with saving content position
    public func reloadDataWithSaveContentOffset() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }

    /// Register cell
    ///
    /// - Parameter _: UITableViewCell.Type that conform RegisterCellProtocol
    public func register<T: UITableViewCell>(_: T.Type) where T: RegisterCellProtocol {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register several cell
    ///
    /// - Parameter _: UITableViewCell.Type that conform RegisterCellProtocol
    public func register<T: UITableViewCell>(_ cells : [T.Type]) where T: RegisterCellProtocol {
        cells.forEach { (cell) in
            self.register(cell)
        }
    }

    /// Register cell with NIB name. Nib name must be equal to ClassName.
    ///
    /// - Parameter _: UITableViewCell.Type that conform RegisterCellProtocol
    public func registerNib<T: UITableViewCell>(_: T.Type) where T: RegisterCellProtocol {
        let bundle = Bundle(for: T.self)
        guard (bundle.path(forResource: T.nibName, ofType: "nib") != nil) else {
            fatalError("Could not find xib with name: \(T.nibName)")
        }
        self.register(UINib(nibName:T.nibName, bundle: bundle), forCellReuseIdentifier: T.reuseIdentifier)
    }

    public func register<T: UITableViewCell, Z: UITableViewCell>(_: T.Type, withNib:Z.Type) where T: RegisterCellProtocol, Z: RegisterCellProtocol {
        let bundle = Bundle(for: T.self)
        guard (bundle.path(forResource: Z.nibName, ofType: "nib") != nil) else {
            fatalError("Could not find xib with name: \(T.nibName)")
        }
        Log.info.log("REGISTER WITH IDENT \(T.reuseIdentifier)")
        self.register(UINib(nibName:Z.nibName, bundle: bundle), forCellReuseIdentifier: T.reuseIdentifier)
    }

    /// Dequeue cell. CellClass must confrom RegisterCellProtocol
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: UITableViewCell type
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: RegisterCellProtocol {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            Log.error.log(dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath))
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    public func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: RegisterHeaderFooterViewProtocol {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ views : [T.Type]) where T: RegisterHeaderFooterViewProtocol {
        views.forEach { (view) in
            self.register(view)
        }
    }

    public func registerNib<T: UITableViewHeaderFooterView>(_: T.Type) where T: RegisterHeaderFooterViewProtocol {
        let bundle = Bundle(for: T.self)
        guard (bundle.path(forResource: T.nibName, ofType: "nib") != nil) else {
            fatalError("Could not find xib with name: \(T.nibName)")
        }
        self.register(UINib(nibName: T.nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: RegisterHeaderFooterViewProtocol {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue headerFooter with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}

/// Register and dequeue cell from colection
public extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) where T: RegisterCellProtocol {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func registerNib<T: UICollectionViewCell>(_: T.Type) where T: RegisterCellProtocol {
        let bundle = Bundle(for: T.self)
        guard (bundle.path(forResource: T.nibName, ofType: "nib") != nil) else {
            fatalError("Could not find xib with name: \(T.nibName)")
        }
        self.register(UINib(nibName: T.nibName, bundle: bundle), forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: RegisterCellProtocol {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
