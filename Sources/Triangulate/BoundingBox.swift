import simd

struct BoundingBox {
    let enclosingTriangle: Triangle

    init(points: [Point]) {
        var min = Point(x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude)
        var max = Point(x: -.greatestFiniteMagnitude, y: -.greatestFiniteMagnitude)

        for point in points {
            min = simd_min(min, point)
            max = simd_max(max, point)
        }

        let center = (min + max) / 2

        let radius = simd_max(simd_distance(min, center), simd_distance(max, center))
        let vertexA = Point(center.x, center.y + radius * Float.pi)
        let vertexB = Point(center.x - radius * Float.pi + radius, center.y - radius * 2)
        let vertexC = Point(center.x + radius * Float.pi - radius, center.y - radius * 2)

        // NOTE: This is not a minimally enclosing triangle
        self.enclosingTriangle = Triangle(vertexA: vertexA, vertexB: vertexB, vertexC: vertexC)
    }
}
