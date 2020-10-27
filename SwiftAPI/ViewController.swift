//
//  ViewController.swift
//  SwiftAPI
//
//  Created by Bill Martensson on 2020-10-27.
//

import UIKit

class PeopleList : Codable
{
    var names = [Person]()
}

class Person : Codable
{
    var firstname : String = ""
    var surname : String = ""
    var gender : String = ""
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //exampleJsonDecode()
        //loadFromServer()
        
        loadFromServerURLSESSION()
    }
    
    func loadFromServerURLSESSION()
    {
        guard let url = URL(string: "https://api.namnapi.se/v2/names.json?gender=both&type=both&limit=3") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        var thesession = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let thestring = String(decoding: data!, as: UTF8.self)
            
            self.gotTextFromServer(serverstring: thestring)
        }
        thesession.resume()
    }
    
    
    func loadFromServer()
    {
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            var contents = ""
            if let url = URL(string: "https://api.namnapi.se/v2/names.json?gender=both&type=both&limit=3") {
                do {
                    contents = try String(contentsOf: url)
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.gotTextFromServer(serverstring: contents)
            }
        }
    }
    
    func gotTextFromServer(serverstring : String)
    {
        print(serverstring)
        
        let jsondata = Data(serverstring.utf8)
        
        let decoder = JSONDecoder()

        do {
            let people = try decoder.decode(PeopleList.self, from: jsondata)
            gotPeople(people: people.names)
        } catch {
            print("Failed to decode JSON")
        }
    }

    func gotPeople(people : [Person])
    {
        for someone in people
        {
            print(someone.firstname + " " + someone.surname)
        }
    }
    
    
    func exampleJsonDecode()
    {
        let json = """
        [
            {
                "name": "Paul",
                "age": 38
            },
            {
                "name": "Andrew",
                "age": 40
            }
        ]
        """

        let data = Data(json.utf8)
        
        let decoder = JSONDecoder()

        do {
            let decoded = try decoder.decode([User].self, from: data)
            print(decoded[0].name)
            print("\(decoded[1].name) är \(decoded[1].age) år gammal")
        } catch {
            print("Failed to decode JSON")
        }
    }
    
    
}

struct User: Codable {
    var name: String
    var age: Int
}
