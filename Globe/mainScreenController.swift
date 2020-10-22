//
//  mainScreenController.swift
//  Globe
//
//  Created by Didin Firmansyah on 12/04/20.
//  Copyright © 2020 Didin Firmansyah. All rights reserved.
//

import UIKit
import AVFoundation

class mainScreenController: UIViewController {
    var player: AVAudioPlayer?

    @IBOutlet weak var soundButton: UIButton!
    
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "Music", withExtension: "m4a") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
        } catch let Error {
            print(Error.localizedDescription)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playSound()
        soundButton.setTitle("Sound : ON", for: .normal)
        soundButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        if(!sender.isSelected){
            player?.stop()
            sender.setTitle("Sound : OFF", for: .normal)
        }else{
            player?.play()
            sender.setTitle("Sound : ON", for: .normal)
        }
        sender.isSelected = !sender.isSelected
    }
    
}
