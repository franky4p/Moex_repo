//
//  ContentView.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List{
                ForEach(viewModel.rezult) { value in
                    NavigationLink (destination: DetailView().environmentObject(viewModel)) {
                        HStack {
                            Text("\(value.shortName ?? "")")
                            Text("\(value.value ?? 0)")
                        }
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
