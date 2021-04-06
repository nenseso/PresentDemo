//
//  ViewController.swift
//  PresentDemo
//
//  Created by nenseso zhou on 2021/4/6.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var bvc: BViewController = {
        let bvc = BViewController()
        bvc.modalPresentationStyle = .fullScreen
        return bvc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func presentAction(_ sender: Any) {
        
        // situation 1：A had presented B before.
        self.present(bvc, animated: true, completion: nil)
         si1()
        
        // situation 2：A is presenting B.
//         si2()
    }
    
    func si1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Fix bug: Application tried to present modally a view controller <PresentDemo.BViewController: 0x7fcf005070f0> that is already being presented by <PresentDemo.ViewController: 0x7fcf00608b80>.
            guard self.presentedViewController == nil else { return }
            guard self.bvc.isBeingPresented == false else { return }
            
            self.present(self.bvc, animated: true, completion: nil)
        }
    }
    
    func si2() {
        // iOS Animation duration 0.25s , so after 0.1 s,A is presenting B
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Fix bug: Application tried to present modally a view controller <PresentDemo.BViewController: 0x7fcf005070f0> that is already being presented by <PresentDemo.ViewController: 0x7fcf00608b80>.
            guard self.presentedViewController == nil else { return }
            guard self.bvc.isBeingPresented == false else { return }
            
            self.present(self.bvc, animated: true, completion: nil)
        }
    }
    
}

