# hxwgpu-samples

![Build Status](https://github.com/ibilon/hxwgpu-samples/workflows/Main/badge.svg)

Samples for the [hxwgpu](https://github.com/ibilon/hxwgpu/) library.

# Building

Make sure to clone this repository with `--recursive`, or download the submodule with `git submodule update --init --recursive`.

Requirements:

* `hxwgpu` <https://github.com/ibilon/hxwgpu#building>
* `hwglfw` <https://github.com/ibilon/hxglfw#building>

To build:

* Compile the cppia host with `haxe cppia_host.hxml`, this only need to be rebuilt if hxwgpu or hxglfw are updated or changed
* Compile the samples with `haxe build_all.hxml`

To run the samples:

* `hello_triangle`: `./build/cppia_host/CppiaHost-debug build/hello_triangle.cppia`

If you update the shaders you can recompile them with:

* `glslangValidator -V -S frag -o hello_triangle/triangle.frag.spv hello_triangle/triangle.frag.glsl`
* `glslangValidator -V -S vert -o hello_triangle/triangle.vert.spv hello_triangle/triangle.vert.glsl`

# License

The samples are adapted from the rust versions in [wgpu-rs](https://github.com/gfx-rs/wgpu-rs/) and are licensed under the [MPL-2.0](https://github.com/gfx-rs/wgpu-native/blob/29c9b0942dc01159aa999c53396e79f48a3a2094/LICENSE) license.
