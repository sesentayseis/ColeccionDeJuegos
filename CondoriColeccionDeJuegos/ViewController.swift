//
//  ViewController.swift
//  CondoriColeccionDeJuegos
//
//  Created by Mac 05 on 17/05/23.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var juegos : [Juego] = []

    override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsSelectionDuringEditing = true
            
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            setEditing(false, animated: true)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                try juegos = context.fetch(Juego.fetchRequest())
                juegos.sort { ($0.order ?? 0) < ($1.order ?? 0) }
                tableView.reloadData()
            } catch {
                print("Error fetching juegos: \(error)")
            }
        }
        
        // MARK: - Table View Data Source
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return juegos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            let juego = juegos[indexPath.row]
            cell.textLabel?.text = juego.titulo
            cell.imageView?.image = UIImage(data: juego.imagen!)
            return cell
        }
        
        // MARK: - Table View Delegate
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let juego = juegos[indexPath.row]
            
            if isEditing {
                // Handle reordering of cells
                let alert = UIAlertController(title: "Reorder", message: "Move the game to a new position", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Move", style: .default, handler: { _ in
                    let destinationIndexPath = IndexPath(row: indexPath.row, section: 0)
                    self.tableView.moveRow(at: indexPath, to: destinationIndexPath)
                    self.updateJuegoOrder()
                }))
                
                present(alert, animated: true, completion: nil)
            } else {
                // Handle normal selection
                performSegue(withIdentifier: "juegoSegue", sender: juego)
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "juegoSegue" {
                if let juego = sender as? Juego {
                    let siguienteVC = segue.destination as! JuegosViewController
                    siguienteVC.juego = juego
                }
            }
        }
        
        // MARK: - Table View Editing
        
        override func setEditing(_ editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: animated)
            
            tableView.setEditing(editing, animated: animated)
            if editing {
                self.editButtonItem.title = "Hecho"
                self.tableView.isEditing = true
            } else {
                self.editButtonItem.title = "Editar"
                self.tableView.isEditing = false
                
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    // MARK: - editingStyle el botón de eliminar 

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let juego = juegos[indexPath.row]
                
                context.delete(juego)
                juegos.remove(at: indexPath.row)
                
                do {
                    try context.save()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    updateJuegoOrder()
                } catch {
                    print("Error deleting game: \(error)")
                }
            }
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let movedJuego = juegos.remove(at: sourceIndexPath.row)
            juegos.insert(movedJuego, at: destinationIndexPath.row)
            updateJuegoOrder()
        }
        
        func updateJuegoOrder() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            for (index, juego) in juegos.enumerated() {
                juego.order = Int16(index)
            }
            
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                print("Error saving context: \(error)")
            }
        }
}

