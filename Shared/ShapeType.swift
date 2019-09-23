import Foundation
import Shape

enum ShapeType: String, CaseIterable {
    case line         = "Line"
    case polyline     = "Polyline"
    case rect         = "Rectangle"
    case square       = "Square"
    case circle       = "Circle"
    case protractor   = "Protractor"
    case exProtractor = "ExProtractor"
	case gnProtractor = "GnProtractor"
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
		case .gnProtractor: return SHGnProtractor.self
        case .pencil:       return SHPencilItem.self
        }
    }
}
