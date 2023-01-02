@testable import Triangulate
import XCTest

class TriangleMeshTests: XCTestCase {
    func testSingleVertex() {
        let vertices = [Vertex(x: 0, y: 0)]

        let expectedTriangles = [Triangle]()

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles, expectedTriangles)
    }

    func testTwoVertices() {
        let vertices = [Vertex(x: 0, y: 0), Vertex(x: 1, y: 0)]

        let expectedTriangles = [Triangle]()

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles, expectedTriangles)
    }

    func testThreeVertices() {
        let vertices = [Vertex(x: 0, y: 0), Vertex(x: 1, y: 0), Vertex(x: 0.5, y: 0.866)]

        let expectedTriangles = [
            Triangle(vertexA: Vertex(x: 0.5, y: 0.866), vertexB: Vertex(x: 0, y: 0), vertexC: Vertex(x: 1, y: 0))
        ]

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles.count, expectedTriangles.count)
        XCTAssertEqual(mesh.triangles, expectedTriangles)

        XCTAssertEqual(mesh.vertices, vertices)
        XCTAssertEqual(Set(mesh.indices), Set([0, 1, 2]))
    }

    func testFourVertices() {
        let vertices = [
            Vertex(x: 0, y: 0),
            Vertex(x: 1, y: 0),
            Vertex(x: 0.5, y: 0.866),
            Vertex(x: 1.5, y: 0.866)
        ]

        let expectedTriangles = [
            Triangulate.Triangle(
                vertexA: Vertex(0.5, 0.866),
                vertexB: Vertex(0.0, 0.0),
                vertexC: Vertex(1.0, 0.0)
            ),
            Triangulate.Triangle(
                vertexA: Vertex(1.5, 0.866),
                vertexB: Vertex(0.5, 0.866),
                vertexC: Vertex(1.0, 0.0)
            )
        ]

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles.count, expectedTriangles.count)
        XCTAssertEqual(mesh.triangles, expectedTriangles)

        XCTAssertEqual(mesh.vertices, vertices)
        XCTAssertEqual(Set(mesh.indices[0 ..< 3]), Set([2, 1, 0]))
        XCTAssertEqual(Set(mesh.indices[3 ..< 6]), Set([3, 2, 1]))
    }

    func testFiveVertices() {
        let vertices = [
            Vertex(x: 0, y: 0),
            Vertex(x: 1, y: 0),
            Vertex(x: 0.5, y: 0.866),
            Vertex(x: 1.5, y: 0.866),
            Vertex(x: 1.5, y: 0.466)
        ]

        let expectedTriangles = [
            Triangulate.Triangle(vertexA: Vertex(0.5, 0.866), vertexB: Vertex(0.0, 0.0), vertexC: Vertex(1.0, 0.0)),
            Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(1.5, 0.866), vertexC: Vertex(0.5, 0.866)),
            Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(0.5, 0.866), vertexC: Vertex(1.0, 0.0))
        ]

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles.count, expectedTriangles.count)
        XCTAssertEqual(mesh.triangles, expectedTriangles)

        XCTAssertEqual(mesh.vertices, vertices)
        XCTAssertEqual(Set(mesh.indices[0 ..< 3]), Set([2, 1, 0]))
        XCTAssertEqual(Set(mesh.indices[3 ..< 6]), Set([2, 4, 3]))
        XCTAssertEqual(Set(mesh.indices[6 ..< 9]), Set([2, 4, 1]))
    }

    func testFiveVerticesWithPreciseValues() {
        let vertices = [Vertex(x: 0.000000001, y: 0.000000002), Vertex(x: 1.000000000, y: 0.000000003), Vertex(x: 0.500000000, y: 0.866000000), Vertex(x: 1.500000000, y: 0.866000000), Vertex(x: 1.500000000, y: 0.466000000)]

        let expectedTriangles = [
            Triangulate.Triangle(vertexA: Vertex(0.500000000, 0.866000000), vertexB: Vertex(0.000000001, 0.000000002), vertexC: Vertex(1.000000000, 0.000000003)),
            Triangulate.Triangle(vertexA: Vertex(1.500000000, 0.466000000), vertexB: Vertex(1.500000000, 0.866000000), vertexC: Vertex(0.500000000, 0.866000000)),
            Triangulate.Triangle(vertexA: Vertex(1.500000000, 0.466000000), vertexB: Vertex(0.500000000, 0.866000000), vertexC: Vertex(1.000000000, 0.000000003))
        ]

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles.count, expectedTriangles.count)
        XCTAssertEqual(mesh.triangles, expectedTriangles)

        XCTAssertEqual(mesh.vertices, vertices)
        XCTAssertEqual(Set(mesh.indices[0 ..< 3]), Set([2, 1, 0]))
        XCTAssertEqual(Set(mesh.indices[3 ..< 6]), Set([2, 4, 3]))
        XCTAssertEqual(Set(mesh.indices[6 ..< 9]), Set([2, 4, 1]))
    }

    func testFiveVerticesWithLargeAndSmallValues() {
        let vertices = [Vertex(x: 1e-7, y: 1e-7), Vertex(x: 1e7, y: 1e7), Vertex(x: 0.5, y: 0.866), Vertex(x: 1.5, y: 0.866), Vertex(x: 1.5, y: 0.466)]

        let expectedTriangles = [
            Triangulate.Triangle(vertexA: SIMD2<Float>(1.5, 0.466), vertexB: SIMD2<Float>(1.5, 0.866), vertexC: SIMD2<Float>(0.5, 0.866)),
            Triangulate.Triangle(vertexA: SIMD2<Float>(1.5, 0.466), vertexB: SIMD2<Float>(0.5, 0.866), vertexC: SIMD2<Float>(1e-07, 1e-07)),
            Triangulate.Triangle(vertexA: SIMD2<Float>(1.5, 0.466), vertexB: SIMD2<Float>(10_000_000.0, 10_000_000.0), vertexC: SIMD2<Float>(1.5, 0.866))
        ]

        let mesh = TriangleMesh(vertices)

        XCTAssertEqual(mesh.triangles.count, expectedTriangles.count)
        XCTAssertEqual(mesh.triangles, expectedTriangles)

        XCTAssertEqual(mesh.vertices, vertices)
        XCTAssertEqual(Set(mesh.indices[0 ..< 3]), Set([4, 3, 2]))
        XCTAssertEqual(Set(mesh.indices[3 ..< 6]), Set([4, 2, 0]))
        XCTAssertEqual(Set(mesh.indices[6 ..< 9]), Set([4, 3, 1]))
    }

    func testEquality() {
        let triangle1 = Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(1.0, 0.0), vertexC: Vertex(1.5, 0.866))
        let triangle2 = Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(1.0, 0.0), vertexC: Vertex(1.5, 0.866))
        XCTAssertEqual(triangle1, triangle2)

        let triangle3 = Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(1.5, 0.866), vertexC: Vertex(1.0, 0.0))
        let triangle4 = Triangulate.Triangle(vertexA: Vertex(1.5, 0.466), vertexB: Vertex(1.0, 0.0), vertexC: Vertex(1.5, 0.866))
        XCTAssertEqual(triangle1, triangle2)
    }
}
