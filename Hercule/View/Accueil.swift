//
//  Acceuil.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 06/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SwiftyGif

struct Accueil: View {
    @EnvironmentObject var viewModel: AppviewModel
    @State var showsAlert = false
    @State var showsAlertpanier = false
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State var selected = "Tout"
    @Namespace var animation
    @State var show = false
    @State var showajout = false
    
    
    @State var selectedEquip: Equipement = equipement[0]
    
    var body: some View {
        VStack {
            ZStack {
                Text("HERCULE")
                    .font(Font.custom("RobotaNonCommercialRegular", size: 35))
                    .foregroundColor(Color.black)
            }
            .padding(.top, -70)
            
            if viewModel.usertype == "admin" && viewModel.auth.currentUser !== nil{
                Button(action: {
                    showajout.toggle()
                }, label: {
                    Text("Ajouter un Equipement")
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
                    .padding()
            }
            HStack(spacing: 0){

                FiltreButtonw(title: "Tout", selected: $selected, animation: animation)
                Spacer(minLength: 0)
                ForEach(types,id: \.self){type in
                    FiltreButtonw(title: type, selected: $selected, animation: animation)
                    if types.last != type{
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding()
            .padding(.top, 5)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    if !viewModel.equipement.isEmpty{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15),count: 2)){
                            if selected == "Tout"{
                                ForEach(viewModel.equipement.reversed()) {equip in
                                    Button(action: {
                                        selectedEquip = equip
                                        show.toggle()
                                    }) {
                                        EquipVieww(equip: equip, animation: animation)
                                    }
                                }
                            }
                            if selected == types[0]{
                                ForEach(viewModel.equipement) {equip in
                                    if equip.type == "Velo"{
                                        EquipVieww(equip: equip, animation: animation)
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    selectedEquip = equip
                                                    show.toggle()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                            }
                            if selected == types[1]{
                                ForEach(viewModel.equipement) {equip in
                                    if equip.type == "Rameur"{
                                        EquipVieww(equip: equip, animation: animation)
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    selectedEquip = equip
                                                    show.toggle()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                            }
                            if selected == types[2]{
                                ForEach(viewModel.equipement) {equip in
                                    if equip.type == "Haltere"{
                                        EquipVieww(equip: equip, animation: animation)
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    selectedEquip = equip
                                                    show.toggle()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                            }
                            if selected == types[3]{
                                ForEach(viewModel.equipement) {equip in
                                    if equip.type == "Tapis"{
                                        EquipVieww(equip: equip, animation: animation)
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    selectedEquip = equip
                                                    show.toggle()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    else{
                        Text("Aucun equipement n'est disponible").foregroundColor(Color.red)
                    }
                }
            }
            
        }
        .sheet(isPresented: $show) {
            Commander_infow(selectedEquip: $selectedEquip, show: $show, animation: animation)
                .background(Color("bgw").ignoresSafeArea())
        }
        .sheet(isPresented: $showajout) {
            Commander_ajouter()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bgw").ignoresSafeArea())
                .navigationBarTitle("") //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct EquipVieww: View {
    @EnvironmentObject var viewModel: AppviewModel
    var equip: Equipement
    var animation: Namespace.ID
    @State var selected = ""
    @State var showsAlert = false
    @State var show = false
    @State var showco = false
    @State var showsAlertpanier = false
    
    var body: some View {
    
        VStack{
            HStack{
                Spacer(minLength: 0)
                (Text(equip.prix + " €")
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                 
                 + Text(" /h")
                    .foregroundColor(.blue))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .cornerRadius(15)
            }
            
            Image(equip.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .matchedGeometryEffect(id: "image\(equip.id)", in: animation)
                .padding(.top, 37)
                .padding(.bottom)
                .padding(.horizontal, 10)
            
            Text(equip.modele)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(equip.desc)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .opacity(0.50)
            
            HStack{
                
                if viewModel.usertype == "admin" && viewModel.auth.currentUser !== nil{
                    Button(action: {
                        self.showsAlert.toggle()
                        
                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                        //                            .matchedGeometryEffect(id: "trash\(equip.id)", in: animation)
                            .alert(isPresented: self.$showsAlert) {
                                Alert(
                                    title: Text("Êtes-vous sure ?"),
                                    message: Text("Cette action est irreversible"),
                                    primaryButton: .destructive(Text("Supprimer")) {
                                        viewModel.suppEquip(id: equip.id)
                                    },
                                    secondaryButton: .cancel(Text("Annuler"))
                                )
                                
                            }
                    }
                    
                }
                Spacer(minLength: 0)
                if viewModel.auth.currentUser !== nil{
                    Button(action: {
                        self.showsAlertpanier.toggle()
                        
                    }){
                        Image(systemName: "cart.badge.plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .alert(isPresented: self.$showsAlertpanier) {
                                Alert(
                                    title: Text("Voulez-vous l'ajoutez au panier ?"),
                                    primaryButton: .default(Text("Ajouter")) {
                                        viewModel.EquiptoCart(id_equip: equip.id)
                                            viewModel.glow(button: "cart")
                                        viewModel.cart.removeAll()
                                        viewModel.cartcount.removeAll()
                                        viewModel.getChildren_cart()
                                    },
                                    secondaryButton: .cancel(Text("Annuler"))
                                )
                                
                            }
                    }
                }
                else{
                    Button(action: {
                        self.showsAlertpanier.toggle()
                        
                    }){
                        Image(systemName: "cart.badge.plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .alert(isPresented: self.$showsAlertpanier) {
                                Alert(
                                    title: Text("Veuillez vous connecter pour remplir votre panier"),
                                    primaryButton: .default(Text("Se connecter")) {
                                        showco.toggle()
                                        
                                    },
                                    secondaryButton: .cancel(Text("Annuler"))
                                )
                                
                            }
                    }
                }
            }.padding(.horizontal, 10)
            
        }
        .frame(width: 175, height: 256)
        .padding(.bottom)
        .background((LinearGradient(gradient: .init(colors: [Color("g1w"), Color("g1w")]), startPoint: .top, endPoint: .bottom)))
        .cornerRadius(15)
        .padding()
        if viewModel.auth.currentUser == nil{
            Text("")
                .sheet(isPresented: $showco) {
                    NavigationView{
                        Compte_signin()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("bg").ignoresSafeArea())
                            .onTapGesture {
                                hideKeyboard()
                            }
                            .onAppear {
                            viewModel.signedIn = viewModel.isSignedIn
                            viewModel.getChildren()
                        }
                    }
                    .navigationBarTitle("") //this must be empty
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .tag(tabs[3])
                    .background(Color("bg").ignoresSafeArea())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
    }
}

struct Commander_infow: View {
    @EnvironmentObject var viewModel: AppviewModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Binding var selectedEquip: Equipement
    @Binding var show: Bool
    @State var showsAlert = false
    @State var showsAlertpanier = false
    @State var showco = false
    
    var animation: Namespace.ID
    
//    var equipid: Any
    var body: some View {
        
        VStack{
            HStack(spacing: 25){
                Button(action: {
                    withAnimation(.spring()){show.toggle()}
                } ){
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top, 15)
            
            VStack(spacing: 10){
                Image(selectedEquip.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 320)
                    .padding()
                
                Text(selectedEquip.modele)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Text(selectedEquip.desc_comp)
                    .foregroundColor(.black)
                    .opacity(0.50)
                    .padding(.top, 4)
                    .fixedSize(horizontal: false, vertical: true)
                if viewModel.usertype == "admin" && viewModel.auth.currentUser !== nil{
                    HStack{
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
                                            viewModel.suppEquip(id: selectedEquip.id)
                                        },
                                        secondaryButton: .cancel(Text("Annuler"))
                                    )
                                    
                                }
                        }
                        Spacer(minLength: 0)
                    }.padding()
                }
                
            }
            .frame(height: 520)
            .padding(.bottom)
            .background((LinearGradient(gradient: .init(colors: [Color("g1w"), Color("g1w")]), startPoint: .top, endPoint: .bottom)))
            .cornerRadius(15)
            .padding()
            
            Spacer()
            
            if viewModel.auth.currentUser !== nil{
                Button(action: {
                    self.showsAlertpanier.toggle()
                }, label: {
                    Text("AJOUTER AU PANIER")
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 320, height: 50)
                        .background(Color.blue)
                        .cornerRadius(2)
                        .alert(isPresented: self.$showsAlertpanier) {
                            Alert(
                                title: Text("Voulez-vous l'ajoutez au panier ?"),
                                primaryButton: .default(Text("Ajouter")) {
                                    viewModel.EquiptoCart(id_equip: selectedEquip.id)
                                    viewModel.glow(button: "cart")
                                    viewModel.cart.removeAll()
                                    viewModel.cartcount.removeAll()
                                    viewModel.getChildren_cart()
                                    withAnimation(.spring()){show.toggle()}
                                },
                                secondaryButton: .cancel(Text("Annuler"))
                            )
                            
                        }
                }).padding(.bottom, 70)
            }
            else{
                Button(action: {
                    self.showsAlertpanier.toggle()
                }, label: {
                    Text("AJOUTER AU PANIER")
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 320, height: 50)
                        .background(Color.blue)
                        .cornerRadius(2)
                        .alert(isPresented: self.$showsAlertpanier) {
                            Alert(
                                title: Text("Veuillez vous connecter pour remplir votre panier"),
                                primaryButton: .default(Text("Se connecter")) {
                                    showco.toggle()
                                    
                                },
                                secondaryButton: .cancel(Text("Annuler"))
                            )
                            
                        }
                }).padding(.bottom, 70)
            }
            
        }
        if viewModel.auth.currentUser == nil{
            Text("")
                .sheet(isPresented: $showco) {
                    NavigationView{
                        Compte_signin()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("bg").ignoresSafeArea())
                            .onTapGesture {
                                hideKeyboard()
                            }
                            .onAppear {
                            viewModel.signedIn = viewModel.isSignedIn
                            viewModel.getChildren()
                        }
                    }
                    .navigationBarTitle("") //this must be empty
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .tag(tabs[3])
                    .background(Color("bg").ignoresSafeArea())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
    }
}

struct FiltreButtonw: View{
    var title: String
    @Binding var selected: String
    
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){selected = title}
        })  {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(selected == title ? .white : .black)
                .padding(.vertical, 10)
                .padding(.horizontal, selected == title ? 20 : 0)
                .background(
                    
                    ZStack{
                        
                        if selected == title{
                            
                            Color.black
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "type", in: animation)
                            
                        }
                    }
                )
        }
    }
    
}

