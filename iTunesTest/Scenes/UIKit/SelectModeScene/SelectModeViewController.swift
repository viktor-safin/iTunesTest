//
//  SelectModeViewController.swift
//  iTunesTest
//
//  Created by Виктор on 30.05.2024.
//

import UIKit

final class SelectModeViewController: UIViewController {
    
    var router: MainRouterProtocol!
    
    @IBAction private func selectUIKit() {
        router.showUIKitMode()
    }
    
    @IBAction private func selectSwiftUI() {
        router.showSwiftUIMode()
    }
}
