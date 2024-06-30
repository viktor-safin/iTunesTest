//
//  ITunesSearchNetworkService.swift
//  iTunesTest
//
//  Created by Виктор on 05.04.2024.
//

import Foundation
import Combine

protocol ITunesSearchNetworkServiceProtocol: AnyObject {
    func searchMusicResultCompletion(with text: String, _ completion: @escaping(Result<ITunesSearchResult, Error>) -> Void)
    func searchMusicPublisher(with text: String) -> AnyPublisher<ITunesSearchResult, Error>
}

final class ITunesSearchNetworkService {
    
    private var searchURLString: (_ searchText: String) -> String = { searchText in
        return "https://itunes.apple.com/search?term=\(searchText)"
    }
}

extension ITunesSearchNetworkService: ITunesSearchNetworkServiceProtocol {
    
        
    func searchMusicResultCompletion(with text: String, _ completion: @escaping(Result<ITunesSearchResult, Error>) -> Void) {
        
        let url = URL(string: searchURLString(text))!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(ITunesError.invalidData))
                return
            }
            
            do {
                
                let iTunes = try JSONDecoder().decode(ITunesSearchResult.self, from: data)
                completion(.success(iTunes))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // fetch with AnyPublisher
    
    func searchMusicPublisher(with text: String) -> AnyPublisher<ITunesSearchResult, Error> {
        guard let url = URL(string: searchURLString(text))
        else {
            return Fail(error: ITunesError.invalidURL).eraseToAnyPublisher()
        }
        
        return
            URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
//            .tryMap { $0.data }
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw ITunesError.noSuccessStatusCode
                }
                guard let data = output.data as? Data else {
                    throw ITunesError.invalidData
                }
                return output.data
            }
            .decode(type: ITunesSearchResult.self, decoder: JSONDecoder())
            
        
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum ITunesError: Error {
    case invalidData
    case invalidURL
    case noSuccessStatusCode
}

