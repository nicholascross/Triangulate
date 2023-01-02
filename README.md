# Triangulate

Triangulate is a Swift library for generating Delaunay triangulations using the [Bowyer-Watson algorithm](https://en.wikipedia.org/wiki/Bowyer–Watson_algorithm).

## Installation

To install Triangulate, add it to your project using Swift Package Manager.

```swift
.package(url: "https://github.com/nicholascross/Triangulate", from: "0.0.1")
```

## Usage

To generate a Delaunay triangulation, create a TriangleMesh instance and pass it a list of vertices:

```swift
let vertices = [
    simd_float2(x: 0, y: 0),
    simd_float2(x: 100, y: 0),
    simd_float2(x: 0, y: 100),
    simd_float2(x: 100, y: 100)
]
let mesh = TriangleMesh(vertices)
```

The indices property of the `TriangleMesh` instance will contain the indices of the triangles in the mesh, referencing the vertices in the vertices property.

For example to render the triangulation in a SwiftUI view, you can use the indices and vertices properties to draw the triangles using a `Path` as follows.

```swift
ZStack(alignment: .center) {
    ForEach(Array(stride(from: 0, to: self.mesh.indices.count, by: 3)), id: \.self) { i in
        Path { path in
            let index1 = self.mesh.indices[i]
            let vertex1 = self.mesh.vertices[index1]
            let index2 = self.mesh.indices[(i + 1)]
            let vertex2 = self.mesh.vertices[index2]
            let index3 = self.mesh.indices[(i + 2)]
            let vertex3 = self.mesh.vertices[index3]

            path.move(to: CGPoint(x: CGFloat(vertex1.x), y: CGFloat(vertex1.y)))
            path.addLine(to: CGPoint(x: CGFloat(vertex2.x), y: CGFloat(vertex2.y)))
            path.addLine(to: CGPoint(x: CGFloat(vertex3.x), y: CGFloat(vertex3.y)))
            path.closeSubpath()
        }
        .stroke(Color.red)
    }
}
```
