public struct TriangleMesh {
    // A list of triangles that make up the triangle mesh
    let triangles: [Triangle]

    public let indices: [Int]
    public let vertices: [Point]

    // Initializes a new triangle mesh using the given list of points
    public init(_ points: [Point]) {
        // Triangulates the points to create the triangles for the mesh
        self.triangles = TriangleMesh.triangulatePoints(points)

        self.vertices = points
        self.indices = triangles.flatMap { triangle in
            triangle.vertices.map { points.firstIndex(of: $0) }.compactMap { $0 }
        }
    }

    // Returns a list of triangles that triangulate the given points
    private static func triangulatePoints(_ points: [Point]) -> [Triangle] {
        // Create a bounding box that encloses all the points
        let boundingBox = BoundingBox(points: points)
        // Create a super triangle that encloses the bounding box
        let superTriangle = boundingBox.enclosingTriangle

        // Initialize the list of triangles with the super triangle
        var triangles: [Triangle] = [superTriangle]

        // Iterate through each point and add it to the triangulation
        for point in points {
            // Find triangles that will be removed due to the insertion of the new point
            let badTriangles = findTrianglesWithPointInCircumCircle(triangles: triangles, point: point)
            // Find the boundary edges of the polygonal hole created by the removal of the bad triangles
            let edges = findBoundaryEdges(badTriangles: badTriangles)

            // Remove the bad triangles from the triangulation
            triangles.removeAll { triangle in
                badTriangles.contains(triangle)
            }

            // Add new triangles to the triangulation using the boundary edges of the hole and the new point
            for edge in edges.removingDuplicates() {
                triangles.append(Triangle(vertexA: point, vertexB: edge.vertexA, vertexC: edge.vertexB))
            }
        }

        // Find all the triangles that contain vertices from the original super triangle
        let toRemove = findTrianglesSharingSuperTriangleVertices(triangles: triangles, superTriangle: superTriangle)

        // Remove these triangles from the triangulation
        triangles.removeAll { triangle in
            toRemove.contains(triangle)
        }

        return triangles
    }

    private static func findTrianglesSharingSuperTriangleVertices(triangles: [Triangle], superTriangle: Triangle) -> [Triangle] {
        var trianglesFound: [Triangle] = []

        for triangle in triangles where superTriangle.vertices.intersection(triangle.vertices).count > 0 {
            trianglesFound.append(triangle)
        }

        return trianglesFound
    }

    private static func findTrianglesWithPointInCircumCircle(triangles: [Triangle], point: Point) -> [Triangle] {
        var badTriangles: [Triangle] = []

        // Find all the triangles that are no longer valid due to the insertion of the new point
        for triangle in triangles where triangle.contains(point) {
            badTriangles.append(triangle)
        }
        return badTriangles
    }

    private static func findBoundaryEdges(badTriangles: [Triangle]) -> [Edge] {
        var edges: [Edge] = []

        for (index, triangle) in badTriangles.enumerated() {
            for edge in triangle.edges {
                // Check if the edge is shared by any other triangles in the bad triangle list
                var sharedEdge = false
                for (otherIndex, otherTriangle) in badTriangles.enumerated() where index != otherIndex && otherTriangle.edges.contains(edge) {
                    sharedEdge = true
                    break
                }

                // If the edge is not shared by any other triangles, it is a boundary edge of the hole
                if !sharedEdge {
                    edges.append(edge)
                }
            }
        }

        return edges
    }
}

private extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var set = Set<Element>()
        return filter {
            if set.contains($0) {
                return false
            } else {
                set.insert($0)
                return true
            }
        }
    }
}
