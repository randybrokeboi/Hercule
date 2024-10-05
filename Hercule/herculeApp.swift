//
//  HerculeApp.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 16/11/2021.
//

import SwiftUI
import Firebase

@main
struct herculeApp: App {
    init() {
        FirebaseApp.configure()
        
    }
    
    
    
    var body: some Scene {
        
        WindowGroup {
            
//            ZStack(alignment: .top){
//                ZStack{
//                    Button {
//                        print("taper info")
//                    } label: {
//                            Image(systemName:"person.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 50)
//
//
//
//                    }.cornerRadius(25)
//                }
//                .padding(.leading, 300)
//                ZStack{
//                    NavigationView {
//                        NavigationLink(destination: client_info()) {
//                            Image(systemName:"doc.text.magnifyingglass")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 44)
//                        }
//                    }.padding(.trailing, 300)
//
//                }.padding(.top, 15)
//            }
            let viewModel = AppviewModel()
            SplashScreen()
                .environmentObject(viewModel)
            
            
        }
    }
}

