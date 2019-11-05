//
//  ViewController.swift
//  coreDataApp
//
//  Created by Jonh Parra on 04/11/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var edadText: UITextField!
    @IBOutlet weak var dirText: UITextField!
    @IBOutlet weak var switchActivo: UISwitch!
    
    func conexion () ->NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func guardar(_ sender: UIButton) {
        let contexto = conexion()
        let entidadAlumnos = NSEntityDescription.insertNewObject(forEntityName: "Alumnos", into: contexto) as! Alumnos
        entidadAlumnos.nombre = nombreText.text
        guard let age = Int16(edadText.text!) else { return }
        entidadAlumnos.edad = age
        entidadAlumnos.direccion = dirText.text
        entidadAlumnos.activo = switchActivo.isOn
        
        do {
            try contexto.save()
            print("Éxito al guardar")
            nombreText.text = ""
            edadText.text = ""
            dirText.text = ""
            switchActivo.isOn = false
        } catch let error as NSError {
            print("Algo ha pasado \(error.localizedDescription)")
        }
    }
    
    @IBAction func mostrarData(_ sender: UIButton) {
        let contexto = conexion()
        
        let fetchRequest: NSFetchRequest<Alumnos> = Alumnos.fetchRequest()
        
        do {
            let resultados = try contexto.fetch(fetchRequest)
            print("numero de registros: \(resultados.count) ")
            for res in resultados as [NSManagedObject] {
                let nombre = res.value(forKey: "nombre")
                let edad = res.value(forKey: "edad")
                let direccion = res.value(forKey: "direccion")
                let activo = res.value(forKey: "activo")
                print("Nombre: \(nombre ?? "Usuario") Edad: \(edad ?? "No se ingreso edad") Dirección: \(direccion ?? "No se ingreso la direccion") Activo: \(activo ?? "Sin valor")")
            }
            
            
        }  catch let error as NSError {
            print("Algo ha pasado, no se pudo mostrar \(error.localizedDescription)")
            
        }
        
    }
    
    
    @IBAction func borrarData(_ sender: UIButton) {
        let contexto = conexion()
        
        let fetchRequest =  NSFetchRequest <NSFetchRequestResult>(entityName: "Alumnos")
        let borrar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try contexto.execute(borrar)
            print("Registros borrados")
        } catch let error as NSError {
            print("Algo ha pasado, no se pudo borrar \(error.localizedDescription)")        }
        
    }
    

}

