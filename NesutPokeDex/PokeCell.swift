//
//  PokeCell.swift
//  NesutPokeDex
//
//  Created by Deniz Tuna on 10/04/2017.
//  Copyright © 2017 Deniz Tuna. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func updateCell(poke: Pokemon) {
        self.pokemon = poke
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokemonId)")
        self.nameLabel.text = self.pokemon.name.capitalized
    }
    
}
