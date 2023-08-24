//
//  NetworkingService.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import UIKit

enum NetworkingError: Error {
    case invalidURL
    case fileNotFound(url: String)
    case networkError(message: String)
}

protocol NetworkingServiceProtocol {

    func fetchAdverts(completion: @escaping(Result<[Advert], Error>) -> Void)
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

class NetworkingService: NetworkingServiceProtocol {

    static let shared = NetworkingService()

    func fetchAdverts(completion: @escaping (Result<[Advert], Error>) -> Void) {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkingError.fileNotFound(url: url.description)))
                return
            }

            do {
                let advertResponse = try JSONDecoder().decode(AdvertResponse.self, from: data)
                let adverts = advertResponse.advertisements
                completion(.success(adverts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    #warning("Добавить обработку ошибок!")
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка при загрузке изображения: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            completion(image)
        }.resume()
    }
}
