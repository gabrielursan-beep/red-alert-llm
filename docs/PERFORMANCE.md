# Performance Benchmarks

## What Affects LLM Speed

**#1 Memory Bandwidth** — the single biggest factor. LLM inference is memory-bound, not CPU-bound. Faster RAM = faster responses.

| Memory Type | Bandwidth | Found In |
|-------------|-----------|----------|
| Apple Unified (M1+) | 100-400 GB/s | MacBooks, Mac Mini, iMac |
| DDR5-5600 | ~45 GB/s | Modern gaming PCs |
| DDR4-3200 | ~25 GB/s | Most laptops/desktops |
| LPDDR4X | ~17 GB/s | Older laptops, phones |

**#2 GPU Offloading** — Metal (Apple), CUDA (NVIDIA) move matrix math to GPU. 2-5x speedup vs CPU-only.

**#3 Model Size** — smaller models generate faster (fewer parameters to process per token).

**#4 Quantization** — Q4_K_M is the sweet spot. Q3 is ~15% faster but less accurate.

**#5 Context Length** — longer conversations slow down. 4096 tokens is a good default.

**Irrelevant factors:** USB speed (only affects initial load, not inference), CPU clock speed (minimal impact), SSD speed (model is in RAM after loading).

## Desktop Benchmarks

### Qwen3-4B Q4_K_M (2.5 GB model)

| Hardware | RAM | GPU | Prompt (tok/s) | Generation (tok/s) |
|----------|-----|-----|----------------|---------------------|
| MacBook Air M1 | 8 GB | Metal | 80-120 | 25-35 |
| MacBook Pro M2 | 16 GB | Metal | 120-180 | 35-45 |
| MacBook Pro M3 Pro | 36 GB | Metal | 150-220 | 40-55 |
| Intel i5-12400 | 16 GB DDR4 | CPU | 30-50 | 10-18 |
| AMD Ryzen 5 5600X | 32 GB DDR4 | CPU | 40-60 | 15-25 |
| Intel i7-13700K | 32 GB DDR5 | CPU | 50-80 | 18-28 |
| RTX 3060 (12 GB) | 16 GB | CUDA | 200-400 | 40-60 |
| RTX 4070 (12 GB) | 32 GB | CUDA | 300-600 | 60-90 |

### Qwen3-8B Q4_K_M (5 GB model)

| Hardware | RAM | GPU | Generation (tok/s) |
|----------|-----|-----|--------------------|
| MacBook Pro M2 | 16 GB | Metal | 25-35 |
| MacBook Pro M3 Pro | 36 GB | Metal | 35-50 |
| Intel i5-12400 | 16 GB DDR4 | CPU | 6-12 |
| RTX 3060 (12 GB) | 16 GB | CUDA | 30-45 |
| RTX 4070 (12 GB) | 32 GB | CUDA | 45-70 |

### Qwen3-14B Q4_K_M (9 GB model)

| Hardware | RAM | GPU | Generation (tok/s) |
|----------|-----|-----|--------------------|
| MacBook Pro M2 | 16 GB | Metal | 12-20 |
| MacBook Pro M3 Pro | 36 GB | Metal | 25-40 |
| AMD Ryzen 7 | 32 GB DDR5 | CPU | 8-15 |
| RTX 4070 (12 GB) | 32 GB | CUDA | 30-50 |
| RTX 4090 (24 GB) | 64 GB | CUDA | 50-80 |

## Mobile Benchmarks

### Qwen3-4B Q3_K_M (~2 GB model, mobile quantization)

| Device | RAM | SoC | Speed (tok/s) | Usable? |
|--------|-----|-----|---------------|---------|
| iPhone 15 Pro | 8 GB | A17 Pro | 15-20 | Yes |
| iPhone 14 Pro | 6 GB | A16 | 10-15 | Yes |
| iPhone 13 | 4 GB | A15 | 6-10 | Marginal |
| iPad Air M2 | 8 GB | M2 | 25-35 | Excellent |
| Samsung S24 Ultra | 12 GB | Snapdragon 8 Gen 3 | 10-15 | Yes |
| Samsung S23 | 8 GB | Snapdragon 8 Gen 2 | 8-12 | Yes |
| Pixel 8 Pro | 12 GB | Tensor G3 | 6-10 | Marginal |
| Xiaomi Redmi 14C | 4 GB | Helio G81 | 2-4 | Too slow |

## Model Loading Times

Time from script start to first response:

| Model Size | USB 3.2 Gen 2 SSD | USB 3.0 SSD | USB 3.0 Flash Drive |
|-----------|-------------------|------------|-------------------|
| 2.5 GB (4B) | ~3 sec | ~9 sec | ~25 sec |
| 5 GB (8B) | ~5 sec | ~17 sec | ~50 sec |
| 9 GB (14B) | ~10 sec | ~30 sec | ~90 sec |

After loading, the model stays in RAM. USB speed has no further impact.

## Recommendations

| Your Setup | Best Model | Expected Speed |
|------------|-----------|----------------|
| Old laptop, 8 GB RAM | Qwen3-4B | 8-15 tok/s (usable) |
| Modern laptop, 16 GB, no GPU | Qwen3-8B | 10-20 tok/s (good) |
| MacBook Air/Pro M1-M4 | Qwen3 (biggest that fits) | 25-55 tok/s (excellent) |
| Gaming PC with NVIDIA GPU | Qwen3-14B | 30-80 tok/s (excellent) |
| Phone (any) | Qwen3-4B Q3_K_M | 5-20 tok/s (depends on phone) |
