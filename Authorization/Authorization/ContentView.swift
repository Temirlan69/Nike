//
//  ContentView.swift
//  Authorization
//
//  Created by Tima on 08.12.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack{
            
            if status{
                
                Home()
                
                ContentViews()
            }
            else{
                
                SignIn()
            }
            
        }.animation(.spring())
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                    
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                }
        }
        
    }
}

struct Home : View {
    
    var body : some View{
        
        VStack{
            
            //Text("Home")
            
            Button(action: {
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            }) {
                
                Text("Logout")
            }
        }
    }
}

struct SignIn : View {
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @State var show = false
    
    var body : some View{
        VStack {
            VStack{
                Image("3")
                Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Username", text: $user)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        SecureField("Enter Your Password", text: $pass)
                        
                        Divider()
                    }
                    
                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                        
                        if !verified {
                            
                            self.message = status
                            self.alert.toggle()
                        }
                        else{
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                    
                }) {
                    
                    Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(Color.green)
                    .opacity(0.8)
                    .clipShape(Capsule())
                    .padding(.top, 45)
                
            }.padding()
                .alert(isPresented: $alert) {
                    
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
            }
            VStack{
                
                Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                
                
                HStack(spacing: 8){
                    
                    Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                    
                    Button(action: {
                        
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Sign Up")
                        
                    }.foregroundColor(.blue)
                    
                }.padding(.top, 25)
                
            }.sheet(isPresented: $show) {
                
                SignUp(show: self.$show)
            }
        }
    }
}

struct SignUp : View {
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @Binding var show : Bool
    
    var body : some View{
        
        VStack{
            Image("3")
            Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack{
                        
                        TextField("Enter Your Username", text: $user)
                        
                        if user != ""{
                            
                            Image("check").foregroundColor(Color.init(.label))
                        }
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    SecureField("Enter Your Password", text: $pass)
                    
                    Divider()
                }
                
            }.padding(.horizontal, 6)
            
            Button(action: {
                
                signUpWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified{
                        
                        self.message = status
                        self.alert.toggle()
                        
                    }
                    else{
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        
                        self.show.toggle()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
                Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(Color.green)
                .opacity(0.8)
                .clipShape(Capsule())
                .padding(.top, 45)
            
        }.padding()
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
        }
    }
}


func signInWithEmail(email: String,password : String,completion: @escaping (Bool,String)->Void){
    
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

func signUpWithEmail(email: String,password : String,completion: @escaping (Bool,String)->Void){
    
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
        
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

struct ContentViews: View {
    
    @State var show1 = true
    @State var show2 = false
    @State var show3 = false
    @State var show4 = false
    @State var showTop = false
    @State var showDetail = false
    @State private var showingDetail1 = false
    @State private var showingDetail2 = false
    
    var body: some View {
        ZStack {
            
            Color(showDetail ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("3")
                    .padding()
                Spacer()
                HStack(alignment: .top, spacing: 40) {
                    
                    Button(action: {
                        self.showTop.toggle()
                    }) {
                        VStack {
                            Text("Hot")
                                .foregroundColor(showTop ? Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.4274509804, green: 0.4470588235, blue: 0.4705882353, alpha: 1)))
                            
                            
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 30, height: 4)
                                .offset(y: -10)
                                .foregroundColor(showTop ? Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.4274509804, green: 0.4470588235, blue: 0.4705882353, alpha: 1)))
                            
                            
                            
                        }
                    }
                    Button(action: {
                        self.showingDetail1.toggle()
                    }) {
                        Text("Favorites")
                    }.sheet(isPresented: $showingDetail1){
                        API()
                    }
                    
                    Button(action: {
                        self.showingDetail2.toggle()
                    }) {
                        Text("Basket")
                    }.sheet(isPresented: $showingDetail2){
                        MapKit()
                    }
                    
                }.foregroundColor(Color(#colorLiteral(red: 0.4274509804, green: 0.4470588235, blue: 0.4705882353, alpha: 1)))
                    .onAppear {
                        self.showTop = true
                    }
                
                Spacer()
                
                ZStack {
                    Spacer()
                        .frame(width: 275.0, height: 368.0)
                        .background(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)))
                        .cornerRadius(42)
                        .shadow(radius: 35, y: 20)
                        .rotationEffect(.degrees(8))
                        .offset(x: 30, y: -30)
                        .padding(.top, 50)
                    
                    Spacer()
                        .frame(width: 275.0, height: 368.0)
                        .background(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)))
                        .cornerRadius(42)
                        .shadow(radius: 5)
                        .rotationEffect(.degrees(-8))
                        .offset(x: -30, y: -30)
                        .padding(.top, 50)
                    
