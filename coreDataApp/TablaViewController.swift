//
//  TablaViewController.swift
//  coreDataApp
//
//  Created by Jonh Parra on 04/11/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import CoreData

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tabla: UITableView!
    
    var alumnos = [Alumnos]()
    
    func conexion () ->NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        esto sería con código
        tabla.delegate = self
        tabla.dataSource = self
        mostrarDatos()
        // Do any additional setup after loading the view.
    }
    
    
//    se nota el efecto de cambio
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tabla.reloadData()
//    }
//
    
//    no se ve el efecto del cambio
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabla.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alumnos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let alumno = alumnos[indexPath.row]
        celda.textLabel?.text = alumno.nombre
        celda.detailTextLabel?.text = alumno.direccion
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let alumno = alumnos[indexPath.row]
        if editingStyle == .delete{
            contexto.delete(alumno)
            do {
                try contexto.save()
            } catch let error as NSError {
            print("Hubo un error al eliminar el registro \(error.localizedDescription)")
            }
            
        }
        
        mostrarDatos()
        tabla.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            if let id = tabla.indexPathForSelectedRow{
                let fila = alumnos[id.row]
                let destino = segue.destination as! EditarViewController
                destino.alumnosEdit = fila
            }
        }
    }

    func mostrarDatos () {
        let contexto = conexion()
        
        let fetchRequest: NSFetchRequest<Alumnos> = Alumnos.fetchRequest()
        
        do {
            alumnos = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("Hubo un error al cargar los datos \(error.localizedDescription)")
        }
    }
    
}
