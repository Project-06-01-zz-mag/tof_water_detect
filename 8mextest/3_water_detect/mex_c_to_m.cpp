#include "mex.h"
#include "water_detect_ffc.h"

//函数入口
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    //mexPrintf("输入参数个数：%d\n",nrhs);
    static TofProcess water_detect_{};
    
    tof_waterdetectflag_input_t waterdetectrawdata_input{};
    static tof_waterdetectflag_output_t waterdetectflag_output{};

    tof_diff_input_t tof_diff_input_{};
    static tof_diff_output_t tof_diff_output_{};

    tof_diff_input_.update_t = (double)mxGetScalar(prhs[0]);
    tof_diff_input_.tof_distance = (float)mxGetScalar(prhs[1]);

    tof_diff_output_ = water_detect_.tof_differential(tof_diff_input_); 

    waterdetectrawdata_input.cancel_waterflag = (double)tof_diff_output_.cancel_waterflag_times;
    waterdetectrawdata_input.time_input = (double)mxGetScalar(prhs[2]);
    waterdetectrawdata_input.fly_state_now = (bool)mxGetScalar(prhs[3]);
    waterdetectrawdata_input.dpfs_new = (double)mxGetScalar(prhs[4]);
    waterdetectrawdata_input.fly_height_last = (double)mxGetScalar(prhs[5]);
    
    waterdetectflag_output = water_detect_.tof_water_detect(waterdetectrawdata_input);

    plhs[0] = mxCreateDoubleScalar((double)waterdetectflag_output.mean);
    plhs[1] = mxCreateDoubleScalar((double)waterdetectflag_output.variance);
    plhs[2] = mxCreateDoubleScalar((double)waterdetectflag_output.stdvariance);
    plhs[3] = mxCreateDoubleScalar((double)waterdetectflag_output.hpf_dpfs);
    plhs[4] = mxCreateDoubleScalar((bool)waterdetectflag_output.waterflag);
    plhs[5] = mxCreateDoubleScalar((bool)waterdetectflag_output.fly_state_change);

    plhs[6] = mxCreateDoubleScalar((float)tof_diff_output_.tof_speed);

    
    //mexPrintf("输出结果个数：%d\n",nlhs);
}