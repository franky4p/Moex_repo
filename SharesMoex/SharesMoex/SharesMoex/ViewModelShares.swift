//
//  ViewModelShares.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import Foundation
import RealmSwift

class ViewModel: ObservableObject {
    @Published private var model: MoexApp = startApp()
    
    static func startApp() -> MoexApp {
        Realm.registerRealmables(Shares.self)
        
        updateFromServer()
        
        let dataRealm = Session.shared.loadData(Shares.self)
        var data: [Shares] = []
        dataRealm.forEach{ el in
            data.append(el)
        }
        
        return MoexApp(shares: data)
    }
    
    var rezult: Array<Shares> {
        model.shares
    }
}
