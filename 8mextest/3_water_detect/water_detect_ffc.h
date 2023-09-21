#pragma once
#include "stdio.h"
#include <cmath>

#ifndef __int8_t_defined  
# define __int8_t_defined  
typedef signed char             int8_t;   
typedef short int               int16_t;  
typedef int                     int32_t;  
# if __WORDSIZE == 64  
typedef long int                int64_t;  
# else  
__extension__  
typedef long long int           int64_t;  
# endif  
#endif  
  
  
typedef unsigned char           uint8_t;  
typedef unsigned short int      uint16_t;  
#ifndef __uint32_t_defined  
typedef unsigned int            uint32_t;  
# define __uint32_t_defined  
#endif  
#if __WORDSIZE == 64  
typedef unsigned long int       uint64_t;  
#else  
__extension__  
typedef unsigned long long int  uint64_t;  
#endif  

/**
 * @brief General Digital Filter. Support no more than 10th orders.
 * @author Zhang Haiyang.
 */
template <typename T>
class DigiFilterBase {
 public:
  T b[11] = {0.};
  T a[11] = {0.};
  T x[11] = {0.};
  T y[11] = {0.};
  int N = 0;
  DigiFilterBase() = default;
  void init(int order, const double num[], const double den[]) {
    if (order < 1 || order > 10) {
      return;
    }
    N = order;
    for (int i = 0; i <= N; i++) {
      b[i] = static_cast<T>(num[i]);
      a[i] = static_cast<T>(den[i]);
    }
  }
  T filter(T val) {
    T y0 = 0.;
    for (uint8_t i = N; i > 0; i--) {
      x[i] = x[i - 1];
      y[i] = y[i - 1];
      y0 += b[i] * x[i] - a[i] * y[i];
    }
    x[0] = val;
    y[0] = y0 + b[0] * x[0];
    return y[0];
  }
  const T &output() const {
    return y[0];
  }
  void reset(T val) {
    for (uint8_t i = 0; i <= N; i++) {
      x[i] = y[i] = val;
    }
  }
};

class TofHpfFilter : public DigiFilterBase<float> {
 public:  // Butter_2nd_10Hz_33sps
  static constexpr int N = 2;
  double num[N + 1] = {0.20169205911526, -0.40338411823052, 0.20169205911526};
  double den[N + 1] = {1, 0.392116929473767, 0.198885165934809};

  TofHpfFilter() { init(N, num, den); }
};

static constexpr uint16_t WAT_WIN_SIZE = 30;
static constexpr float WATER_THRESHOLD = 0.3;
static constexpr uint16_t WATER_CNT_THRESHOLD = 30;
static constexpr float GROULD_THRESHOLD = 0.2;
static constexpr uint16_t GROULD_CNT_THRESHOLD = 30;
static constexpr float CANCEL_DELAY_TIME = 0.8;

typedef struct {
  bool fly_state_now;
  float dpfs_new;
  double time_input;
  float fly_height_last;
  double cancel_waterflag;
} tof_waterdetectflag_input_t;

typedef struct {
  bool fly_state_change = false;
  float hpf_dpfs;
  float mean = 0;
  float variance = 0;
  float stdvariance = 0;
  bool waterflag = false;
} tof_waterdetectflag_output_t;

typedef struct {
  double update_t;
  uint16_t phase_tof_raw;
  bool tof_valid;
} tof_diff_input_t;

typedef struct {
  double cancel_waterflag_times;
  float tof_speed;
} tof_diff_output_t;

class TofProcess {
 public:
  tof_waterdetectflag_output_t tof_water_detect(tof_waterdetectflag_input_t waterdetectrawdata);
  tof_diff_output_t tof_differential(tof_diff_input_t input);

 private:
  TofHpfFilter tofdpfsFilter_;
};