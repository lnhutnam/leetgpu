// Easy

#include <cuda_runtime.h>

__global__ void invert_kernel(unsigned char* image, int width, int height) {
    int pixel_idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total_pixels = width * height;
    
    // Check if the thread is within the valid pixel range
    if (pixel_idx < total_pixels) {
        // Each pixel has 4 components (RGBA)
        int base_idx = pixel_idx * 4;
        // Invert R, G, B; leave A unchanged
        image[base_idx + 0] = 255 - image[base_idx + 0]; // R
        image[base_idx + 1] = 255 - image[base_idx + 1]; // G
        image[base_idx + 2] = 255 - image[base_idx + 2]; // B
        // image[base_idx + 3] remains unchanged (A)
    }
}
// image_input, image_output are device pointers (i.e. pointers to memory on the GPU)
extern "C" void solve(unsigned char* image, int width, int height) {
    int threadsPerBlock = 256;
    int blocksPerGrid = (width * height + threadsPerBlock - 1) / threadsPerBlock;

    invert_kernel<<<blocksPerGrid, threadsPerBlock>>>(image, width, height);
    cudaDeviceSynchronize();
}