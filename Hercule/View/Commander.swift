//
//  Commander.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 06/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SwiftyGif

struct Equipement: Identifiable {
    var id: String = UUID().uuidString
    var modele: String
    var type: String
    var desc: String
    var desc_comp: String
    var prix: String
    var indexx: Int
    var image: String
}

var types = ["Velo", "Rameur", "Haltere", "Tapis"]
var equipement = [Equipement(id: "", modele: "", type: "", desc: "", desc_comp:"", prix: "", indexx: 0, image: "")]

struct Commander: View {
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
                    .foregroundColor(Color.white)
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

                FiltreButton(title: "Tout", selected: $selected, animation: animation)
                Spacer(minLength: 0)
                ForEach(types,id: \.self){type in
                    FiltreButton(title: type, selected: $selected, animation: animation)
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
                                        EquipView(equip: equip, animation: animation)
                                    }
                                }
                            }
                            if selected == types[0]{
                                ForEach(viewModel.equipement) {equip in
                                    if equip.type == "Velo"{
                                        EquipView(equip: equip, animation: animation)
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
                                        EquipView(equip: equip, animation: animation)
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
                                        EquipView(equip: equip, animation: animation)
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
                                        EquipView(equip: equip, animation: animation)
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
            Commander_info(selectedEquip: $selectedEquip, show: $show, animation: animation)
                .background(Color("bg").ignoresSafeArea())
        }
        .sheet(isPresented: $showajout) {
            Commander_ajouter()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bg").ignoresSafeArea())
                .navigationBarTitle("") //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct EquipView: View {
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
                    .foregroundColor(.white)
                 
                 + Text(" /h")
                    .foregroundColor(.blue))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.5))
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
                .foregroundColor(.white)
            
            Text(equip.desc)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
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
        .background((LinearGradient(gradient: .init(colors: [Color("g1"), Color("g2")]), startPoint: .top, endPoint: .bottom)))
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

struct Commander_ajouter: View {
    @State var type_equip = "Velo"
    @State var modele = ""
    @State var desc = ""
    @State var desc_comp = ""
    @State var prix = ""
    @State var image = ""
    @State var showsAlert = false
    @State var showajout = false
    
    @EnvironmentObject var viewModel: AppviewModel
    
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
            VStack{
                Picker(selection: $type_equip, label: Text("type d'equipement") ) {
                    ForEach(types, id: \.self) {
                        Text($0).font(.system(size: 25))
                        
                    }
                    
                }.pickerStyle(WheelPickerStyle())
                
                Form{
                    
                    TextField("modele", text: $modele)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TextField("description", text: $desc)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TextField("description Complète", text: $desc_comp)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TextField("prix", text: $prix)
                        .disableAutocorrection(true)
                        .keyboardType(.numbersAndPunctuation)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TextField("image", text: $image)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
                .background(Color("bg").ignoresSafeArea())
                Button(action: {
                    
                    guard !type_equip.isEmpty, !modele.isEmpty, !prix.isEmpty else{
                        return
                    }
                    
                    viewModel.ajouterEquip(type_equip: type_equip, modele: modele, prix: prix, desc: desc, desc_comp: desc_comp, image: image)
                    self.showsAlert.toggle()
                    viewModel.equipement.removeAll()
                    viewModel.getChildren_equip()
                    
                }, label: {
                    Text("Ajouter l'equipement")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .alert(isPresented: self.$showsAlert) {
                            Alert(title: Text("Vous venez d'ajouter un Équipement"))
                            
                        }
                })
                
                
                
            }
            .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct Commander_info: View {
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
                        .foregroundColor(.white)
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
                    .foregroundColor(.white)
                
                Text(selectedEquip.desc_comp)
                    .foregroundColor(.gray)
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
            .background((LinearGradient(gradient: .init(colors: [Color("g1"), Color("g2")]), startPoint: .top, endPoint: .bottom)))
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

struct FiltreButton: View{
    var title: String
    @Binding var selected: String
    
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){selected = title}
        })  {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(selected == title ? .black : .white)
                .padding(.vertical, 10)
                .padding(.horizontal, selected == title ? 20 : 0)
                .background(
                    
                    ZStack{
                        
                        if selected == title{
                            
                            Color.white
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "type", in: animation)
                            
                        }
                    }
                )
        }
    }
    
}

struct Commande_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AppviewModel()
        Commander().preferredColorScheme(.dark).environmentObject(viewModel)
    }
}
