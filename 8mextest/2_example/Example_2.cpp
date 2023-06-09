#include "mex.h"
#include <iostream>
#include "add.h"
#include "sub.h"
#include "mul.h"
#include "div.h"
#include "SimpleMath.h"
#include "Eigen/Dense"
//函数入口
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    mexPrintf("输入参数个数：%d\n", nrhs);
    if (nrhs != 3) {        //判断输入参数个数
        mexPrintf("Input numbers must be 3\n");
        return;
    }
    /********************************************************/
    //获取参数输入的标量
    float a = (double)mxGetScalar(prhs[0]);
    float b = (double)mxGetScalar(prhs[1]);
    float add_result = add(a, b);
    float sub_result = sub(a, b);
    float mul_result = mul(a, b);
    float div_result = div(a, b);
    //创建输出标量的指针
    plhs[0] = mxCreateDoubleScalar((double)add_result);
    plhs[1] = mxCreateDoubleScalar((double)sub_result);
    plhs[2] = mxCreateDoubleScalar((double)mul_result);
    plhs[3] = mxCreateDoubleScalar((double)div_result);
    /********************************************************/
    SimpleMath simple_math{};
    //获取输入的矩阵指针
    double* input_matrix = mxGetDoubles(prhs[2]);
    //获取输入的矩阵的行数和列数
    size_t row = mxGetM(prhs[2]);
    size_t col = mxGetN(prhs[2]);
    mexPrintf("输入矩阵行数: %d, 输入矩阵列数: %d\n", row, col);
    simple_math.a = input_matrix[0];
    simple_math.b = input_matrix[1];
    add_result = simple_math.add();
    sub_result = simple_math.sub();
    mul_result = simple_math.mul();
    div_result = simple_math.div();
    //创建2x2的输出实数矩阵
    plhs[4] = mxCreateDoubleMatrix(2, 2, mxREAL);
    //获取矩阵的指针并进行赋值
    double* out_matrix = mxGetDoubles(plhs[4]);
    out_matrix[0] = add_result;
    out_matrix[1] = sub_result;
    out_matrix[2] = mul_result;
    out_matrix[3] = div_result;
    /********************************************************/
    Eigen::MatrixXd A(2, 3);
    Eigen::MatrixXd B(3, 2);
    A << 1, 2, 3, 4, 5, 6;
    B << 1, 2, 3, 4, 5, 6;
    Eigen::MatrixXd C = A * B;
    std::cout << "C: \n" << C << std::endl;
    plhs[5] = mxCreateDoubleMatrix(2, 2, mxREAL);
    double* eigen_out = mxGetDoubles(plhs[5]);
    eigen_out[0] = C(0, 0);
    eigen_out[1] = C(1, 0);
    eigen_out[2] = C(0, 1);
    eigen_out[3] = C(1, 1);
    mexPrintf("输出结果个数：%d\n", nlhs);
}