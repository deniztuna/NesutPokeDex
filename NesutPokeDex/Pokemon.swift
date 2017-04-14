//
//  Pokemon.swift
//  NesutPokeDex
//
//  Created by Deniz Tuna on 10/04/2017.
//  Copyright © 2017 Deniz Tuna. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokemonId: Int!
    private var _pokeDesc: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvoText: String!
    private var _nextEvoImgId: String!
    
    private var _downloadURL: String!
    
    var nextEvoImgId: String {
        if _nextEvoImgId == nil {
            _nextEvoImgId = "1"
        }
        return _nextEvoImgId
    }
    
    var pokeDesc: String {
        if _pokeDesc == nil {
            _pokeDesc = ""
        }
        return _pokeDesc
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokemonId: Int {
        return _pokemonId
    }
    
    init(name: String, pokemonId: Int) {
        self._name = name
        self._pokemonId = pokemonId
        
        self._downloadURL = "\(BASE_URL)\(POKEMON_API)\(self.pokemonId)"
    }
    
    func downloadPokeDetails(complete: @escaping DownloadComplete) {
        let downloadURL = URL(string: self._downloadURL)
        Alamofire.request(downloadURL!).responseJSON { response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    if let name = types[0]["name"] as? String {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for i in 1..<types.count {
                            let type = types[i]["name"] as? String
                            self._type! += "/" + type!.capitalized
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        if !to.contains("mega") {
                            if let level = evolutions[0]["level"] as? Int {
                                self._nextEvoText = "Next Evolution: " + to.capitalized + " LVL \(level)"
                            }
                            if let resUrl = evolutions[0]["resource_uri"] as? String {
                                let arr = resUrl.components(separatedBy: "/")
                                print(arr)
                                self._nextEvoImgId = arr[arr.count-2]
                            }
                        } else {
                            self._nextEvoText = "Maximum evolution!"
                            self._nextEvoImgId = "-1"
                        }
                    }
                } else {
                    self._nextEvoText = "There is no information!"
                    self._nextEvoImgId = "-1"
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>], descriptions.count > 0 {
                    if let url = descriptions[0]["resource_uri"] as? String {
                        let descUrl = "\(BASE_URL)\(url)"
                        print(descUrl)
                        Alamofire.request(descUrl).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let lastDescription = descDict["description"] as? String {
                                    print(lastDescription)
                                    self._pokeDesc = lastDescription
                                }
                            }
                            complete()
                        })
                    }
                } else {
                    self._pokeDesc = ""
                }
            }
            
            complete()
        }
    }
}
