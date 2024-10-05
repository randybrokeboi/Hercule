//
//  Panier.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 06/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SwiftyGif

struct Cart: Identifiable {
    var id: String = UUID().uuidString
    var id_user: String
}

struct Panier: View {
    @EnvironmentObject var viewModel: AppviewModel
    @State var showsAlert = false
    @State var showsAlertpanier = false
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State var selected = "Tout"
    @State var Total = 0
    @Namespace var animation
    @State var show = false
    @State var showajout = false
    @State var selectedEquip: Equipement = equipement[0]
    
    var body: some View {
        
        VStack {
            ZStack {
                Text("HERCULE")
                    .font(Font.custom("RobotaNonCommercialRegular", size: 35))
            }
            .padding(.top, -70)
            (Text(viewModel.cartcount) + Text(" article(s) dans votre panier")).font(Font.system(size: 25)).padding(.top)
            ScrollView(.vertical, showsIndicators: false) {
                if viewModel.auth.currentUser !== nil{
                    VStack{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()),count: 1)){
                            ForEach(viewModel.cart) {pan in
                                ForEach(viewModel.equipement) {equip in
                                    if pan.id == equip.id{
                                        Button(action: {
                                            selectedEquip = equip
                                            show.toggle()
                                        }) {
                                            CartView(equip: equip, animation: animation)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                else{
                    Text("Veuillez vous connecter pour remplir votre panier").foregroundColor(Color.red)
                }
            }
            
            VStack{
                Text("TOTAL : ") + Text(String(Float(viewModel.Total))) + Text("€")
                Button(action: {
    //                showajout.toggle()
                }, label: {
                    Text("COMMANDER")
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 320, height: 50)
                        .background(Color.blue)
                        .cornerRadius(2)
                })
                    .padding(.bottom, 70)
            }
            
        }.sheet(isPresented: $show) {
            Commander_info(selectedEquip: $selectedEquip, show: $show, animation: animation)
                .background(Color("bg").ignoresSafeArea())
        }
    }
}


struct CartView: View{
    @EnvironmentObject var viewModel: AppviewModel
    var equip: Equipement
    var animation: Namespace.ID
    @State var showsAlert = false
    @State var showsAlertpanier = false
    
    var body: some View {
    
        HStack{
            Image(equip.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 10)
            Spacer(minLength: 0)
            VStack{
                Spacer(minLength: 0)
                Text(equip.desc)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fixedSize(horizontal: false, vertical: true)
                (Text(equip.prix + " €")
                    
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                 
                 + Text(" /h")
                    .foregroundColor(.blue))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .cornerRadius(8)
                Spacer(minLength: 0)
            }
            
            
            
            
            HStack{
//                Spacer(minLength: 0)
                if viewModel.auth.currentUser !== nil{
                    Button(action: {
                        self.showsAlert.toggle()
                        
                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                            .alert(isPresented: self.$showsAlert) {
                                Alert(
                                    title: Text("Êtes-vous sure ?"),
                                    message: Text("Cette action est irreversible"),
                                    primaryButton: .destructive(Text("Supprimer")) {
                                        viewModel.suppCart(id: equip.id)
                                        viewModel.cart.removeAll()
                                        viewModel.cartcount.removeAll()
                                        viewModel.getChildren_cart()
                                        print(viewModel.cart)
                                    },
                                    secondaryButton: .cancel(Text("Annuler"))
                                )
                                
                            }
                    }
                    
                }
            }.padding(.horizontal, 40)
            
        }
        .frame(width: 360, height: 75)
        .padding(.bottom)
        .background((LinearGradient(gradient: .init(colors: [Color("g1"), Color("g2")]), startPoint: .top, endPoint: .bottom)))
        .cornerRadius(12)
        
    }
}

