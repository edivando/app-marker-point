//
//  FormPlaceViewController.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/12/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import UIKit

class FormPlaceViewController: UIViewController, UITextFieldDelegate {
    
    private let data = Data.shared

    @IBOutlet var nome: UITextField!
    @IBOutlet var nomeContato: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var bairro: UITextField!
    @IBOutlet var cidade: UITextField!
    @IBOutlet var cep: UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var email: UITextField!
    
    @IBOutlet var pontos: UIButton!
    
    private var scroll: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xFFCA06)  //(red: 255, green: 202, blue: 6)
//        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
//        if let img = UIImage(named: "ecreative"){
//            let imgView = UIImageView(image: img.alpha(0.3))
//            imgView.center = view.center
//            self.view.insertSubview(imgView, atIndex: 0) //addSubview(imgView)
//        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FormPlaceViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FormPlaceViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nome.text = data.place?.nome
        nomeContato.text = data.place?.contato
        endereco.text = data.place?.endereco
        bairro.text = data.place?.bairro
        cidade.text = data.place?.cidade
        cep.text = data.place?.cep
        telefone.text = data.place?.telefone
        email.text = data.place?.email
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let nome = data.place?.nome where !nome.isEmpty{
            navigationItem.title = nome
            pontos.hidden = false
            pontos.setTitle("\(data.pointsCountAll()) pontos", forState: .Normal)
        }else{
            pontos.setTitle("Novo", forState: .Normal)
            pontos.hidden = true
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = scroll
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func savePlace(sender: AnyObject) {
        view.endEditing(true)
        if let place = data.place, let nome = nome.text where !nome.isEmpty {
            place.nome = nome
            place.contato = nomeContato.text!
            place.endereco = endereco.text!
            place.bairro = bairro.text!
            place.cidade = cidade.text!
            place.cep = cep.text!
            place.telefone = telefone.text!
            place.email = email.text!
            data.savePlace()
            view.makeToast(message: "Salvo!")
            pontos.hidden = false
            navigationItem.title = nome
        }else{
            view.makeToast(message: "Nome esta vazio!")
        }
    }
    
    @IBAction func showPontos(sender: AnyObject) {
        performSegueWithIdentifier("seguePlacePoints", sender: nil)
    }
    
    
//MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        scroll = 0
        if textField.isEqual(nome) {
            nomeContato.becomeFirstResponder()
        }else if textField.isEqual(nomeContato) {
            endereco.becomeFirstResponder()
        }else if textField.isEqual(endereco) {
            bairro.becomeFirstResponder()
        }else if textField.isEqual(bairro) {
            scroll = -20
            cidade.becomeFirstResponder()
        }else if textField.isEqual(cidade) {
            scroll = -70
            cep.becomeFirstResponder()
        }else if textField.isEqual(cep) {
            scroll = -120
            telefone.becomeFirstResponder()
        }else if textField.isEqual(telefone) {
            scroll = -170
            email.becomeFirstResponder()
        }else if textField.isEqual(email) {
            scroll = -220
            textField.resignFirstResponder()
            if let place = data.place, let nome = nome.text where !nome.isEmpty {
                place.nome = nome
                place.contato = nomeContato.text!
                place.endereco = endereco.text!
                place.bairro = bairro.text!
                place.cidade = cidade.text!
                place.cep = cep.text!
                place.telefone = telefone.text!
                place.email = email.text!
                data.savePlace()
                pontos.hidden = false
                navigationItem.title = nome
            }
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}
