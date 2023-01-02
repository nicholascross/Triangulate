import simd

struct Triangle {
    private var vertexA: Vertex
    private var vertexB: Vertex
    private var vertexC: Vertex

    init(vertexA: Vertex, vertexB: Vertex, vertexC: Vertex) {
        self.vertexA = vertexA
        self.vertexB = vertexB
        self.vertexC = vertexC
    }

    // Find the circum-center of the bounding box
    private var circumCenter: Vertex {
        let denominator: Float = 2 * (vertexA.x * (vertexB.y - vertexC.y) + vertexB.x * (vertexC.y - vertexA.y) + vertexC.x * (vertexA.y - vertexB.y))

        let circumCenterX: Float = ((vertexA.x * vertexA.x + vertexA.y * vertexA.y) * (vertexB.y - vertexC.y) + (vertexB.x * vertexB.x + vertexB.y * vertexB.y) * (vertexC.y - vertexA.y) + (vertexC.x * vertexC.x + vertexC.y * vertexC.y) * (vertexA.y - vertexB.y)) / denominator
        let circumCenterY: Float = ((vertexA.x * vertexA.x + vertexA.y * vertexA.y) * (vertexC.x - vertexB.x) + (vertexB.x * vertexB.x + vertexB.y * vertexB.y) * (vertexA.x - vertexC.x) + (vertexC.x * vertexC.x + vertexC.y * vertexC.y) * (vertexB.x - vertexA.x)) / denominator

        let circumCenter = Vertex(x: circumCenterX, y: circumCenterY)
        return circumCenter
    }

    // Find the circum-radius of the bounding box
    private var circumRadius: Float {
        let center = circumCenter
        let aDistance = simd_distance(vertexA, center)
        let bDistance = simd_distance(vertexB, center)
        let cDistance = simd_distance(vertexC, center)

        return max(aDistance, bDistance, cDistance)
    }

    // Check if a point is inside the circum-circle of the triangle
    func contains(_ point: Vertex) -> Bool {
        let distance = simd_distance(point, circumCenter)
        return distance <= circumRadius
    }

    // Get the edges of the triangle
    var edges: [Edge] {
        [Edge(vertexA: vertexA, vertexB: vertexB), Edge(vertexA: vertexB, vertexB: vertexC), Edge(vertexA: vertexC, vertexB: vertexA)]
    }

    var vertices: Set<Vertex> {
        [vertexA, vertexB, vertexC]
    }
}

extension Triangle: Equatable {
    // The vertices of two triangles are considered equal if their values are equal when using floating point equality checks.
    // This is sufficient because the vertices are only compared directly and have not been modified or combined
    // mathematically to create new values. Therefore, it is not necessary to use more strict comparisons such as
    // relative or absolute tolerance checks.
    static func == (lhs: Triangle, rhs: Triangle) -> Bool {
        lhs.vertices == rhs.vertices
    }
}
