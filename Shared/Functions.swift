import CoreGraphics

func format(_ num: CGFloat) -> CGFloat {
    round(num * 1000) / 1000
}

func degreesFromRadians(_ r: CGFloat) -> CGFloat {
    r * 180 / .pi
}

func radiansFromDegrees(_ d: CGFloat) -> CGFloat {
    d * .pi / 180
}
