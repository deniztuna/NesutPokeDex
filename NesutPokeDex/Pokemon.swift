//
//  Pokemon.swift
//  NesutPokeDex
//
//  Created by Deniz Tuna on 10/04/2017.
//  Copyright © 2017 Deniz Tuna. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokemonId: Int!
    
    var name: String {
        return _name
    }
    
    var pokemonId: Int {
        return _pokemonId
    }
    
    init(name: String, pokemonId: Int) {
        self._name = name
        self._pokemonId = pokemonId
    }
}
