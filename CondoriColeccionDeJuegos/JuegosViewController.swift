//
//  JuegosViewController.swift
//  CondoriColeccionDeJuegos
//
//  Created by Mac 05 on 17/05/23.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var JuegoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var eliminarBoton: UIButton!
    
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if juego != nil {
           JuegoImageView.image = UIImage(data: (juego!.imagen!) as Data)
           tituloTextField.text = juego!.titulo
           agregarActualizarBoton.setTitle("Actualizar", for: .normal)
       }else{
           eliminarBoton.isHidden = true
       }
    }
    
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil{
                    juego!.titulo! = tituloTextField.text!
                    juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
                }else{
                    let context = (UIApplication.shared.delegate as!
                                   AppDelegate).persistentContainer.viewContext
                    let juego = Juego(context: context)
                    juego.titulo = tituloTextField.text
                    juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
                }
                
                (UIApplication.shared.delegate  as! AppDelegate).saveContext()
                navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(juego!)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSelecionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSelecionada
        imagePicker.dismiss(animated: true,completion: nil)
    }
    
}
