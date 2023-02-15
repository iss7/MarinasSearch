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
        // only search for points of interest near the user if we have their location
        var locationString = ""
        if let data = UserDefaults.standard.object(forKey: "location") as? Data,
           let location = try? JSONDecoder().decode(UserLocation.self, from: data) {
            locationString = "&location[lat]=\(location.lat)&location[lon]=\(location.lon)"
        }
        let urlString = "\(pointSearch)?kinds[]=\(interestType.rawValue)\(locationString)"
        guard let url = URL(string: urlString) else {
            print("Error creating URL")
            completion([])
            return
        }

        fetchPoints(url: url, completion: completion)
    }

    func fetchPointsBySearchTerm(searchTerm: String, completion: @escaping ([InterestPoint]) -> Void) {
        // TODO: Ideally there would be more string processing here to validate search terms
        let queryString = searchTerm.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(pointSearch)?query=\(queryString)"
        guard let url = URL(string: urlString) else {
            print("Error creating URL")
            completion([])
            return
        }

        fetchPoints(url: url, completion: completion)
    }

    private func fetchPoints(url: URL, completion: @escaping ([InterestPoint]) -> Void) {
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
            if let data = data {
                let decoder = JSONDecoder()
                        do {
                            let interestPoints = try decoder.decode(InterestPointSet.self, from: data)
                            return completion(interestPoints.data)
                        } catch  {
                           print(error)
                        }
            }
            completion([])
        })

        task.resume()
    }
}
