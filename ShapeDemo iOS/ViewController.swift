import UIKit
import Shape

class ViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var rotationSlider: UISlider!
    @IBOutlet weak var shapeView: SHView!
    @IBOutlet weak var shapeInfoLabel: UILabel!
    @IBOutlet weak var shapeListStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeView.delegate = self
        shapeView.layer.cornerRadius = 4
        shapeView.backgroundColor = UIColor.lightGray
        
        shapeListStackView.arrangedSubviews.forEach(shapeListStackView.removeArrangedSubview)
        ShapeType.allCases.forEach { shapeType in
            let button = UIButton(type: .system)
            button.tag = shapeListStackView.arrangedSubviews.count
            button.backgroundColor = .opaqueSeparator
            button.setTitle(shapeType.rawValue, for: .normal)
            button.addTarget(self, action: #selector(shapeButtonDidTap(_:)), for: .touchUpInside)
            shapeListStackView.addArrangedSubview(button)
        }
        
        updateUI()
    }
    
    func updateUI() {
        if case .infinity = shapeView.currentItem?.type {
            finishButton.isEnabled = true
        } else {
            finishButton.isEnabled = false
        }
        
        removeButton.isEnabled = !shapeView.selectedItemIndexes.isEmpty
        
        if let item = shapeView.currentItem ?? (shapeView.selectedItems.count == 1 ? shapeView.selectedItems.first : nil) {
            let degrees = degreesFromRadians(-item.rotationAngle)
            if item == shapeView.selectedItems.first {
                rotationSlider.isEnabled = true
                rotationSlider.value = Float(degrees)
            }
            shapeInfoLabel.text = "\(item)"
        } else {
            rotationSlider.isEnabled = false
            rotationSlider.value = 0
            shapeInfoLabel.text = ""
        }
    }

    @IBAction func finishButtonDidTap(_ sender: Any) {
        shapeView.finish()
    }

    @IBAction func removeButtonDidTap(_ sender: Any) {
        shapeView.removeItems(at: shapeView.selectedItemIndexes)
        updateUI()
    }
    
    @IBAction func rotationSliderDidChangeValue(_ sender: UISlider) {
        if shapeView.selectedItems.count == 1, let item = shapeView.selectedItems.first {
            let degrees = CGFloat(sender.value)
            let rotationAngle = radiansFromDegrees(-degrees)
            item.rotate(rotationAngle)
        }
    }

    @objc func shapeButtonDidTap(_ sender: UIButton) {
        shapeView.gen(ShapeType.allCases[sender.tag].shType)
    }
    
}

extension ViewController: SHViewDelegate {
    
    func shapeView(_ shapeView: SHView, didStart item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, finishing item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didFinish item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didCancel item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didModify item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didEndModify item: SHItem) {
        
    }
    
    func shapeView(_ shapeView: SHView, didSelect items: [SHItem]) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didDeselect items: [SHItem]) {
        updateUI()
    }
    
}

