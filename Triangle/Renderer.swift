//
//  Renderer.swift
//  Triangle
//
//  Created by Milton Montiel on 29/05/25.
//


import MetalKit

class Renderer : NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    
    lazy var triangle: Triangle = {
        Triangle(device: Self.device, scale: 0.8)
    }()
    
    init(metalView: MTKView) {
        // MARK: Initializing GPU and command queue.
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        // MARK: Creating the shader function library
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        
        // MARK: Creating pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat =
          metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor =
          MTLVertexDescriptor.defaultLayout
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        super.init()
        
        // MARK: Make `Renderer` a delegate for `metalView` so that the view
        // MARK: will call the `MTKViewDelegate` drawing methods.
        metalView.delegate = self
    }
    
}

extension Renderer : MTKViewDelegate {
    
    
    // MARK: Called every time the size of the window changes.
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    // MARK: Called every frame. This is where you write the render
    func draw(in view: MTKView) {
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder =
                commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // MARK: Drawing code
        renderEncoder.setVertexBuffer(triangle.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(triangle.colorBuffer, offset: 0, index: 1)
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: triangle.indices.count,
            indexType: .uint16,
            indexBuffer: triangle.indexBuffer,
            indexBufferOffset: 0)
        
        // MARK: Setting up the drawing code
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
