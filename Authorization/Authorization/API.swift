//
//  API.swift
//  Authorization
//
//  Created by Tima on 20.12.2022.
//

import SwiftUI

struct API: View {
    
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationView{
            List(posts){ post in
                VStack{
                    Text(post.title)
                        .fontWeight(.bold)
                    Text(post.body)

                }
            }.onAppear(){
                Api().getPost{ (posts) in
                    self.posts = posts
                    
                }
            }.navigationBarTitle("Posts")
        }
    }
}


struct Post: Codable,Identifiable{
    var id: Int
    var title: String
    var body: String
}


class Api{
    func getPost(completion: @escaping ([Post]) -> ()){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        else{return}
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        .resume()
    }
}

struct API_Previews: PreviewProvider {
    static var previews: some View {
        API()
    }
}
