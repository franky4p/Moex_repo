//
//  Session.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import Foundation
import Unrealm

final class Session {
    var token: String?
    var userId: Int?
    let session =  URLSession(configuration: URLSessionConfiguration.default)

    static let shared = Session()
    
    private init() {}
    
    func saveData<T: Realmable>(_ data: [T]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(data, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func justForTest(_ pk: Int) {
        let realm = try! Realm()
        let savedItem = realm.object(ofType: Shares.self, forPrimaryKey: pk)
        print(savedItem!.boardID)
    }
    
    func loadData<T>(_ typeReceiver: T.Type) -> Unrealm.Results<T> where T:Realmable {
        let realm = try! Realm()
        let savedItem = realm.objects(T.self)
        return savedItem
    }
    
    func requestToAPI<T: Decodable>(url: URLRequest, typeReceiver: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = self.session.dataTask(with: url) { (data, response, error) in
            //для отладки
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
            print(json)
            ////
            guard let data = data else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
        }
        task.resume()
    }
}

final class RequestMoex {
    static let scheme: String = "https"
    static let hostAPI: String = "iss.moex.com"
    
    static func requestShares() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = hostAPI
        urlComponents.path = "/iss/history/engines/stock/markets/shares/securities/.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "start", value: "0"),
            URLQueryItem(name: "limit", value: "10") //возможны значения 100, 50, 20, 10, 5, 1
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        return request
    }
}

func getDateFromServer<T>(typeDate: T.Type, request: URLRequest) where T:Decodable, T:Realmable {
    Session.shared.requestToAPI(url: request, typeReceiver: Root<T>.self){ results in
        var data: [T] = [T]()
        switch results {
        case .success(let response):
            response.response.items.forEach {
             data.append($0)
            }
            
            Session.shared.saveData(data)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

func updateFromServer() {
    let opq = OperationQueue()
    let requestShares = RequestMoex.requestShares()
    
    let operShares = GetDataOperation(request: requestShares, typeDate: Shares.self)
    operShares.completionBlock = {
        Session.shared.saveData(operShares.data)
    }
    
    opq.addOperation(operShares)
    
}
