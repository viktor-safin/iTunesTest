//
//  RootRouter.swift
//  iTunesTest
//
//  Created by Виктор on 16.04.2024.
//

import UIKit
import SwiftUI

// MARK: - Protocols

protocol NavigationProtocol: AnyObject {
    var navigationController: UINavigationController! { get }
    
    var topViewController: UIViewController? { get }
    
    func navigationPresent(_ viewController: UIViewController, style: UIModalPresentationStyle, animated: Bool)
    func navigationPushViewController(_ viewController: UIViewController, animated: Bool)
    func navigationPopViewController(animated: Bool)
    func navigationPopToRootViewController(animated: Bool)
}
extension NavigationProtocol {
    
    var topViewController: UIViewController? {
        if let presentedViewController = navigationController.presentedViewController {
            return presentedViewController
        }
        return navigationController
    }
    
    func navigationPresent(_ viewController: UIViewController,
                           style: UIModalPresentationStyle = .fullScreen, animated: Bool) {
        viewController.modalPresentationStyle = style
        
        topViewController?.present(viewController, animated: animated)
    }
    
    func navigationPushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func navigationPopViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func navigationPopToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
}

protocol RootRouterProtocol: NavigationProtocol {
    
    var window: UIWindow { get }
    var sceneFactory: SceneFactoryProtocol { get }
    
    init(window: UIWindow)
    
    func presentRootNavigationControllerInWindow()
}

protocol MainRouterProtocol {
    func showUIKitMode()
    func showSwiftUIMode()
}

protocol MusicUIKitRouterProtocol {
    func openMusic(_ music: MusicData)
    
}

// MARK: - Router

final class RootRouter: RootRouterProtocol {
    
    let window: UIWindow
    var navigationController: UINavigationController!
    
    let sceneFactory: SceneFactoryProtocol
    
    init(window: UIWindow) {
        self.window = window
        
        sceneFactory = SceneFactory()
    }
    
    func presentRootNavigationControllerInWindow() {
        
        
        guard let viewController = sceneFactory.createSelectModeViewController(with: self)
        else { return }
        
        
        navigationController = UINavigationController(rootViewController: viewController)
                
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
}

extension RootRouter: MainRouterProtocol {
    
    func showUIKitMode() {
        guard let viewController = sceneFactory.createMainViewController(with: self)
        else { return }
        
        navigationPushViewController(viewController, animated: true)
    }
    
    func showSwiftUIMode() {
        let appRouter = AppRouter()
        let networkService = ITunesSearchNetworkService()
        let viewModel = ITunesSearchViewModel(networkService: networkService)
        let hostingController = UIHostingController(rootView:
                                                        ITunesSearchUIView(router: appRouter)
                                                        .environmentObject(viewModel))
        
        navigationPushViewController(hostingController, animated: true)
    }
}

extension RootRouter: MusicUIKitRouterProtocol {
    
    func openMusic(_ music: MusicData) {
        guard let viewController = sceneFactory.createMusicViewController(with: music, router: self)
        else { return }
        
        navigationPresent(viewController, animated: true)
    }
}
