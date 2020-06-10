package hello_triangle;

import glfw.GLFW;
import wgpu.*;

class Main {
	static function main() {
		final WINDOW_WIDTH = 800;
		final WINDOW_HEIGHT = 600;

		var glfw = new GLFW();
		var window = glfw.createWindow({
			title: "Hello triangle",
			width: WINDOW_WIDTH,
			height: WINDOW_HEIGHT,
		});

		trace('wgpu version: ${WGPU.version}');

		final surface = Surface.fromGLFW(window.nativeHandle());

		final adapter = new Adapter({
			powerPreference: HighPerformance,
			compatibleSurface: surface,
		}, Primary);

		final device = adapter.requestDevice({
			extensions: {
				anisotropicFiltering: true,
			},
			limits: {
				maxBindGroups: Limits.MAX_BIND_GROUPS,
			}
		});

		final queue = device.getDefaultQueue();

		final swapChainDescriptor:SwapChainDescriptor = {
			usage: OutputAttachment,
			format: Bgra8UnormSrgb,
			width: WINDOW_WIDTH,
			height: WINDOW_HEIGHT,
			presentMode: Mailbox,
		};

		final swapChain = device.createSwapChain(surface, swapChainDescriptor);

		final vertices = [
			 0.0,  1.0,
			-1.0, -1.0,
			 1.0, -1.0,
		];

		final vertexBuffer = device.createBufferWithFloat32Data(vertices, Vertex);

		final vertexShader = device.createShaderModuleFromFile("hello_triangle/triangle.vert.spv");
		final fragmentShader = device.createShaderModuleFromFile("hello_triangle/triangle.frag.spv");

		final renderPipelineLayout = device.createPipelineLayout({
			bindGroupLayouts: [],
		});

		final renderPipeline = device.createRenderPipeline({
			layout: renderPipelineLayout,
			vertexStage: {
				module: vertexShader,
				entryPoint: "main",
			},
			fragmentStage: {
				module: fragmentShader,
				entryPoint: "main",
			},
			rasterizationState: {
				frontFace: Ccw,
				cullMode: Back,
				depthBias: 0,
				depthBiasSlopeScale: 0.0,
				depthBiasClamp: 0.0,
			},
			primitiveTopology: TriangleList,
			colorStates: [
				{
					format: swapChainDescriptor.format,
					alphaBlend: BlendDescriptor.REPLACE,
					colorBlend: BlendDescriptor.REPLACE,
					writeMask: All,
				},
			],
			vertexState: {
				indexFormat: UInt16,
				vertexBuffers: [
					{
						stride: 4 * 2,
						stepMode: Vertex,
						attributes: [
							{
								offset: 0,
								format: Float2,
								shaderLocation: 0,
							},
						],
					},
				],
			},
			sampleCount: 1,
			sampleMask: ~0,
			alphaToCoverageEnabled: false,
		});

		while (!window.shouldClose) {
			final outputTexture = swapChain.getNextTexture();

			if (outputTexture == null) {
				throw "Cannot acquire next swap chain texture";
			}

			final commandEncoder = device.createCommandEncoder({
				label: null,
			});

			final renderPass = commandEncoder.beginRenderPass({
				colorAttachments: [
					{
						attachment: outputTexture.view,
						resolveTarget: null,
						loadOp: Clear,
						storeOp: Store,
						clearColor: {
							r: 0.0,
							g: 0.0,
							b: 0.0,
							a: 1.0,
						},
					},
				],
				depthStencilAttachment: null,
			});

			renderPass.setPipeline(renderPipeline);
			renderPass.setVertexBuffer(0, vertexBuffer, 0, 0);
			renderPass.draw(0, vertices.length, 0, 1);

			renderPass.endPass();

			queue.submit([commandEncoder.finish()]);
			swapChain.present();

			glfw.pollEvents();
		}

		window.destroy();
		glfw.destroy();
	}
}
