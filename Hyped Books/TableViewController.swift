//
//  TableViewController.swift
//  Hyped Books
//
//  Created by Азизбек on 01.01.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {
    
    var books : [Book] = []
    
    @IBOutlet var booksTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return books.count
    }
    

    func booksToDisplayAt(indexPath: IndexPath) -> Book {
         //экземпляр класса
        let correntBookInfo = books[indexPath.row]
            
        
        
         return correntBookInfo
        }
       
//MARK: callForRowAt ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!  BooksTableViewCell
        
        let book = booksToDisplayAt(indexPath: indexPath)
        
        cell.authorLabelOutlet.text = book.authors
        cell.annotationLabelOutlet.text = book.annotation
        cell.titleLabelOutlet.text = book.title
        
        DispatchQueue.global().async {
            let urlForImage = self.books[indexPath.row].cover.large
            guard let urlStringForImage = URL(string: urlForImage) else{return}
            guard let imageData = try? Data(contentsOf: urlStringForImage) else{return}
            
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                cell.imageViewOutlet.image = image
            }
        }
        

        return cell
    }
//MARK: Pagination
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let count = books.count
        if indexPath.row == (count-1){
            let activityIndicatror = UIActivityIndicatorView(style: .medium)
            activityIndicatror.startAnimating()
            activityIndicatror.frame = CGRect(x: CGFloat(0), y:CGFloat(0), width:tableView.bounds.width, height: CGFloat(30))
            self.fetchData()
            self.booksTable.tableFooterView = activityIndicatror
            self.booksTable.tableFooterView?.isHidden = false
            
        }
            
        
    }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if segue.identifier == "showWebInfo"
                {
                    //связь с конечным контролером
                    let webViewController = segue.destination as! WebViewController
                    //получение номера строки
                    let selectedCellIndexPath = tableView.indexPathForSelectedRow!

                    //создаем экземпляр для правилньной передачи данных ко второму вью контроллеру
                    let book = booksToDisplayAt(indexPath: selectedCellIndexPath)
                  
                    webViewController.uuid = book.uuid
                    print(book.uuid+"uuid")
                    //передаем значение индекса ко второму viewController
                }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
extension TableViewController{
    func fetchData(){
        guard let url = URL(string: "https://api.bookmate.com/api/v5/books/popular/") else {return}
               
               let session = URLSession.shared
               // начало сессии
               session.dataTask(with: url) { (data, response, error) in
                   guard let response = response else { return }
                   
                   //получаем наши данные
                   guard let data = data else{return}
//                   print(data)
                   
                   do{
                       //получаем данные в формате json
                     
                       let books = try JSONDecoder().decode(Books.self, from: data)
                    print(books.books[0])
                    DispatchQueue.main.async {
                        self.books = books.books
                        
                        print(1)
                        self.booksTable.reloadData()
                    }
                   }catch{
                       print(error )
                   }
               }.resume()
               
               
    }
    
    func configureImageAtRow(cell: UITableViewCell, indexPath:IndexPath) {
        
        
    }
}
