/****************************************************************************
 *
 *    Copyright (c) 2017 - 2018 by Rockchip Corp.  All rights reserved.
 *
 *    The material in this file is confidential and contains trade secrets
 *    of Rockchip Corporation. This is proprietary information owned by
 *    Rockchip Corporation. No part of this work may be disclosed,
 *    reproduced, copied, transmitted, or used in any way for any purpose,
 *    without the express written permission of Rockchip Corporation.
 *
 *****************************************************************************/

/*-------------------------------------------
                Includes
-------------------------------------------*/
#include "fp16/Float16.h"
#include "rknn_matmul_api.h"
#include "rknn_api.h"
#include "matmul_utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include <vector>
using namespace rknpu2;

/*-------------------------------------------
                  Functions
-------------------------------------------*/
static inline int64_t getCurrentTimeUs()
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec * 1000000 + tv.tv_usec;
}

// 一维矩阵乘法函数
template <typename Ti, typename To>
std::vector<To> matrixMultiply(const Ti *A, const Ti *B, int M, int K, int N)
{
  std::vector<To> result(M * N, 0);

  for (int i = 0; i < M; ++i)
  {
    for (int j = 0; j < N; ++j)
    {
      float sum = 0;
      for (int k = 0; k < K; ++k)
      {
        sum += (float)A[i * K + k] * (float)B[k * N + j];
      }
      result[i * N + j] = sum;
    }
  }

  return result;
}

static const char *get_dims_string(rknn_matmul_tensor_attr *attr)
{
  if (!attr->n_dims)
  {
    return "()";
  }
  static char dims_str[128];
  memset(&dims_str[0], 0, sizeof(dims_str));
  sprintf(&dims_str[0], "(%d", attr->dims[0]);
  for (uint32_t i = 1; i < attr->n_dims; ++i)
  {
    int idx = strlen(dims_str);
    sprintf(&dims_str[idx], ", %d", attr->dims[i]);
  }
  strcat(&dims_str[0], ")");
  return dims_str;
}

static void dump_matmul_tensor_attr(rknn_matmul_tensor_attr *attr)
{
  printf("  name=%s, dims=%s, size=%d, type=%s\n", attr->name, get_dims_string(attr), attr->size,
         get_type_string(attr->type));
}

static int8_t get_virt_addr_int4(void *virt_addr, int index)
{
  int8_t int4 = 0;
  if (index % 2 == 0)
  {
    int4 = (((int8_t *)virt_addr)[index / 2] >> 4) & 0xf;
  }
  else
  {
    int4 = (((int8_t *)virt_addr)[index / 2]) & 0xf;
  }
  if (int4 & 0x8)
  {
    int4 = int4 | 0xf0;
  }
  return int4;
}

