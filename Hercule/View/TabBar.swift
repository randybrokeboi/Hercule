//
//  TabBar.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 08/12/2021.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var viewModel: AppviewModel
    @State var currentTab = "house"
    @Namespace var animation
    init(){
        UITabBar.appearance().isHidden = true
    }
    @State var safeArea = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.safeAreaInsets
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $currentTab){
                NavigationView{
                    Commander()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                }
                .navigationBarTitle("") //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .tag(tabs[0])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                NavigationView{
                    Accueil()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bgw").ignoresSafeArea())
                }
                .navigationBarTitle("") //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .tag(tabs[1])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                NavigationView{
                    Panier()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .onAppear {
                            viewModel.effet = ""
                            viewModel.total()
                    }
                }
                .navigationBarTitle("") //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .tag(tabs[2])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if viewModel.auth.currentUser !== nil {
                    
                    Compte()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[3])
                        .background(Color("bg").ignoresSafeArea())
                        .navigationBarTitle("") //this must be empty
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                            viewModel.signedIn = viewModel.isSignedIn
                            viewModel.getChildren()
                    }
                }
                else{
                    NavigationView{
                        Compte_signin()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("bg").ignoresSafeArea())
                            .onTapGesture {
                                hideKeyboard()
                            }
                            .onAppear {
                            viewModel.signedIn = viewModel.isSignedIn
                        }
                    }
                    .navigationBarTitle("") //this must be empty
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .tag(tabs[3])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                    
                
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .tag(tabs[3])
//                .background(Color("bg").ignoresSafeArea())  
            }
            .onAppear {
                viewModel.signedIn = viewModel.isSignedIn
                viewModel.getChildren()
                viewModel.equipement.removeAll()
                viewModel.getChildren_equip()
                viewModel.cart.removeAll()
                viewModel.cartcount.removeAll()
                viewModel.getChildren_cart()
            }
            
            HStack(spacing: 35){
                ForEach(tabs,id: \.self){image in
                    
                    TabButton(image: image, selected: $currentTab, animation: animation)
                    
                    
                }
            }
            .padding(.horizontal, 35)
            .padding(.top)
            .padding(.bottom, safeArea?.bottom != 0 ? safeArea?.bottom: 15)
            .background(
                LinearGradient(gradient: .init(colors: [Color("g1"), Color("g2")]), startPoint: .top, endPoint: .bottom))
            .clipShape(CustomCorner(corners: [.topLeft, .topRight]))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}



struct TabButton: View {
    @EnvironmentObject var viewModel: AppviewModel
    var image: String
    @Binding var selected : String
    @State private var animationAmount = 2.0
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.spring()){selected = image}
        }){
            
            VStack(spacing: 12){
                
                Image(systemName: image)
                    .font(.system(size: 25))
                    .foregroundColor(viewModel.effet == image ? .blue : selected == image ? .white : .gray )
                
                ZStack{
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 8, height: 8)
                    if selected == image{
                        Circle()
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                            .frame(width: 8, height: 8)
                    }
                    
                    if viewModel.effet == image{
                            Circle()
                                .fill(Color.blue)
                                .matchedGeometryEffect(id: "Tabb", in: animation)
                                .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
    
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

var tabs = ["house", "book", "cart", "person"]
