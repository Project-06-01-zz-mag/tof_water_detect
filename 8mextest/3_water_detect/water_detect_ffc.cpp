#include "water_detect_ffc.h"

tof_diff_output_t TofProcess::tof_differential(tof_diff_input_t input) {
  tof_diff_output_t tof_diff_output_;
  static float last_distance = 0;
  static float last_time = 0;
  static double last_cancel_times = 0;
  const float abnormal_down_speed = 2.0;  // max down speed is 2m/s in normal case；

  tof_diff_output_.cancel_waterflag_times = last_cancel_times;

  if (input.tof_distance < 0 || input.tof_distance == 0) {
    last_distance = 0;
    last_time = 0;
    tof_diff_output_.tof_speed = 0;
    tof_diff_output_.cancel_waterflag_times = 0;
  }

  if (last_distance > 0) {
    float diff_time = input.update_t - last_time;
    if (diff_time > 0.04 || diff_time < 0.02) {
      diff_time = 0.03;
    }

    float hight_diff = last_distance - input.tof_distance;

    if (hight_diff > 0) {
      float speed_temp = hight_diff / diff_time;
      if (speed_temp > abnormal_down_speed) {
        tof_diff_output_.cancel_waterflag_times = input.update_t;  // update time
      }
      tof_diff_output_.tof_speed = speed_temp;
    }
  }

  last_cancel_times = tof_diff_output_.cancel_waterflag_times;
  last_distance = input.tof_distance;
  last_time = input.update_t;

  return tof_diff_output_;
}

tof_waterdetectflag_output_t TofProcess::tof_water_detect(tof_waterdetectflag_input_t waterdetectrawdata) {
  static float dpfs_old = 0;
  static float dpfs_date_cache[WAT_WIN_SIZE] = {0};
  static uint16_t cnt_for_stdvariance = 0;
  static uint16_t water_cnt = 0;
  static uint16_t grould_cnt = 0;
  static bool water_flag_last = false;
  static bool fly_state_last = false;
  static double time_state_change = 0;

  tof_waterdetectflag_output_t waterdetectflag_temp;

  // when fly state change ,reset filter and cache of stdvariance
  if (fly_state_last != waterdetectrawdata.fly_state_now) {
    waterdetectflag_temp.fly_state_change = true;
    tofdpfsFilter_.reset(0.f);
    cnt_for_stdvariance = 0;
    time_state_change = waterdetectrawdata.time_input;
  }
  fly_state_last = waterdetectrawdata.fly_state_now;

  if ((waterdetectrawdata.time_input - time_state_change) < 2.0f) {
    water_cnt = 0;
  }

  if (waterdetectrawdata.dpfs_new < -70 || waterdetectrawdata.dpfs_new > -5) {
    waterdetectrawdata.dpfs_new = dpfs_old;
  } else {
    dpfs_old = waterdetectrawdata.dpfs_new;
  }

  if (waterdetectrawdata.fly_state_now == false) {
    waterdetectrawdata.dpfs_new = 0;
    dpfs_old = 0;
  }
  waterdetectflag_temp.hpf_dpfs = tofdpfsFilter_.filter(waterdetectrawdata.dpfs_new);

  if (cnt_for_stdvariance != WAT_WIN_SIZE - 1) {
    dpfs_date_cache[cnt_for_stdvariance] = waterdetectflag_temp.hpf_dpfs;
    cnt_for_stdvariance++;
  } else {
    for (uint16_t i = 1; i < WAT_WIN_SIZE; i++) {
      dpfs_date_cache[i - 1] = dpfs_date_cache[i];
    }
    dpfs_date_cache[WAT_WIN_SIZE - 1] = waterdetectflag_temp.hpf_dpfs;
  }

  // get mean value
  for (uint16_t i = 0; i < WAT_WIN_SIZE; i++) {
    waterdetectflag_temp.mean += dpfs_date_cache[i] / WAT_WIN_SIZE;
  }

  // get stdvariance
  for (uint16_t i = 0; i < WAT_WIN_SIZE; i++) {
    waterdetectflag_temp.variance += pow(dpfs_date_cache[i] - waterdetectflag_temp.mean, 2) / WAT_WIN_SIZE;
  }
  waterdetectflag_temp.stdvariance = sqrt(waterdetectflag_temp.variance);

  waterdetectflag_temp.waterflag = water_flag_last;
  if (waterdetectflag_temp.waterflag == false) {
    // judge water flag
    if (waterdetectflag_temp.stdvariance > WATER_THRESHOLD) {
      if (water_cnt < 1000) {
        water_cnt++;
      }
    } else {
      water_cnt = 0;
    }

    if (water_cnt > WATER_CNT_THRESHOLD) {
      waterdetectflag_temp.waterflag = true;
    }
  } else {
    if (waterdetectflag_temp.stdvariance < GROULD_THRESHOLD) {
      if (grould_cnt < 1000) {
        grould_cnt++;
      }
    } else {
      grould_cnt = 0;
    }

    if (grould_cnt > GROULD_CNT_THRESHOLD) {
      waterdetectflag_temp.waterflag = false;
    }
  }

  // if ((waterdetectrawdata.time_input - waterdetectrawdata.cancel_waterflag) < CANCEL_DELAY_TIME) {
  //   water_cnt = 0;
  //   waterdetectflag_temp.waterflag = false;
  // }

  // if fly close the ground ,the water flag will error
  if (waterdetectrawdata.fly_height_last < 0.3f && waterdetectrawdata.fly_height_last > 0) {
    waterdetectflag_temp.waterflag = false;
    water_cnt = 0;
  }

  water_flag_last = waterdetectflag_temp.waterflag;
  return waterdetectflag_temp;
}