#include "ChaosTB.h"
#include <iostream>
using namespace std;
int main()
{
//  计算Lyapunov指数谱
	ChaosTB obj(5,1);                            // 5-五维系统  1-Lyapunov指数谱
	double yinit[5] = {0.0,0.0,0.5,1.0,0.0};     // 初始条件
	double tau = 0.001;                          // 积分时间 间隔
	int steps = 100;                             // 正交化步数
	double transtime = 1000;
	double totaltime = 1500;
	double range[3] = {2.0,6.0,0.01};            // 控制参数变化范围 {parm_min,param_max,pas_incrementation}
	obj.spectrumsQR(range,yinit,tau,steps,transtime,totaltime,"ly.dat");
	cout<<"Completed!"<<endl;

//  计算分叉图
//	ChaosTB objbif(5,2);                // 2-分叉图
//	double yinit[5] = {0.0,0.0,0.5,1.0,0.0};
//	double tau = 0.001;                 // 积分时间 间隔
//	double transtime = 400;
//	double stabletime = 1000;
//	int npoint = 30;
//	double range[3] = {2.0,6.0,0.01};
//	objbif.bifurcation(range,yinit,tau,2,0,npoint,transtime,stabletime,"bif.dat",1);  // 1-系统的维度 
//	cout<<"Completed!"<<endl;
	
	return 0;
	
}

	
