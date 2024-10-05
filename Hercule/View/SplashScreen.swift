//
//  SplashScreen.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 06/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SwiftyGif
import SDWebImageSwiftUI


struct SplashScreen: View{
    @State var animationFinished: Bool = false
    @State var animationStarted: Bool = false
    @State var removeGif = false
    
    var body: some View {
        
        ZStack{
            
            ContentView()
            
            ZStack{
                
                
                
                Color(red: 0, green: 0, blue: 0)
                    .ignoresSafeArea()
                
                if !removeGif{
                    ZStack{
                        if animationStarted{
                            
                            if animationFinished{
                                Image("logo-gif-24")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 480, height: 480)
                            }
                            else{
                                AnimatedImage(url: getLogoUrl())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 480, height: 480)
                            }
                        }
                        else{
                            Image("logo-gif-1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 480, height: 480)
                        }
                    }
                    .animation(.none, value: animationFinished)
                }
                
            }
            .opacity(animationFinished ? 0 : 1)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                
                animationStarted = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                    
                    withAnimation(.easeInOut(duration: 0.7)){
                        animationFinished = true
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                        removeGif = true
                    }
                    
                }
            }
            
        }
    }
    
    func getLogoUrl()->URL{
        let bundle = Bundle.main.path(forResource: "logo-gif", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AppviewModel()
        SplashScreen().environmentObject(viewModel)
    }
}
