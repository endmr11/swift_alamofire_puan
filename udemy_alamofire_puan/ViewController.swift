//
//  ViewController.swift
//  udemy_alamofire_puan
//
//  Created by Eren Demir on 14.05.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var notTableView: UITableView!
    var notlarListesi = [Not]()
    override func viewDidLoad() {
        super.viewDidLoad()
        notTableView.delegate = self
        notTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tumNotlar()
    }
    
    func ortalamaHesapla() {
        var toplam = 0
        for n in notlarListesi {
            toplam = toplam + (Int(n.not1!)! + Int(n.not2!)!)/2
        }
        if notlarListesi.count != 0 {
            navigationItem.prompt = "Ortalama: \(toplam/notlarListesi.count)"
        }else {
            navigationItem.prompt = "Ortalama: YOK"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            print("toDetay")
            if let index = sender as? Int{
                let gidilecekVC = segue.destination as! NotDetayViewController
                gidilecekVC.gelenNot = notlarListesi[index]
            }
        }
    }
    
    func tumNotlar() {
            Alamofire.request("http://kasimadalan.pe.hu/notlar/tum_notlar.php",method: .get).responseJSON(completionHandler: {
                response in
                if let data = response.data {
                    do {
                        let cevap = try JSONDecoder().decode(Notlar.self, from: data)
                        if let gelenNotListesi = cevap.notlar {
                            self.notlarListesi = gelenNotListesi
                        }
                        
                        DispatchQueue.main.async {
                            self.notTableView.reloadData()
                            self.ortalamaHesapla()
                        }

                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
        }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notlarListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let not = notlarListesi[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "notHucre", for: indexPath) as! NotHucreTableViewCell
        cell.dersLabel.text = not.ders_adi
        cell.vizeLabel.text = "\(not.not1!)"
        cell.finalLabel.text = "\(not.not2!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }
}
