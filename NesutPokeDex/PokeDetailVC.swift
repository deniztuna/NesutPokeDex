//
//  PokeDetailVC.swift
//  NesutPokeDex
//
//  Created by Deniz Tuna on 13/04/2017.
//  Copyright © 2017 Deniz Tuna. All rights reserved.
//

import UIKit
import Alamofire

class PokeDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var pokeNameLbl: UILabel!
    @IBOutlet weak var mainPokeImg: UIImageView!
    @IBOutlet weak var pokeDetailLbl: UILabel!
    @IBOutlet weak var pokeTypeLbl: UILabel!
    @IBOutlet weak var pokeDefenseLbl: UILabel!
    @IBOutlet weak var pokeHeightLbl: UILabel!
    @IBOutlet weak var pokeWeightLbl: UILabel!
    @IBOutlet weak var pokeBaseAttackLbl: UILabel!
    
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var currentImg: UIImageView!
    @IBOutlet weak var evolutionImg: UIImageView!
    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeNameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokemonId)")
        mainPokeImg.image = img
        evolutionImg.isHidden = true
        currentImg.image = img
        
        // Do any additional setup after loading the view.
        pokemon.downloadPokeDetails {
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        pokedexIDLbl.text = "\(pokemon.pokemonId)"
        pokeDefenseLbl.text = pokemon.defense
        pokeBaseAttackLbl.text = pokemon.baseAttack
        pokeWeightLbl.text = pokemon.weight
        pokeHeightLbl.text = pokemon.height
        pokeTypeLbl.text = pokemon.type
        nextEvoLbl.text = pokemon.nextEvoText
        if pokemon.nextEvoImgId != "-1" {
            evolutionImg.image = UIImage(named: pokemon.nextEvoImgId)
            evolutionImg.isHidden = false
        } else {
            evolutionImg.isHidden = true
        }
        pokeDetailLbl.text = pokemon.pokeDesc
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