                    ZStack {
                        
                        Spacer()
                            .frame(width: 275.0, height: 368.0)
                            .background(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)))
                            .cornerRadius(42)
                            .shadow(radius: 5)
                        
                        VStack {
                            if show1 == true {
                                Image("7")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 265.0, height: 368.0)
                                    .offset(y: 40)
                                    .overlay(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0))
                                Text("Nike Air Zoom Pegasus 37")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                    .bold()
                                    .offset(y: -100)
                            } else if show2 == true {
                                Image("8")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 265.0, height: 368.0)
                                    .overlay(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0))
                                Text("Nike Air Max Plus")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                    .bold()
                                    .offset(y: -100)
                            }
                            else if show3 == true {
                                Image("7")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .offset(y: 40)
                                    .frame(width: 265.0, height: 368.0)
                                    .overlay(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0))
                                Text("Nike Air Max Hybrid")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                    .bold()
                                    .offset(y: -100)
                            }
                            else if show4 == true {
                                Image("8")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 265.0, height: 368.0)
                                    .overlay(showDetail ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).opacity(0.2) : Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0))
                                Text("Nike Air Max Plus")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                    .bold()
                                    .offset(y: -100)
                            }
                        }
                    }
                }
                
                
                Spacer()
                
                
                Button(action: {
                    self.showDetail.toggle()
                }) {
                    Text("Buy Now")
                        .foregroundColor(.white)
                        .frame(width: 169, height: 42)
                        .background(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)))
                        .cornerRadius(20)
                        .shadow(color: Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)).opacity(0.6), radius: 10, y: 10)
                        .padding()
                    
                }
                
                HStack {
                    Text("Favorites")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 35) {
                        Button(action: {
                            self.show1.toggle()
                            self.show2 = false
                            self.show3 = false
                            self.show4 = false
                        }) {
                            Image("4")
                                .renderingMode(.original)
                                .overlay(show1 ? RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)), lineWidth: 3) : nil)
                        }
                        
                        
                        Button(action: {
                            self.show2.toggle()
                            self.show1 = false
                            self.show3 = false
                            self.show4 = false
                            
                        }) {
                            Image("6")
                                .renderingMode(.original)
                                .overlay(show2 ? RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)), lineWidth: 3) : nil)
                        }
                        
                        
                        Button(action: {
                            self.show3.toggle()
                            self.show1 = false
                            self.show2 = false
                            self.show4 = false
                        }) {
                            Image("1")
                                .renderingMode(.original)
                                .overlay(show3 ? RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)), lineWidth: 3) : nil)
                        }
                        
                        
                        
                        Button(action: {
                            self.show4.toggle()
                            self.show1 = false
                            self.show2 = false
                            self.show3 = false
                        }) {
                            Image("1")
                                .renderingMode(.original)
                                .overlay(show4 ? RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)), lineWidth: 3) : nil)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    
                }
                
            }
            
            DetailView(showDetail: $showDetail)
                .offset(y: showDetail ? 0 : 600)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        }
    }
}


struct DetailView: View {
    @Binding var showDetail: Bool

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Man's Shoe")
                                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                            Text("Nike Airmax Plus")
                                .bold()
                        }
                        Spacer()
                        Text("300$")
                            .bold()
                            .font(.system(size: 24))
                    }
                    .padding(.horizontal)
                    Text("Select Size")
                        .font(.caption)
                        .padding(.horizontal)
                    VStack(alignment: .center, spacing: 8.0) {
                        HStack(alignment: .center, spacing: 8.0) {
                            Text("UK 5.5")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                            Text("UK 6 (EU 39)")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                            Text("UK 6 (EU 40)")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                        }

                        HStack(alignment: .center, spacing: 10.0) {
                            Text("UK 6.5")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                            Text("UK 7")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                            Text("UK 7.5")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                                .opacity(0.2)
                        }


                        HStack(alignment: .center, spacing: 10.0) {
                            Text("UK 5.5")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                            Text("UK 6 (EU 39)")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                                .opacity(0.2)
                            Text("UK 6 (EU 40)")
                                .font(.footnote)
                                .frame(width: 102, height: 41)
                                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)))
                                .cornerRadius(5)
                        }

                    }
                    .padding(.leading, 30)

                    Button(action: {
                        //
                    }) {
                        Text("Add to bag")
                            .foregroundColor(.white)
                            .frame(width: 321, height: 44)
                            .background(Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)))
                            .cornerRadius(20)
                            .shadow(color: Color(#colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)).opacity(0.6), radius: 10, y: 10)
                            .padding(.leading, 30)

                    }

                }
                .padding(.top, 10)

                .frame(width: 383, height: 400)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)

            }



            Image(systemName: "xmark")
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
                .offset(x: 160, y: 45)
                .onTapGesture {
                    self.showDetail = false
            }

        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
