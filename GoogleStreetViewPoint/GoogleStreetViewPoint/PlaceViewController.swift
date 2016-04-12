//
//  PlaceViewController.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/12/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import UIKit

class PlaceViewController: UITableViewController {
    
    private let data = Data.shared
    
    private var textName: UITextField?
    private var textEmail: UITextField?
    private var textCode: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xFFCA06)  //(red: 255, green: 202, blue: 6)  //FFCA06  //0x319177
//        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        if let img = UIImage(named: "ecreative"){
            let imgView = UIImageView(image: img.alpha(0.3))
            imgView.center = self.view.center
            self.view.addSubview(imgView)
//            self.view.backgroundColor = UIColor(patternImage: img.alpha(0.1))
        }
        
        if let user = data.user where user.nome != "" && user.email != ""{
            
        }else{
            let alert = UIAlertController(title: "Seus dados", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Salvar", style: .Default, handler: { (action) -> Void in
                if let nome = self.textName?.text where !nome.isEmpty{
                    if let email = self.textEmail?.text where !email.isEmpty && email.isEmail(){
                        if let c = self.textCode?.text where c == Code.getCode(){
                            self.data.user?.nome = nome
                            self.data.user?.email = email
                            self.data.saveUser()
                            MailApi.sendEmailNewUser(nome, email: email)
                            
                            let alertOk = UIAlertController(title: "Acesso liberado", message: nil, preferredStyle: .Alert)
                            alertOk.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in }))
                            self.presentViewController(alertOk, animated: true, completion: nil)
                            
                            return;
                        }else{
                            let alertOk = UIAlertController(title: "Código inválido!", message: nil, preferredStyle: .Alert)
                            alertOk.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                                self.textCode?.becomeFirstResponder()
                                self.presentViewController(alert, animated: true, completion: nil)
                            }))
                            self.presentViewController(alertOk, animated: true, completion: nil)
                        }
                    }else{
                        let alertOk = UIAlertController(title: "Email inválido", message: "Você deve digitar um email válido! \nEx. email@dominio.com", preferredStyle: .Alert)
                        alertOk.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                            self.textEmail?.text = ""
                            self.textEmail?.becomeFirstResponder()
                            self.presentViewController(alert, animated: true, completion: nil)
                        }))
                        self.presentViewController(alertOk, animated: true, completion: nil)
                    }
                }
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                textField.placeholder = "Nome da Empresa"
                self.textName = textField
            })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.autocapitalizationType = UITextAutocapitalizationType.None
                textField.keyboardType = UIKeyboardType.EmailAddress
                textField.placeholder = "Seu Email: email@dominio.com"
                self.textEmail = textField
            })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
                textField.placeholder = "Código"
                self.textCode = textField
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        data.findAllPlaces()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
        if let place = data.place{
            if place.nome.isEmpty{
                data.remove(place)
            }
        }
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let place = data.places[indexPath.row]
        cell.textLabel?.text = place.nome
        cell.detailTextLabel?.text = "\(place.endereco) \(place.bairro) \(place.cidade)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        data.setPlace(data.places[indexPath.row])
        performSegueWithIdentifier("segueFormPlace", sender: self)
    }
    
    @IBAction func addPlace(sender: AnyObject) {
        data.newPlace()
        performSegueWithIdentifier("segueFormPlace", sender: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            data.remove(data.places[indexPath.row])
            refresh()
        default:
            return
        }
    }
    
}
