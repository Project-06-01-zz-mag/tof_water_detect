#include "water_detect_ffc.h"

  waterdetectflag_t water_detect::tof_water_detect(waterdetectrawdata_t *waterdetectrawdata) {
    static float dpfs_old = 0;
    static float dpfs_date_cache[WAT_WIN_SIZE] = {0};
    static uint16_t cnt_for_stdvariance = 0;
    static uint16_t water_cnt = 0;
    static uint16_t grould_cnt = 0;
    static bool water_flag_last = false;

    waterdetectflag_t waterdetectflag_temp;

    // when fly state change ,reset filter and cache of stdvariance
    if(waterdetectrawdata->fly_state_last != waterdetectrawdata->fly_state_now)
    {
      waterdetectflag_temp.fly_state_change = true;
      tofdpfsFilter_.reset(0.f);
      cnt_for_stdvariance = 0;
      waterdetectrawdata->time_state_change = waterdetectrawdata->time_input;
    }
    waterdetectrawdata->fly_state_last  = waterdetectrawdata->fly_state_now;

    if((waterdetectrawdata->time_input - waterdetectrawdata->time_state_change) < 2.0f)
    {
        water_cnt = 0;
    }
    if (waterdetectrawdata->dpfs_new < -70 || waterdetectrawdata->dpfs_new > -5) {
      waterdetectrawdata->dpfs_new = dpfs_old;
    } else {
      dpfs_old = waterdetectrawdata->dpfs_new;
    }

    if( waterdetectrawdata->fly_state_now == false)
    {
      waterdetectrawdata->dpfs_new = 0;
      dpfs_old =0 ;
    }
    waterdetectflag_temp.hpf_dpfs = tofdpfsFilter_.filter(waterdetectrawdata->dpfs_new);

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

    //get stdvariance
    for (uint16_t i = 0; i < WAT_WIN_SIZE; i++) {
      waterdetectflag_temp.variance += pow(dpfs_date_cache[i] - waterdetectflag_temp.mean, 2) / WAT_WIN_SIZE;
    }
    waterdetectflag_temp.stdvariance = sqrt(waterdetectflag_temp.variance);

    waterdetectflag_temp.waterflag = water_flag_last;
    if(waterdetectflag_temp.waterflag  == false)
    {
      //judge water flag
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
    }
    else
    {
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

    water_flag_last = waterdetectflag_temp.waterflag ;

    return waterdetectflag_temp;
  }