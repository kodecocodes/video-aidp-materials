///// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var warriorPath: UIView!
  @IBOutlet var warriorImageView: UIImageView!

  // MARK: - Properties
  var toDos: [ToDoItem] = []

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCollectViewCell()
    updateWarriorPosition()
  }
  
  private func registerCollectViewCell() {
    let nib = UINib(nibName: "ToDoCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "cell")
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func addToDo(_ sender: UIBarButtonItem) {
    let controller = UIAlertController(title: "Create Task",
                                       message: "What kind of task would you like to create?",
                                       preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Single Task", style: .default) { [unowned self] _ in
      self.createDefaultTask()
    })    
    controller.addAction(UIAlertAction(title: "Cancel", style: .default))
    present(controller, animated: true)
  }
  
  func createDefaultTask() {
    let controller = UIAlertController(title: "Create Task",
                                       message: "",
                                       preferredStyle: .alert)
    
    controller.addTextField { $0.placeholder = "Title" }
    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] alert in
      guard let self = self else { return }
      guard let titleTextField = controller.textFields?.first,
            titleTextField.text != "" else { return }
      
        let currentToDo = ToDoItem(name: titleTextField.text!)
        self.toDos.append(currentToDo)
        self.collectionView.reloadData()
        self.updateWarriorPosition()
    }
    controller.addAction(saveAction)
    controller.addAction(UIAlertAction(title: "Cancel", style: .default))
    present(controller, animated: true)
  }
  
  func updateWarriorPosition() {
    let percentageComplete: CGFloat
    if toDos.count == 0 {
      percentageComplete = 0
    } else {
      let completedToDos = toDos.filter { $0.isComplete }
      percentageComplete = CGFloat(completedToDos.count) / CGFloat(toDos.count)
    }
    
    var frame = warriorImageView.frame
    frame.origin.x = warriorPath.frame.width * percentageComplete + warriorPath.frame.minX/2
    warriorImageView.frame = frame
  }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return toDos.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let currentToDo = toDos[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToDoCell
    cell.delegate = self
    cell.label.text = currentToDo.name
    cell.checkBoxView.backgroundColor = currentToDo.isComplete ?
      UIColor(red: 0.24, green: 0.56, blue: 0.30, alpha: 1.0) : .white
    cell.layoutSubviews()
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let toDo = toDos[indexPath.row]
    toDo.isComplete = !toDo.isComplete
    
    let cell = collectionView.cellForItem(at: indexPath) as! ToDoCell
    cell.subtaskCollectionView.reloadData()
    
    collectionView.reloadData()
    updateWarriorPosition()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var size = CGSize()
    size.width = collectionView.frame.width
    size.height = collectionView.frame.height * 0.15
    return size
  }
}

// MARK: - ToDoCellDelegate
extension ViewController: ToDoCellDelegate {
  
  func toDoCellDidUpdateSubtask(_ cell: ToDoCell) {
    collectionView.reloadData()
    updateWarriorPosition()
  }
}
