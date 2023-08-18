//
//  HTTPManager.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import Foundation
import UIKit

final class HTTPManager{
    static let shared = HTTPManager()
    private init(){}
    
    enum HTTPError: Error{
        case invalidUrl
        case invalidResponse(Data?,URLResponse?)
    }
    
    func getData(urlString: String,completion: @escaping (Result<Data, Error>) -> Void){
        
        guard let url = URL(string: urlString) else{
            completion(.failure(HTTPError.invalidUrl))
            return
        }
        LoaderAnimation.shared.showLoader()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                LoaderAnimation.shared.hideLoader()
                guard error == nil else{
                    completion(.failure(error!))
                    return
                }
                
                guard let data = data, let _ = response as? HTTPURLResponse else{
                    completion(.failure(HTTPError.invalidResponse(data, response)))
                    return
                }
                
                completion(.success(data))
            }
        }
        task.resume()
        
    }
    
    func uploadImage(image: UIImage, param: [String: Any], completion: @escaping (Error?) -> Void) {

        let urlString = "https://app.getswipe.in/api/public/add"
        
        guard let url = URL(string: urlString) else {
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create a boundary for multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append(imageData)
        }
        body.append("\r\n".data(using: .utf8)!)
        
        // Append other parameters
        for (key, value) in param {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        LoaderAnimation.shared.showLoader()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                LoaderAnimation.shared.hideLoader()
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
        task.resume()
    }

    func showAlert(owner:UIViewController,title:String = "",message:String,buttonAction: (()->Void)?,buttonTitle:String = "OK"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let buttonAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (action) in
            buttonAction?()
        }
        alert.addAction(buttonAction)
        DispatchQueue.main.async {
            owner.present(alert, animated: true, completion: nil)
        }
    }
    
}



