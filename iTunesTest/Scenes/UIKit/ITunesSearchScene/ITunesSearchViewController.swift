//
//  ITunesSearchViewController.swift
//  iTunesTest
//
//  Created by Виктор on 03.03.2024.
//

import UIKit
import Combine
import AVFAudio

final class ITunesSearchViewController: UIViewController {

    @IBOutlet private weak var ibSearchBar: UISearchBar!
    @IBOutlet private weak var ibTableView: UITableView!
    
    @IBOutlet private weak var ibDataLabel: UILabel!
    @IBOutlet private weak var ibActivityIndicator: UIActivityIndicatorView!
    
    private var cancelable = Set<AnyCancellable>()
    
    var viewModel: ITunesSearchViewModel!
    var router: MusicUIKitRouterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        binding()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            self.viewModel.searchText = "deep"
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.viewModel.searchText = "inna"
        })
       
    }

    private func setup() {
        ibActivityIndicator.stopAnimating()
        
        ibSearchBar.delegate = self
        ibTableView.register(cellClass: MusicTableViewCell.self)
        
    }
    
    private enum SearchMode {
        case startLoad
        case endLoad
    }
    private func searchState(_ mode: SearchMode) {
        switch mode {
        case .startLoad:
            ibActivityIndicator.startAnimating()
            ibDataLabel.isHidden = true
        case .endLoad:
            ibActivityIndicator.stopAnimating()
            ibDataLabel.isHidden = viewModel.searchedMusicResult.count != 0
        }
        
    }
    
    private func binding() {
        viewModel.$searchedMusicResult
            .sink(receiveValue: {[unowned self] content in

                searchState(.endLoad)
                ibTableView.reloadData()
            }

         ).store(in: &cancelable)
    }
}

// MARK: - UITableViewDataSource

extension ITunesSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("searchText ", viewModel.searchText)
        print("resultCount ", viewModel.searchedMusicResult.count)
        print("\n")
        return viewModel.searchedMusicResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        MusicTableViewCell.className) as? MusicTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.searchedMusicResult[indexPath.item] // todo fix index
        
        cell.configere(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ITunesSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.searchedMusicResult[indexPath.item] // todo fix
        
        
        router.openMusic(item)
    }
}

// MARK: - UISearchBarDelegate

extension ITunesSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchState(.startLoad)
        viewModel.searchText = searchBar.text ?? ""
        
//        searchMusic(with: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}


