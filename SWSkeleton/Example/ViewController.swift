//
//  ViewController.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxViewController: BaseViewController {
    
    @IBOutlet weak private var viewContent: View!
    
    var viewModel: RxViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = RxViewModel()
        self.configureRx()
        self.viewModel?.update()
    }

    private func configureRx() {
        guard let vm = self.viewModel else { return }
        
        self.viewContent.loadingView
            .subscribe(on: vm.requestStatus.asObservable())
            .disposed(by: self.disposeBag)
        
        vm.requestStatus.asObservable().subscribe(onError: { (error) in
            let error = SWErrorHandler.handleError(error)
            let controller = UIAlertController.init(title: error.message, message: "", preferredStyle: .alert)
            controller.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                controller.dismiss(animated: true)
            }))
            self.present(controller, animated: true)
        }).disposed(by: self.disposeBag)
        
        vm.data.asObservable().subscribe(onNext: { (products) in
            self.viewContent.set(data: products)
        }).disposed(by: self.disposeBag)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak private var viewContent: View!
    
    var viewModel: ViewModel? {
        didSet {
            guard let vm = self.viewModel else { return }
            vm.viewModelChanged = {
                switch vm.requestStatus {
                case .success:
                    Log.debug.log("Hide spinner")
                    Log.debug.log("Success")
                    self.viewContent.set(data: vm.data)
                case .loading:
                    Log.debug.log("Show spinner")
                    Log.debug.log("Loading")
                case .error(let error):
                    Log.debug.log("Hide spinner")
                    Log.debug.log("Show error alert with message: \(error.message)")
                    Log.debug.log(error.message)
                default:
                    Log.debug.log("Hide spinner")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewModel()
        self.viewModel?.update()
    }
}

