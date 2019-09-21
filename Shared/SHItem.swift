import Shape

extension SHItem: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case let line as SHDistanceMeasurable:
            return line.distances.enumerated()
                .map {
                    let n = String(format: "%2d", $0.offset + 1)
                    let d = format($0.element).description
                    return "[\(n)] " + d + "\n"
                }
                .joined()
            
        case let circle as SHCircularMeasurable:
            return "Radius: \(format(circle.radius))"
            
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
    
}
