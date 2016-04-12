//
//  PointViewController.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/12/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import UIKit
import MessageUI

class PointViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate  {
    
    private let data = Data.shared
    private var auxInput: UITextField?
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnArea: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xFFCA06)   //UIColor(red: 255, green: 202, blue: 6)
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        setPointsLabel()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func reflesh(){
        setPointsLabel()
        tableView.reloadData()
    }
    
    private func setPointsLabel(){
        if let area = data.area {
            btnArea.setTitle("\(area.nome): \(data.pointsCount()) pts", forState: .Normal)
        }else{
            createArea()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.points.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let point = data.points[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(point.porta ? "cellPorta" : "cellPoint", forIndexPath: indexPath) as? PointCell{
            if !point.porta{
                cell.pointView.roundCorner()  //.backgroundColor = UIColor(netHex: 0x00A877)
            }
            cell.label.text = "\(point.nome)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let point = self.data.points[indexPath.row]
        print("[\(point.latitude) | \(point.longitude)]")
        let alert = UIAlertController(title: point.nome, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Renomear", style: .Default, handler: { (action) -> Void in
            
            let alert = UIAlertController(title: "Renomear", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Salvar", style: .Cancel, handler: { (action) -> Void in
                self.data.setPoint(point)
                if let nome = self.auxInput?.text{
                    self.data.point?.nome = nome
                }
                self.data.savePoint()
                self.reflesh()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: nil))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.text = point.nome
                textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                self.auxInput = textField
            })
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Remover", style: .Default, handler: { (action) -> Void in
            self.data.remove(point)
            self.reflesh()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addPonto(sender: AnyObject) {
        addPoint(true, title: "Adicionar Ponto",message: "Nome que descreva o ponto!")
    }

    @IBAction func addPorta(sender: AnyObject) {
        addPoint(false, title: "Adicionar Porta",message: "Nome que descreva o porta!")
    }
    
    @IBAction func save(sender: AnyObject) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        if let place = data.place, user = data.user {
            MailApi.sendEmailNewBudget(place, user: user, totalPoints: data.pointsCountAll())
            mailComposerVC.setSubject("Formalizar Orçamento")
            mailComposerVC.setMessageBody(MailApi.templateNewBudget(place, user: user, totalPoints: data.pointsCountAll()), isHTML: true)
        }
        
        let alert = UIAlertController(title: "Deseja enviar dados para formalizar orçamento?", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .Default, handler: { (action) -> Void in
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposerVC, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Não pode enviar email", message: "Favor verificar as configurações de email e tente novamente.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    private func addPoint(point: Bool, title: String, message: String){
        if data.area == nil{
            createArea()
        }else{
            data.newPoint()
            data.point?.porta = !point
            data.point?.nome = "\(point ? "ponto" : "porta")\(data.points.count)"
            data.savePoint()
            reflesh()
            let path = NSIndexPath(forRow: data.points.count-1, inSection: 0)
            tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popToRootViewControllerAnimated(true)
        
        result.rawValue
    }
    
    
    @IBAction func changeArea(sender: AnyObject) {
        let alert = UIAlertController(title: "Áreas", message: "Lista das Áreas deste estabelecimento.", preferredStyle: .ActionSheet)
        for area in data.areas{
            alert.addAction(UIAlertAction(title: area.nome, style: .Default, handler: { (action) -> Void in
                self.data.setArea(area)
                
                self.setPointsLabel()
                self.tableView.reloadData()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Criar Nova Área", style: .Default, handler: { (action) -> Void in
            self.createArea()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createArea(){
        let alertArea = UIAlertController(title: "Criar Nova Área", message: "Informe o nome da nova área.", preferredStyle: .Alert)
        alertArea.addAction(UIAlertAction(title: "Salvar", style: .Default, handler: { (action) -> Void in
            self.data.newArea()
            if let nome = self.auxInput?.text where !nome.isEmpty{
                self.data.area?.nome = nome
            }else{
                self.data.area?.nome = "Area \(self.data.areas.count)"
            }
            self.data.saveArea()
            self.setPointsLabel()
            self.tableView.reloadData()
        }))
        alertArea.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: {(action) -> Void in}))
        alertArea.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Nome da Área"
            textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
            self.auxInput = textField
        })
        self.presentViewController(alertArea, animated: true, completion: nil)
    }
    
}