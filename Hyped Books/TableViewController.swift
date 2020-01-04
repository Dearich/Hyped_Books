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
    var isLoading:Bool = false
    var limit = true
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet var booksTable: UITableView!

    
    override func viewWillAppear(_ animated: Bool) {
        if CheckInternetConnection.Connection() {
            guard limit else {return}
            limit = false
            self.activityIndicator()
            indicator.startAnimating()
            indicator.backgroundColor = .clear
            
        }else {
                self.Alert(Message: "Подключитесь к интернету!")
                
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hyped Books"
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        booksTable.estimatedRowHeight = 182
        booksTable.rowHeight = UITableView.automaticDimension
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
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
        
//
//        DispatchQueue.global().async {
        let urlForImage = self.books[indexPath.row].cover.large
        
        if let urlStringForImage = URL(string: urlForImage) {
            ImageService.getImageFromCashe(withURL: urlStringForImage) { image in
            cell.imageViewOutlet.image = image
            }
        }
        return cell
    }
//MARK: Pagination, tableView willDisplay
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if CheckInternetConnection.Connection(){
            if segue.identifier == "showWebInfo"
            {
                //связь с конечным контролером
                let webViewController = segue.destination as! WebViewController
                //получение номера строки
                let selectedCellIndexPath = tableView.indexPathForSelectedRow!

                //создаем экземпляр для правилньной передачи данных к WebView
                let book = booksToDisplayAt(indexPath: selectedCellIndexPath)
              
                webViewController.uuid = book.uuid
                print(book.uuid+"uuid")
                //передаем значение индекса ко WebViewController
            }
        } else{
            self.Alert(Message: " Проверьте подключение к интернету.")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    

}




extension TableViewController{
    func fetchData(){
        isLoading = true
        guard let url = URL(string: "https://api.bookmate.com/api/v5/books/popular/") else {return}
               
               let session = URLSession.shared
               // начало сессии
               session.dataTask(with: url) { (data, response, error) in
                   //получаем наши данные
                   guard let data = data else{return}
//                   print(data)
                   
                   do{
                       //получаем данные в формате json
                     
                       let books = try JSONDecoder().decode(Books.self, from: data)
                    print(books.books[0])
                    DispatchQueue.main.async {
                        self.books.append(contentsOf: books.books)
                        self.isLoading = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                            self.indicator.stopAnimating()
                            self.indicator.hidesWhenStopped = true
                            self.booksTable.reloadData()
                        }
                        
                        
                    }
                   }catch{
                       print(error )
                   }
               }.resume()
               
               
    }
    
    func configureImageAtRow(cell: UITableViewCell, indexPath:IndexPath) {
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY =  scrollView.contentOffset.y
        let contentHight = scrollView.contentSize.height
        
        //определение положения scrollView в нижней точке и отслеживание процесса overscrolling
        
        if offSetY > contentHight - scrollView.frame.height * 3 {
            if !isLoading{
                print("beginLoad ")
                fetchData()
            }
            
        }
         
    }
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "Нет подключения!", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
   
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = .lightGray
        indicator.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - 100.0)
        self.view.addSubview(indicator)
    }
}


    

