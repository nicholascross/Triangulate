struct Edge {
    let vertexA: Vertex
    let vertexB: Vertex

    var vertices: Set<Vertex> {
        [vertexA, vertexB]
    }
}

extension Edge: Equatable {
    // The vertices of two edges are considered equal if their values are equal when using floating point equality checks.
    // This is sufficient because the vertices are only compared directly and have not been modified or combined
    // mathematically to create new values. Therefore, it is not necessary to use more strict comparisons such as
    // relative or absolute tolerance checks.
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.vertices == rhs.vertices
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        vertices.hash(into: &hasher)
    }
}
