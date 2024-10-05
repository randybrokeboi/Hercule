//
//  Compte.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 06/12/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SwiftyGif

struct Compte: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AppviewModel
    
    var body: some View {
        
        VStack{
            ZStack {
                Text("HERCULE")
                //                    .fontWeight(.black)
                    .font(Font.custom("RobotaNonCommercialRegular", size: 35))
                
            }
            .padding([.horizontal, .bottom])
            .padding(.top, 10)
            
            let userEmail = viewModel.auth.currentUser?.email
            
            (Text("Bonjour ") + Text(viewModel.userprenom) + Text(" ") + Text(viewModel.usernom).fontWeight(.black)).padding()
            if userEmail != nil{
                (Text("Votre e-mail : ") + Text(userEmail!).fontWeight(.black)).padding()
            }
            if viewModel.usertype == "admin"{
                (Text("Vous etes ✨") + Text(viewModel.usertype).foregroundColor(Color.yellow).fontWeight(.black) + Text("✨")).padding()
                
            }
            Button(action: {
                viewModel.signOut()
            }, label: {
                Text("Se deconnecter")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 50)
                    .cornerRadius(8)
                    .background(Color.red)
                    .padding()
            })
        }
        
    }
}

struct Compte_signin: View {
    @State var email = ""
    @State var password = ""
    @State var showsAlertSign = false
    @State var showsAlertSignvide = false
    @State private var isPresented = false
    @EnvironmentObject var viewModel: AppviewModel
    
    var body: some View {
        
        VStack{
            
            ZStack {
                Text("HERCULE")
                //                    .fontWeight(.black)
                    .font(Font.custom("RobotaNonCommercialRegular", size: 35))
                    .foregroundColor(.white)
                
            }
            .padding(.top, -70)
            
            VStack{
                HStack{
                    Image(systemName: "envelope").foregroundColor(.white)
                    TextField("email", text: $email).textContentType(.emailAddress)
                        .multilineTextAlignment(.leading)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding()
                .background(Color("g2"))
                .cornerRadius(8)
                
                HStack{
                    Image(systemName: "lock").foregroundColor(.white)
                    SecureField("mot de passe", text: $password).textContentType(.password)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color("g2"))
                .cornerRadius(8)
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else{
                        showsAlertSignvide.toggle()
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    viewModel.showsAlertSign = false
                    viewModel.cart.removeAll()
                    viewModel.cartcount.removeAll()
                    viewModel.getChildren_cart()
                    isPresented.toggle()
                }, label: {
                    Text("Se connecter")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                    
                        .alert(isPresented: $showsAlertSignvide) {
                            Alert(title: Text("Veuillez remplir tout les champs !"))
                        }
                    //                    .alert(isPresented: $showsAlertSign) {
                    //                        Alert(title: Text("Vos identifiants sont faux !"))
                    //                            }
                    //                    .alert(isPresented: $showsAlertSign) {
                    //                        Alert(title: Text("Vos identifiants sont faux !"))
                    //                    }
                }).cornerRadius(8)
                
                if viewModel.showsAlertSign == true{
                    
                    Text("")
                        .alert(isPresented: $isPresented) {
                            Alert(title: Text("Vos identifiants sont faux !"))
                        }
                }
                
                HStack{
                    Text("Vous ne possedez pas de compte ?")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    NavigationLink("S'inscrire", destination: Compte_signup())
                        .font(.system(size: 14))
                    
                }
                .padding(.top, 40)
            }.padding()
            
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bg").ignoresSafeArea())
            .navigationBarTitle("") //this must be empty
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

struct Compte_signup: View {
    @State var email = ""
    @State var password = ""
    @State var password2 = ""
    @State var prenom = ""
    @State var nom = ""
    @State var erreur = ""
    @State var showsAlert = false
    @State var showsAlertSign = false
    @State var showsAlertSignpass = false
    @State var showsAlertSignexist = false
    @EnvironmentObject var viewModel: AppviewModel
    
    var body: some View {
        
        
        NavigationView{
            VStack{
                ZStack {
                    Text("HERCULE")
                    //                    .fontWeight(.black)
                        .font(Font.custom("RobotaNonCommercialRegular", size: 35))
                        .foregroundColor(.white)
                }
                .padding(.top, -70)
                VStack{
                    HStack{
                        Image(systemName: "person.text.rectangle").foregroundColor(.white)
                        TextField("prénom", text: $prenom).textContentType(.givenName)
                            .disableAutocorrection(true)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color("g2"))
                    .cornerRadius(8)
                    
                    HStack{
                        Image(systemName: "person.text.rectangle").foregroundColor(.white)
                        TextField("nom", text: $nom).textContentType(.familyName)
                            .disableAutocorrection(true)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color("g2"))
                    .cornerRadius(8)
                    
                    HStack{
                        Image(systemName: "envelope").foregroundColor(.white)
                        TextField("email", text: $email).textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color("g2"))
                    .cornerRadius(8)
                    
                    
                    
                    Text("Votre mot de passe doit contenir au minimum 6 caractères")
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .padding(.top, 10)
                    HStack{
                        Image(systemName: "lock").foregroundColor(.white)
                        SecureField("mot de passe", text: $password).textContentType(.newPassword)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("g2"))
                    .cornerRadius(8)
                    
                    HStack{
                        Image(systemName: "lock").foregroundColor(.white)
                        SecureField("Confirmer le mot de passe", text: $password2).textContentType(.newPassword)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("g2"))
                    .cornerRadius(8)
                    
                    Button(action: {
                        
                        guard !email.isEmpty, !password.isEmpty, !password2.isEmpty, !prenom.isEmpty, !nom.isEmpty else{
                            showsAlertSign.toggle()
                            erreur = "Veuillez remplir tout les champs !"
                            return
                        }
                        guard password == password2 else{
                            showsAlertSign.toggle()
                            erreur = "Les mots de passes saisies ne sont pas identiques !"
                            return
                        }
                        
                        viewModel.signUp(email: email, password: password, prenom: prenom, nom: nom)
                        
                    }, label: {
                        Text("S'inscrire")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .alert(isPresented: $showsAlertSign) {
                                Alert(title: Text(erreur))
                            }
    //                        .alert(isPresented: $showsAlertSignexist) {
    //                            Alert(title: Text("Ce compte existe deja"))
    //                        }
                    })
                        .cornerRadius(8)
                    HStack{
                        Text("Vous possedez deja un compte ?")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        NavigationLink("Se connecter", destination: Compte_signin())
                            .font(.system(size: 14))
                            
                    }
                    .padding(.top, 40)
                }.padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bg").ignoresSafeArea())
            .navigationBarTitle("") //this must be empty
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        
        .navigationBarTitle("") //this must be empty
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .tag(tabs[3])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        
    }
}

//struct Compte_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = AppviewModel()
//        Compte().preferredColorScheme(.dark).environmentObject(viewModel)
//    }
//}
