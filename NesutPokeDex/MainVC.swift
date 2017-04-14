//
//  ViewController.swift
//  NesutPokeDex
//
//  Created by Deniz Tuna on 10/04/2017.
//  Copyright © 2017 Deniz Tuna. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    var pokemonArr = [Pokemon]()
    var filteredPokemonArr = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearchEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokemonId: pokeId)
                pokemonArr.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let poke: Pokemon!
            if isSearchEnabled {
                poke = filteredPokemonArr[indexPath.row]
                cell.updateCell(poke: poke)
            } else {
                poke = pokemonArr[indexPath.row]
                cell.updateCell(poke: poke)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke: Pokemon!
        
        if isSearchEnabled {
            poke = filteredPokemonArr[indexPath.row]
        } else {
            poke = pokemonArr[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchEnabled {
            return filteredPokemonArr.count
        }
        return pokemonArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

    @IBAction func arrangeSoundButton(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearchEnabled = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            isSearchEnabled = true
            let lower = searchText.lowercased()
            filteredPokemonArr = pokemonArr.filter({$0.name.range(of: lower) != nil})
            print("\(filteredPokemonArr.count)")
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailVC" {
            if let detailsVC = segue.destination as? PokeDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke;
                }
            }
        }
    }
}

