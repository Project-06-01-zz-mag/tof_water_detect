
#include "water_detect_ffc.h"

waterdetectflag_t water_detect::tof_water_detect(waterdetectrawdata_t *waterdetectrawdata) {
    static float dpfs_old = 0;
    static float dpfs_date_cache[WAT_WIN_SIZE] = {0};
    static uint16_t cnt_for_stdvariance = 0;
    static uint16_t water_cnt = 0;

    waterdetectflag_t waterdetectflag_temp;

    // when fly state change ,reset filter and cache of stdvariance
if(waterdetectrawdata->fly_state_last != waterdetectrawdata->fly_state_now)
{
    waterdetectflag_temp.fly_state_change = true;
    tofdpfsFilter_.reset(0.f);
    cnt_for_stdvariance = 0;
}
waterdetectrawdata->fly_state_last  = waterdetectrawdata->fly_state_now;

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

//judge water flag
if (waterdetectflag_temp.stdvariance > STAND_DEV_VALUE_THRESHOLD) {
    if (water_cnt < 1000) {
    water_cnt++;
    }
} else {
    water_cnt = 0;
}

if (water_cnt > WATER_CNT_THRESHOLD) {
    waterdetectflag_temp.waterflag = true;
} else {
    waterdetectflag_temp.waterflag = false;
}

return waterdetectflag_temp;
}

//时间  飞行状态  信号强度  水面识别结果
//ffcprintf("tof_hpf %8.6f %d %8.6f %d\n", t, waterdetectrawdata_.fly_state_now,waterdetectrawdata_.dpfs_new,waterdetectflag_now.waterflag); // for matlab debug
void ParseTof(Devices::mtTimestamp t, const Devices::mtRawRangefinder &raw, bool updated) {

    waterdetectrawdata_.fly_state_now = at_beginning_of_flying;
    waterdetectrawdata_.dpfs_new = raw.attach_info.dpfs;
    waterdetectflag_now = tof_water_detect(&waterdetectrawdata_);
    ffcprintf("tof_hpf %8.6f %d %8.6f %d\n", t, waterdetectrawdata_.fly_state_now,waterdetectrawdata_.dpfs_new,waterdetectflag_now.waterflag); // for matlab debug
    tof_.water_flag = waterdetectflag_now.waterflag;


}