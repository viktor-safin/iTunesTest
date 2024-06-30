//
//  SceneFactory.swift
//  iTunesTest
//
//  Created by Виктор on 16.04.2024.
//

import UIKit

protocol SceneFactoryProtocol {
    func createSelectModeViewController(with router: MainRouterProtocol) -> UIViewController?
    func createMainViewController(with router: MusicUIKitRouterProtocol) -> UIViewController?
    func createMusicViewController(with music: MusicData,
                                   router: MainRouterProtocol) -> UIViewController?
    
}
    
// MARK: - Factory

final class SceneFactory: SceneFactoryProtocol {
    
    // MARK:
    
    func createSelectModeViewController(with router: MainRouterProtocol) -> UIViewController? {
        let storyboard = UIStoryboard(name: "SelectMode", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: SelectModeViewController.identifier) as? SelectModeViewController else {
            return nil
        }
        
        vc.router = router
        
        return vc
    }
    
    func createMainViewController(with router: MusicUIKitRouterProtocol) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "ITunesSearch", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: ITunesSearchViewController.identifier) as? ITunesSearchViewController else {
            return nil
        }
        
        let networkService = ITunesSearchNetworkService()
        let viewModel = ITunesSearchViewModel(networkService: networkService)
        
        vc.viewModel = viewModel
        vc.router = router
        
        return vc
    }
    
    func createMusicViewController(with music: MusicData,
                                   router: MainRouterProtocol) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "MusicPlay", bundle: nil)
        
        guard let musicVC = storyboard.instantiateViewController(
            withIdentifier: MusicViewController.identifier) as? MusicViewController else {
            return nil
        }
        
        let musicViewModel = MusicViewModel(musicCellModel: music)
        
        musicVC.viewModel = musicViewModel
        musicVC.router = router
        
        return musicVC
    }
}
