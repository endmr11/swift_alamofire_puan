

import UIKit
import Alamofire

class NotEkleViewController: UIViewController {
    @IBOutlet weak var dersTextfield: UITextField!
    @IBOutlet weak var vizeTextfield: UITextField!
    @IBOutlet weak var finalTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnEkle(_ sender: Any) {
        if let d = dersTextfield.text, let v = vizeTextfield.text, let f = finalTextfield.text {
            if let n1 = Int(v), let n2 = Int(f) {
                notEkle(ders_adi: d, not1: n1, not2: n2)
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    func notEkle(ders_adi:String,not1:Int,not2:Int) {
        let parametreler:Parameters = ["ders_adi":ders_adi,"not1":not1,"not2":not2]
        Alamofire.request("http://kasimadalan.pe.hu/notlar/insert_not.php",method: .post,parameters: parametreler).responseJSON(completionHandler: {
            response in
            if let data = response.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String:Any] {
                        print(json)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }
}
