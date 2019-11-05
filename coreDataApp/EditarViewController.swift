//
//  EditarViewController.swift
//  coreDataApp
//
//  Created by Jonh Parra on 04/11/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import CoreData


class EditarViewController: UIViewController {
    
    func conexion () ->NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    
    var alumnosEdit : Alumnos!
    @IBOutlet weak var nombreEdit: UITextField!
    @IBOutlet weak var edadEdit: UITextField!
    @IBOutlet weak var dirEdit: UITextField!
    @IBOutlet weak var btnSwitchEdit: UISwitch!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nombreEdit.text = alumnosEdit.nombre
        edadEdit.text = "\(alumnosEdit.edad)"
        dirEdit.text = alumnosEdit.direccion
        
        if  alumnosEdit.activo {
            btnSwitchEdit.isOn = true
        } else {
            btnSwitchEdit.isOn = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func editarData(_ sender: UIButton) {
        let contexto = conexion()
        guard let age = Int16(edadEdit.text!) else { return }
        alumnosEdit.setValue(nombreEdit.text, forKey: "nombre")
        alumnosEdit.setValue(age, forKey: "edad")
        alumnosEdit.setValue(dirEdit.text, forKey: "direccion")
        alumnosEdit.setValue(btnSwitchEdit.isOn, forKey: "activo")
        
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
        print("Algo ha pasado, no se pudo editar \(error.localizedDescription)")           }
    }
    
    
}
