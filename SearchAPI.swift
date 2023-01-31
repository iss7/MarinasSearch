//
//  SearchAPI.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/30/23.
//

import Foundation

@MainActor
public final class SearchAPI {
    private var pointSearch = "https://api.marinas.com/v1/points/search"

    func fetchPointsByKind(interestType: InterestPointType, completion: @escaping ([InterestPoint]) -> Void) {
        // TODO: this urlstring is not properly formatted (issue with 'kinds')
        let urlString = "\(pointSearch)?kinds=\(interestType.rawValue)"
        guard let url = URL(string: urlString) else {
            print("Error creating URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error making api call for \(url), error: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completion([])
                return
            }
            if let data, let interestPoints = try? JSONDecoder().decode(InterestPointSet.self, from: data) {
                return completion(interestPoints.data)
            }
            completion([])
        })

        task.resume()
    }
}
