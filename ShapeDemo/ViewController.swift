import Cocoa
import Shape

enum ShapeType: String, CaseIterable {
    case line         = "Line"
    case polyline     = "Polyline"
    case rect         = "Rectangle"
    case square       = "Square"
    case circle       = "Circle"
    case protractor   = "Protractor"
    case exProtractor = "ExProtractor"
    case pencil       = "Pencil"
    
    var shType: SHItem.Type {
        switch self {
        case .line:         return SHLineItem.self
        case .polyline:     return SHPolylineItem.self
        case .rect:         return SHRectItem.self
        case .square:       return SHSquareItem.self
        case .circle:       return SHCircleItem.self
        case .protractor:   return SHProtractorItem.self
        case .exProtractor: return SHExProtractorItem.self
        case .pencil:       return SHItem.self
        }
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var shapeListButton: NSPopUpButton!
    @IBOutlet weak var finishButton: NSButton!
    @IBOutlet weak var shapeView: SHView!
    @IBOutlet weak var removeButton: NSButton!
	@IBOutlet weak var rotationSlider: NSSlider!
    @IBOutlet weak var shapeColorWell: NSColorWell!
    @IBOutlet weak var shapeInfoLabel: NSTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeListButton.removeAllItems()
        shapeListButton.addItems(withTitles: ShapeType.allCases.map { $0.rawValue })
        
        shapeView.backgroundColor = .highlightColor
        shapeView.delegate = self
        shapeView.layer?.cornerRadius = 4
		
        updateUI()
    }
	
	func format(_ num: CGFloat) -> CGFloat {
		round(num * 1000) / 1000
	}
	
	func degreesFromRadians(_ r: CGFloat) -> CGFloat {
		r * 180 / .pi
	}
	
	func radiansFromDegrees(_ d: CGFloat) -> CGFloat {
		d * .pi / 180
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
                rotationSlider.doubleValue = Double(degrees)
            }
			shapeInfoLabel.stringValue = infoText(of: item)
            shapeColorWell.color = item.tintColor
		} else {
			rotationSlider.isEnabled = false
			rotationSlider.doubleValue = 0
			shapeInfoLabel.stringValue = ""
            shapeColorWell.color = shapeView.itemTintColor
		}
    }
	
	func infoText(of shape: SHItem) -> String {
		switch shape {
		case let line as SHDistanceMeasurable:
			return line.distances.enumerated()
				.map {
					let n = String(format: "%2d", $0.offset + 1)
					let d = format($0.element).description
					return "[\(n)] " + d + "\n"
				}
				.joined()
			
		case let circle as SHCircularMeasurable:
			return """
			Radius: \(format(circle.radius))
			"""
			
		case let rect as SHRectMeasurable:
			return """
			Width : \(format(rect.size.width))
			Height: \(format(rect.size.height))
			"""
			
		case let angle as SHAngleMeasurable:
			return "Angle: \(format(degreesFromRadians(angle.angle)))"
			
		default:
			return ""
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
	
	func shapeView(_ shapeView: SHView, didEndModify item: SHItem) {
		
	}
    
    func shapeView(_ shapeView: SHView, didSelect items: [SHItem]) {
        updateUI()
    }
    
    func shapeView(_ shapeView: SHView, didDeselect items: [SHItem]) {
        updateUI()
    }
    
}
