//
//  GetDataOperation.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import Foundation

class GetDataOperation <T> : AsyncOperation where T:Decodable {

    override func cancel() {
        super.cancel()
    }
    
    private var request: URLRequest
    private var typeDate: T.Type
    var data = [T]()
    
    override func main() {
        Session.shared.requestToAPI(url: request, typeReceiver: Root<T>.self){ [unowned self] results in
            if self.isCancelled { return }
            
            switch results {
            case .success(let response):
                response.response.items.forEach {
                    self.data.append($0)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.state = .finished
        }
    }
    
    init(request: URLRequest, typeDate: T.Type) {
        self.request = request
        self.typeDate = typeDate
    }
    
}
