import Cocoa
import Shape

class ViewController: NSViewController {
    
    @IBOutlet weak var shapeListButton: NSPopUpButton!
    @IBOutlet weak var finishButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
	@IBOutlet weak var rotationSlider: NSSlider!
	@IBOutlet weak var rotationCheckBox: NSButton!
	@IBOutlet weak var shapeColorWell: NSColorWell!
    @IBOutlet weak var shapeView: SHView!
    @IBOutlet weak var shapeInfoLabel: NSTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // set up shapeListButton
        shapeListButton.removeAllItems()
        shapeListButton.addItems(withTitles: ShapeType.allCases.map { $0.rawValue })
        // set up rotationSlider
		rotationSlider.rotate(byDegrees: 90)
		rotationCheckBox.state = (shapeView.isRotateToolEnabled ? .on : .off)
		// set up shapeView
        shapeView.backgroundColor = .highlightColor
        shapeView.delegate = self
        shapeView.layer?.cornerRadius = 4
		
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
            let angle = item.rotationAngle > 0 ? item.rotationAngle : .pi * 2 + item.rotationAngle
			let degrees = 360 - degreesFromRadians(angle)
            if item == shapeView.selectedItems.first {
				rotationSlider.isEnabled = shapeView.isRotateToolEnabled
                rotationSlider.doubleValue = Double(degrees)
            }
			shapeInfoLabel.stringValue = "\(item.shapeInfoText)"
            shapeColorWell.color = item.tintColor
		} else {
			rotationSlider.isEnabled = false
			rotationSlider.doubleValue = 0
			shapeInfoLabel.stringValue = ""
            shapeColorWell.color = shapeView.itemTintColor
		}
    }
    
    @IBAction func genButtonDidClick(_ sender: Any) {
        let type = ShapeType.allCases[shapeListButton.indexOfSelectedItem]
        shapeView.gen(type.shType)
    }

    @IBAction func finishButtonDidClick(_ sender: Any) {
        shapeView.finish()
    }

    @IBAction func removeButtonDidClick(_ sender: Any) {
        shapeView.removeItems(at: shapeView.selectedItemIndexes)
        updateUI()
    }
    
	@IBAction func rotationSliderDidChangeValue(_ sender: NSSlider) {
		if shapeView.selectedItems.count == 1, let item = shapeView.selectedItems.first {
			let degrees = CGFloat(sender.doubleValue)
			let rotationAngle = radiansFromDegrees(-degrees)
			item.rotate(rotationAngle)
		}
	}
	
	@IBAction func rotationCheckBoxDidChangeValue(_ sender: NSButton) {
		shapeView.isRotateToolEnabled = (sender.state == .on)
		updateUI()
	}
	
    @IBAction func shapeColorWellDidChangeValue(_ sender: NSColorWell) {
        if let item = shapeView.currentItem {
            item.tintColor = sender.color
        } else if !shapeView.selectedItems.isEmpty {
            shapeView.selectedItems.forEach { item in
                item.tintColor = sender.color
            }
        } else {
            shapeView.itemTintColor = sender.color
        }
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
    
    func shapeView(_ shapeView: SHView, didRotate item: SHItem) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didSelect items: [SHItem]) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didDeselect items: [SHItem]) {
        updateUI()
    }
    
}