static void dump_matmul_tensor(rknn_tensor_mem *tensor, rknn_matmul_tensor_attr *attr)
{
  printf("  %s%s:\n", attr->name, get_dims_string(attr));
  // normal layout
  if (attr->n_dims == 2)
  {
    for (uint32_t i = 0; i < attr->dims[0]; ++i)
    {
      for (uint32_t j = 0; j < attr->dims[1]; ++j)
      {
        void *virt_addr = (void *)((size_t)tensor->virt_addr + tensor->offset);
        if (attr->type == RKNN_TENSOR_INT8)
        {
          printf(" %4d", ((int8_t *)virt_addr)[i * attr->dims[1] + j]);
        }
        else if (attr->type == RKNN_TENSOR_INT32)
        {
          printf(" %6d", ((int32_t *)virt_addr)[i * attr->dims[1] + j]);
        }
        else if (attr->type == RKNN_TENSOR_FLOAT16)
        {
          printf(" %5.2f", (float)(((float16 *)virt_addr)[i * attr->dims[1] + j]));
        }
        else if (attr->type == RKNN_TENSOR_FLOAT32)
        {
          printf(" %5.2f", ((float *)virt_addr)[i * attr->dims[1] + j]);
        }
        else if (attr->type == RKNN_TENSOR_INT16)
        {
          printf(" %d", ((int16_t *)virt_addr)[i * attr->dims[1] + j]);
        }
        else if (attr->type == RKNN_TENSOR_INT4)
        {
          int index = i * attr->dims[1] + j;
          int8_t int4 = get_virt_addr_int4(virt_addr, index);
          printf("%d ", int4);
        }
      }
      printf("\n");
    }
    printf("\n");
  }
  // perf layout
  else if (attr->n_dims == 3)
  {
    for (uint32_t i = 0; i < attr->dims[0]; ++i)
    {
      for (uint32_t j = 0; j < attr->dims[1]; ++j)
      {
        for (uint32_t k = 0; k < attr->dims[2]; ++k)
        {
          void *virt_addr = (void *)((size_t)tensor->virt_addr + tensor->offset);
          if (attr->type == RKNN_TENSOR_INT4)
          {
            int index = (i * attr->dims[1] + j) * attr->dims[2] + k;
            int8_t int4 = get_virt_addr_int4(virt_addr, index);
            printf("%d ", int4);
          }
          else if (attr->type == RKNN_TENSOR_INT8)
          {
            printf(" %4d ", ((int8_t *)virt_addr)[(i * attr->dims[1] + j) * attr->dims[2] + k]);
          }
          else if (attr->type == RKNN_TENSOR_INT16)
          {
            printf(" %6d ", ((int16_t *)virt_addr)[(i * attr->dims[1] + j) * attr->dims[2] + k]);
          }
          else if (attr->type == RKNN_TENSOR_INT32)
          {
            printf(" %6d ", ((int32_t *)virt_addr)[(i * attr->dims[1] + j) * attr->dims[2] + k]);
          }
          else if (attr->type == RKNN_TENSOR_FLOAT16)
          {
            printf(" %5.2f ", (float)(((float16 *)virt_addr)[(i * attr->dims[1] + j) * attr->dims[2] + k]));
          }
          else if (attr->type == RKNN_TENSOR_FLOAT32)
          {
            printf(" %5.2f ", ((float *)virt_addr)[(i * attr->dims[1] + j) * attr->dims[2] + k]);
          }
        }
        printf("\n");
      }
      printf("\n");
    }
  }
  // native layout
  else if (attr->n_dims == 4)
  {
    // N / 16
    for (uint32_t n = 0; n < attr->dims[0]; ++n)
    {
      // K / 32
      for (uint32_t k = 0; k < attr->dims[1]; ++k)
      {
        // 16
        for (uint32_t nn = 0; nn < attr->dims[2]; ++nn)
        {
          // 32
          for (uint32_t kk = 0; kk < attr->dims[3]; kk++)
          {
            void *virt_addr = (void *)((size_t)tensor->virt_addr + tensor->offset);
            if (attr->type == RKNN_TENSOR_INT4)
            {
              int index = ((n * attr->dims[1] + k) * attr->dims[2] + nn) * attr->dims[3] + kk;
              int8_t int4 = get_virt_addr_int4(virt_addr, index);
              printf("%d ", int4);
            }
            else if (attr->type == RKNN_TENSOR_INT8)
            {
              printf(" %4d ",
                     ((int8_t *)virt_addr)[((n * attr->dims[1] + k) * attr->dims[2] + nn) * attr->dims[3] + kk]);
            }
            else if (attr->type == RKNN_TENSOR_INT32)
            {
              printf(" %6d ",
                     ((int32_t *)virt_addr)[((n * attr->dims[1] + k) * attr->dims[2] + nn) * attr->dims[3] + kk]);
            }
            else if (attr->type == RKNN_TENSOR_FLOAT16)
            {
              printf(
                  " %5.2f ",
                  (float)(((float16 *)virt_addr)[((n * attr->dims[1] + k) * attr->dims[2] + nn) * attr->dims[3] + kk]));
            }
            else if (attr->type == RKNN_TENSOR_FLOAT32)
            {
              printf(" %5.2f ",
                     ((float *)virt_addr)[((n * attr->dims[1] + k) * attr->dims[2] + nn) * attr->dims[3] + kk]);
            }
          }
          printf("\n");
        }
        printf("\n");
      }
      printf("\n");
    }
  }
}

