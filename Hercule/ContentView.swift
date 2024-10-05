//
//  ContentView.swift
//  Hercule
//
//  Created by Randy Semedo rodrigues on 16/11/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

class AppviewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var userprenom : String = ""
    @Published var usernom : String = ""
    @Published var usertype : String = ""
    @Published var effet : String = ""
    @Published var equipement = [Equipement]()
    @Published var cart = [Cart]()
    @Published var Total = 0.0
    @Published var cartcount : String = ""
    @Published var signedIn = false
    @Published var showsAlertSign = false
    
//    @State var showsAlertSign = false
    var isSignedIn: Bool {
        return auth.currentUser == nil
    }
    
    func glow(button: String) {
        effet = button
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                
                    self?.showsAlertSign = true
                    print(error?.localizedDescription as Any )
                    print(self?.showsAlertSign as Any)
                  
                return
            }
            self?.showsAlertSign = false
            self?.cart.removeAll()
            self?.cartcount.removeAll()
            self?.getChildren_cart()
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    func signUp(email: String , password: String, prenom: String, nom: String){
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                print(error.debugDescription)
                return
            }
            
            //Success
            let ref = Database.database().reference()
            let UserId = Auth.auth().currentUser?.uid
            
            let postInfo = ["prenom": prenom, "nom": nom, "type": "client"] as [String : Any]
            print(postInfo)
            ref.child("users/"+UserId!).setValue(postInfo)
            
            
            self?.cart.removeAll()
            self?.cartcount.removeAll()
            self?.getChildren_cart()
            
            DispatchQueue.main.async {
                self?.signedIn = true
                
                
            }
            
        }
        
    }
    func signOut() {
        try? auth.signOut()
        self.cart.removeAll()
        self.cartcount.removeAll()
        self.getChildren_cart()
        self.signedIn = false
        
    }
    
    func userinfo() -> User?{
        return auth.currentUser
    }
    
    func getChildren() {
        let ref = Database.database().reference()
        let UserId = Auth.auth().currentUser?.uid
        if UserId != nil{
            ref.child("users").child(UserId!).observeSingleEvent(of: .value) { snapshot in
                let value = snapshot.value as? NSDictionary
                
                self.userprenom = value?["prenom"] as? String ?? "pas de prenom"
                self.usernom = value?["nom"] as? String ?? "pas de nom"
                self.usertype = value?["type"] as? String ?? "pas de type"
            }
        }
    }
    
    func getChildren_equip() {
        let ref = Database.database().reference()
        let equip = ref.child("equipements")
        
        equip.queryOrdered(byChild: "type").observeSingleEvent(of: .value, with: { (snapshot) in
            var n = 0
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let equipid = userSnap.key //the id of each equip
                let userDict = userSnap.value as! [String:AnyObject] //child data
                //let value = snapshot.value as? NSDictionary
                self.equipement.append(
                    Equipement(id: (equipid),
                               modele: userDict["modele"] as? String ?? "",
                               type: userDict["type"] as? String ?? "",
                               desc: userDict["desc"] as? String ?? "",
                               desc_comp: userDict["desc_comp"] as? String ?? "",
                               prix: userDict["prix"] as? String ?? "",
                               indexx: n,
                               image: userDict["image"] as? String ?? ""
                              ))
                n = n+1
                print(userDict["modele"]!)
            }
            print(self.equipement.count)
        })
    }
    
    func ajouterEquip(type_equip: String , modele: String, prix: String, desc: String, desc_comp: String, image: String){
        //Success
        
        let ref = Database.database().reference()
        
        let equipId = ref.child("equipements/").childByAutoId()
        let postInfo = ["prix": prix, "modele": modele, "type": type_equip, "desc": desc, "desc_comp": desc_comp, "disponible": true, "image": image] as [String : Any]
        print(postInfo)
        equipId.setValue(postInfo)
    }
    
    func EquiptoCart(id_equip: String){
        let ref = Database.database().reference()
        let UserId = Auth.auth().currentUser?.uid
        
        let CartId = ref.child("carts/").child(UserId!).child(id_equip)
        let postInfo = ["quantite": 1] as [String : Any]
        print(postInfo)
        CartId.setValue(postInfo)
        
    }
    
    func getChildren_cart() {
        print(self.cart.count)
        cart.removeAll()
        print(self.cart.count)
        let ref = Database.database().reference()
        self.Total = 0
        let UserId = Auth.auth().currentUser?.uid
        if UserId != nil{
            let car = ref.child("carts").child(UserId!)
            car.observeSingleEvent(of: .value, with: { (snapshot) in
                for snap in snapshot.children {
                    let userSnap = snap as! DataSnapshot
                    let equipid = userSnap.key //the id of each equip
                    //let value = snapshot.value as? NSDictionary
                    self.cart.append(
                        Cart(id: (equipid),
                             id_user: (UserId!)
                            ))
                    for equip in (self.equipement) {
                        if equipid == equip.id{
                            self.Total = self.Total + Double(equip.prix)!
                            print("--------------------")
                            print(Float(equip.prix)!)
                            print("--------------------")
                        }
                    }
                }
                self.cartcount = String(self.cart.count)
                print("print cart count")
                print(self.cart.count)
                print("-----------")
                
            })
        }
        else{
            self.cartcount = "0"
        }
//        DispatchQueue.main.async {
//            self.total()
//        }
    }
    
    func total(){
        self.Total = 0
        
        
        for pan in (self.cart) {
            for equip in (self.equipement) {
                if pan.id == equip.id{
                    self.Total = self.Total + Double(equip.prix)!
                    print("--------------------")
                    print(Float(equip.prix)!)
                    print("--------------------")
                }
            }
        }
        print(Float(self.Total))
                
    }
    
    func suppEquip(id: String){
        //Success
        
        let ref = Database.database().reference()
        
        ref.child("equipements/").child(id).removeValue()
        self.equipement.removeAll()
        self.getChildren_equip()
        
    }
    
    func suppCart(id: String){
        //Success
        
        let ref = Database.database().reference()
        let UserId = Auth.auth().currentUser?.uid
        
        ref.child("carts/").child(UserId!).child(id).removeValue()
        print("print cart :")
        print(cart)
        
    }
    
}



struct ContentView: View {
    @EnvironmentObject var viewModel: AppviewModel
    
    var body: some View {
        TabBar()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