static void print_usage(char *argv[])
{
  printf("Usage:\n%s <matmul_type> <M> <K> <N> <B_layout> <AC_layout> <loop_count>\n", argv[0]);
  printf("\tmatmul_type = 1: RKNN_FLOAT16_MM_FLOAT16_TO_FLOAT32\n");
  printf("\tmatmul_type = 2: RKNN_INT8_MM_INT8_TO_INT32\n");
  printf("\tmatmul_type = 10: RKNN_INT4_MM_INT4_TO_INT16\n");
  printf("Example: A = [4,64], B = [64,32], int8 matmul test command as followed:\n");
  printf("%s 2 4 64 32\n", argv[0]);
}

int main(int argc, char *argv[])
{
  if (argc < 5)
  {
    print_usage(argv);
    return -1;
  }
  int loop_count = 10;
  rknn_matmul_type matmul_type = (rknn_matmul_type)atoi(argv[1]);
  if (matmul_type != RKNN_INT8_MM_INT8_TO_INT32 && matmul_type != RKNN_FLOAT16_MM_FLOAT16_TO_FLOAT32 &&
      matmul_type != RKNN_INT4_MM_INT4_TO_INT16)
  {
    fprintf(stderr, "invalid matmul_type: %d, required matmul_type =1/2/10!\n", matmul_type);
    print_usage(argv);
    return -1;
  }

  int32_t M = atoi(argv[2]);
  int32_t K = atoi(argv[3]);
  int32_t N = atoi(argv[4]);

  // request normal or native layout for B
  int B_layout = 0;
  if (argc > 5)
  {
    B_layout = atoi(argv[5]);
  }

  // request normal or perf layout for A and C
  int AC_layout = 0;
  if (argc > 6)
  {
    AC_layout = atoi(argv[6]);
  }

  if (argc > 7)
  {
    loop_count = atoi(argv[7]);
  }

  printf("MatMul matmul_type = %s, M = %d, K = %d, N = %d, B_layout = %d, AC_layout = %d\n",
         get_matmul_type_string(matmul_type), M, K, N, B_layout, AC_layout);

  rknn_matmul_ctx ctx;

  rknn_matmul_info info;
  memset(&info, 0, sizeof(rknn_matmul_info));
  info.M = M;
  info.K = K;
  info.N = N;
  info.type = matmul_type;
  info.B_layout = B_layout;
  info.AC_layout = AC_layout;

  rknn_matmul_io_attr io_attr;
  memset(&io_attr, 0, sizeof(rknn_matmul_io_attr));

  int ret = rknn_matmul_create(&ctx, &info, &io_attr);
  if (ret < 0)
  {
    fprintf(stderr, "rknn_matmul_create fail! ret=%d\n", ret);
    return -1;
  }

  void *A_Matrix = nullptr;
  void *B_Matrix = nullptr;
  void *C_Matrix = nullptr;
  int type_bytes = 1;
  if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
  {
    type_bytes = 1;
    A_Matrix = malloc(M * K);
    B_Matrix = malloc(K * N);
    C_Matrix = malloc(M * N * sizeof(int16_t));

    // generate int4 A buffer
    int8_t *A_int8_Matrix = (int8_t *)A_Matrix;
    int8_t *B_int8_Matrix = (int8_t *)B_Matrix;
    generate_random_buffer(A_int8_Matrix, M * K, {-8, 7});
    generate_random_buffer(B_int8_Matrix, K * N, {-8, 7});
  }
  else if (info.type == RKNN_INT8_MM_INT8_TO_INT32)
  {
    type_bytes = 1;
    A_Matrix = malloc(M * K);
    B_Matrix = malloc(K * N);
    C_Matrix = malloc(M * N * sizeof(int32_t));

    // generate int8 A buffer
    int8_t *A_int8_Matrix = (int8_t *)A_Matrix;
    int8_t *B_int8_Matrix = (int8_t *)B_Matrix;
    generate_random_buffer(A_int8_Matrix, M * K, {-128, 127});
    generate_random_buffer(B_int8_Matrix, K * N, {-128, 127});
  }
  else if (info.type == RKNN_FLOAT16_MM_FLOAT16_TO_FLOAT32)
  {
    type_bytes = 2;
    A_Matrix = malloc(M * K * type_bytes);
    B_Matrix = malloc(K * N * type_bytes);
    C_Matrix = malloc(M * N * sizeof(float));

    // generate int16 A buffer
    float16 *A_float16_Matrix = (float16 *)A_Matrix;
    float16 *B_float16_Matrix = (float16 *)B_Matrix;
    generate_random_buffer(A_float16_Matrix, M * K, {-1.f, 1.f});
    generate_random_buffer(B_float16_Matrix, K * N, {-1.f, 1.f});
  }
  else
  {
    fprintf(stderr, "unsupported data type: %d\n", info.type);
    return -1;
  }
  printf("input/output matmul tensor attribute:\n");
  dump_matmul_tensor_attr(&io_attr.A);
  dump_matmul_tensor_attr(&io_attr.B);
  dump_matmul_tensor_attr(&io_attr.C);

  // Create A
  rknn_tensor_mem *A = rknn_create_mem(ctx, io_attr.A.size);
  if (A == NULL)
  {
    fprintf(stderr, "rknn_create_mem fail!\n");
    return -1;
  }

  // Create B
  rknn_tensor_mem *B = rknn_create_mem(ctx, io_attr.B.size);
  if (B == NULL)
  {
    fprintf(stderr, "rknn_create_mem fail!\n");
    return -1;
  }

  // A matrix
  // normal layout
  uint32_t aii = 0;
  if (info.AC_layout == 0)
  {
    if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
    {
      int8_t *A_int8_Matrix = (int8_t *)A_Matrix;
      for (uint32_t i = 0; i < io_attr.A.dims[1]; ++i)
      {
        for (uint32_t j = 0; j < io_attr.A.dims[0]; ++j)
        {
          // 外面传进来的是int8模拟的int4数据
          int8_t int4 = A_int8_Matrix[aii++] & 0xf;
          int number = i * io_attr.A.dims[0] + j;
          if (number % 2 == 0)
          {
            ((int8_t *)A->virt_addr)[number / 2] = int4 << 4;
          }
          else
          {
            int8_t temp = ((int8_t *)A->virt_addr)[number / 2];
            int8_t result = temp | int4;
            ((int8_t *)A->virt_addr)[number / 2] = result;
          }
        }
      }
    }
    else
    {
      memcpy(A->virt_addr, A_Matrix, M * K * type_bytes);
    }
  }
  else
  {
    //  perf  layout: [K1, M, subK]
    int32_t subK = io_attr.A.dims[2];
    if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
    {
      norm_layout_to_perf_layout<int8_t, int8_t>(static_cast<int8_t *>(A_Matrix), static_cast<int8_t *>(A->virt_addr), M,
                                                 K, subK, true);
    }
    else if (info.type == RKNN_INT8_MM_INT8_TO_INT32)
    {
      norm_layout_to_perf_layout<int8_t, int8_t>(static_cast<int8_t *>(A_Matrix), static_cast<int8_t *>(A->virt_addr), M,
                                                 K, subK, false);
    }
    else
    {
      norm_layout_to_perf_layout<float16, float16>(static_cast<float16 *>(A_Matrix), static_cast<float16 *>(A->virt_addr),
                                                   M, K, subK, false);
    }
  }

  // B matrix
  // normal layout
  uint32_t bii = 0;
  if (info.B_layout == 0)
  {
    if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
    {
      int8_t *B_int8_Matrix = (int8_t *)B_Matrix;
      for (uint32_t i = 0; i < io_attr.B.dims[1]; ++i)
      {
        for (uint32_t j = 0; j < io_attr.B.dims[0]; ++j)
        {
          // 外面传进来的是int8模拟的int4数据
          int8_t int4 = B_int8_Matrix[bii++] & 0xf;
          int number = i * io_attr.B.dims[0] + j;
          if (number % 2 == 0)
          {
            ((int8_t *)B->virt_addr)[number / 2] = int4 << 4;
          }
          else
          {
            int8_t temp = ((int8_t *)B->virt_addr)[number / 2];
            int8_t result = temp | int4;
            ((int8_t *)B->virt_addr)[number / 2] = result;
          }
        }
      }
    }
    else
    {
      memcpy(B->virt_addr, B_Matrix, K * N * type_bytes);
    }
  }
  else
  {
    // native layout: [N1, K1, subN, subK]
    int32_t subN = io_attr.B.dims[2];
    int32_t subK = io_attr.B.dims[3];
    if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
    {
      norm_layout_to_native_layout<int8_t, int8_t>(static_cast<int8_t *>(B_Matrix), static_cast<int8_t *>(B->virt_addr),
                                                   K, N, subN, subK, true);
    }
    else if (info.type == RKNN_INT8_MM_INT8_TO_INT32)
    {
      norm_layout_to_native_layout<int8_t, int8_t>(static_cast<int8_t *>(B_Matrix), static_cast<int8_t *>(B->virt_addr),
                                                   K, N, subN, subK, false);
    }
    else
    {
      norm_layout_to_native_layout<float16, float16>(static_cast<float16 *>(B_Matrix),
                                                     static_cast<float16 *>(B->virt_addr), K, N, subN, subK, false);
    }
  }

  // Create C
  rknn_tensor_mem *C = rknn_create_mem(ctx, io_attr.C.size);
  if (C == NULL)
  {
    fprintf(stderr, "rknn_create_mem fail!\n");
    return -1;
  }

  // Set A
  ret = rknn_matmul_set_io_mem(ctx, A, &io_attr.A);
  if (ret < 0)
  {
    fprintf(stderr, "rknn_matmul_set_io_mem fail! ret=%d\n", ret);
    return -1;
  }

  // Set B
  ret = rknn_matmul_set_io_mem(ctx, B, &io_attr.B);
  if (ret < 0)
  {
    fprintf(stderr, "rknn_matmul_set_io_mem fail! ret=%d\n", ret);
    return -1;
  }

  // Set C
  ret = rknn_matmul_set_io_mem(ctx, C, &io_attr.C);
  if (ret < 0)
  {
    fprintf(stderr, "rknn_matmul_set_io_mem fail! ret=%d\n", ret);
    return -1;
  }

  // Run
  printf("Begin perf ...\n");
  for (int i = 0; i < loop_count; ++i)
  {
    int64_t start_us = getCurrentTimeUs();
    ret = rknn_matmul_run(ctx);
    int64_t elapse_us = getCurrentTimeUs() - start_us;
    if (ret < 0)
    {
      printf("rknn_matmul_run error %d\n", ret);
      return -1;
    }
    printf("%4d: Elapse Time = %.2fms, FPS = %.2f\n", i, elapse_us / 1000.f, 1000.f * 1000.f / elapse_us);
  }

  // Dump A/B/C tensors
  printf("matmul tensors:\n");
  dump_matmul_tensor(A, &io_attr.A);
  dump_matmul_tensor(B, &io_attr.B);
  dump_matmul_tensor(C, &io_attr.C);

  // compare NPU res vs CPU res

  if (info.type == RKNN_INT4_MM_INT4_TO_INT16)
  {
    int16_t *npu_res_ptr = (int16_t *)C->virt_addr;
    if (info.AC_layout == 1)
    {
      int32_t N_remain = io_attr.C.dims[0];
      int32_t subN = io_attr.C.dims[2];
      perf_layout_to_norm_layout(npu_res_ptr, (int16_t *)C_Matrix, M, N, N_remain, subN);
      npu_res_ptr = (int16_t *)C_Matrix;
    }
    std::vector<int16_t> npu_res(npu_res_ptr, npu_res_ptr + M * N);

    std::vector<int16_t> cpu_res;
    cpu_res.reserve(M * N);
    cpu_res = matrixMultiply<int8_t, int16_t>((const int8_t *)A_Matrix, (const int8_t *)B_Matrix, M, K, N);

    if (arraysEqual<int16_t>(cpu_res, npu_res))
    {
      printf("int4 matmul result is correct\n");
      ret = 0;
    }
    else
    {
      printf("int4 matmul result is wrong\n");
      ret = -1;
    }
  }
  else if (info.type == RKNN_INT8_MM_INT8_TO_INT32)
  {
    int32_t *npu_res_ptr = (int32_t *)C->virt_addr;
    if (info.AC_layout == 1)
    {
      int32_t N_remain = io_attr.C.dims[0];
      int32_t subN = io_attr.C.dims[2];
      perf_layout_to_norm_layout(npu_res_ptr, (int32_t *)C_Matrix, M, N, N_remain, subN);
      npu_res_ptr = (int32_t *)C_Matrix;
    }
    std::vector<int32_t> npu_res(npu_res_ptr, npu_res_ptr + M * N);

    std::vector<int32_t> cpu_res;
    cpu_res.reserve(M * N);
    cpu_res = matrixMultiply<int8_t, int32_t>((const int8_t *)A_Matrix, (const int8_t *)B_Matrix, M, K, N);

    if (arraysEqual<int32_t>(cpu_res, npu_res))
    {
      printf("int8 matmul result is correct\n");
      ret = 0;
    }
    else
    {
      printf("int8 matmul result is wrong\n");
      ret = -1;
    }
  }
  else if (info.type == RKNN_FLOAT16_MM_FLOAT16_TO_FLOAT32)
  {
    float *npu_res_ptr = (float *)C->virt_addr;
    if (info.AC_layout == 1)
    {
      int32_t N_remain = io_attr.C.dims[0];
      int32_t subN = io_attr.C.dims[2];
      perf_layout_to_norm_layout(npu_res_ptr, (float *)C_Matrix, M, N, N_remain, subN);
      npu_res_ptr = (float *)C_Matrix;
    }
    std::vector<float> npu_res(npu_res_ptr, npu_res_ptr + M * N);

    // calculate cpu res
    std::vector<float> cpu_res;
    cpu_res.reserve(M * N);
    cpu_res = matrixMultiply<float16, float>((const float16 *)A_Matrix, (const float16 *)B_Matrix, M, K, N);

    if (arraysCosineSimilarity<float>(cpu_res, npu_res))
    {
      printf("fp16 matmul result is correct\n");
      ret = 0;
    }
    else
    {
      printf("fp16 matmul result is wrong\n");
      ret = -1;
    }
  }

  // destroy
  rknn_destroy_mem(ctx, A);
  rknn_destroy_mem(ctx, B);
  rknn_destroy_mem(ctx, C);

  rknn_matmul_destroy(ctx);

  // clean data
  if (A_Matrix)
  {
    free(A_Matrix);
  }
  if (B_Matrix)
  {
    free(B_Matrix);
  }
  if (C_Matrix)
  {
    free(C_Matrix);
  }

  return ret;
}