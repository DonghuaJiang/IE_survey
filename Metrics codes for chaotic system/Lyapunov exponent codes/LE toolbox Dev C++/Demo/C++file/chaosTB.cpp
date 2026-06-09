#include "ChaosTB.h"
#include <fstream>
#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;

const int ChaosTB::nvarf = 4;	//对不同阶数的系统要修改此值。

ChaosTB::ChaosTB
(int ndim,int _flag)
{
	//构造函数，ndim表示系统的维数，flag表示构建不同的对象。
	//flag=1表示通过此对象可计算laypunov指数谱。
	//flag=2表示通过此对象画分岔图。
	flag = _flag;
	NDIM = ndim;
	if(flag == 1)	//flag为1时候表示spectrumsQR
	{
		NTOTAL = ndim*(ndim+1);
		//正交化时候所用的空间。
		prod1 = new double[NDIM];
		prod2 = new double[NDIM];

		//runge kutta算法中用到的中间变量。
		F1 = new double[NTOTAL];
		F2 = new double[NTOTAL];
		F3 = new double[NTOTAL];
		F4 = new double[NTOTAL];
		xtemp = new double[NTOTAL];

		Y = new double*[NDIM];
		Jaco = new double*[NDIM];
		tempres = new double*[NDIM];
		for(int i = 0; i < NDIM; i++)
		{
			Y[i] = new double[NDIM];
			Jaco[i] = new double[NDIM];
			tempres[i] = new double[NDIM];
		}
	}
	else if(flag == 2)	//flag为2表示bifurcation。
	{
		NTOTAL = ndim;
		//正交化时候所用的空间。
		prod1 = NULL;
		prod2 = NULL;

		//runge kutta算法中用到的中间变量。
		F1 = new double[NTOTAL];
		F2 = new double[NTOTAL];
		F3 = new double[NTOTAL];
		F4 = new double[NTOTAL];
		xtemp = new double[NTOTAL];

		Y = NULL;
		Jaco = NULL;
		tempres = NULL;
	}	
}

ChaosTB::~ChaosTB()
{
	int i;

	if(flag == 1)
	{
		delete []prod1;
		delete []prod2;
		delete []F1;
		delete []F2;
		delete []F3;
		delete []F4;
		delete []xtemp;

		for(i = 0; i < NDIM; i++)
		{
			delete []Y[i];
			delete []Jaco[i];
			delete []tempres[i];
		}
		delete []Y;
		delete []Jaco;
		delete []tempres;
	}
	else if(flag == 2)
	{
		delete []F1;
		delete []F2;
		delete []F3;
		delete []F4;
		delete []xtemp;
	}
}


void  ChaosTB::runge_kutta (double *yin, double tau, double param, double *yout)
{
	//4阶runge kutta法求解微分方程。
	double half_tau = 0.5*tau;
	int i = 0;

	// 判断系统是否有界
	for(i = 0; i < NTOTAL; i++)
	{
		if(fabs(yin[i]) > 1e80)
		{
			cout<<"The system are unbounded!"<<endl;
			exit(0);
		}
	}
	
	model(yin,param,F1);
	for(i = 0; i < NTOTAL; i++)
		xtemp[i] = yin[i]+half_tau*F1[i];
	model(xtemp,param,F2);
	for(i = 0; i < NTOTAL; i++)
		xtemp[i] = yin[i]+half_tau*F2[i];
	model(xtemp,param,F3);
	for(i = 0; i < NTOTAL; i++)
		xtemp[i] = yin[i]+tau*F3[i];
	model(xtemp,param,F4);
	for(i = 0; i < NTOTAL; i++)
		yout[i] = yin[i]+tau/6.0*(F1[i]+F4[i]+2.0*F3[i]+2.0*F2[i]);
}


void ChaosTB::spectrumsQR(double* _range,double*init,double tau,int _steps,double transtime,double totaltime,const char * filename)
{
	int i,j,k;
	int param_num;
	double range_min = _range[0];
	double range_max = _range[1];
	double range_interval = _range[2];

	int count = int((range_max-range_min)/range_interval+1);
	double * range = new double[count];
	for(i = 0; i < count; i++)
		range[i] = range_min+i*range_interval;
	//range[]中存放count个参数值，下面对每一个参数值来计算lyapunov指数。
	double ** spectrum = new double*[NDIM];
	for(i = 0; i < NDIM; i++)
		spectrum[i] = new double[count];

	double *yinit = new double[NDIM];	//NDIM阶方程的初始值。
	for(i = 0; i < NDIM; i++)
		yinit[i] = init[i];

	double *yout = new double[NDIM*(NDIM+1)];		//包括变分方程的总共NDIM*(NDIM+1)的空间。
	//yin中保存NDIM*(NDIM+1)的值，其中前NDIM为方程的，后面是变分方程的。
	double *yin = new double[NDIM*(NDIM+1)];	//NDIM*(NDIM+1)=20
	//构建一个NDIM*NDIM的正交矩阵，也就是单位阵。

	double **orthyin;	//保存每次正交化的值。
	double **Q,**R;
	//orthyout=new double*[NDIM];		//orthyout实际是保存正交化后的临时值。
	orthyin = new double*[NDIM];
	Q = new double *[NDIM];
	R = new double *[NDIM];
	for(i = 0; i < NDIM; i++)
	{
		//orthyout[i]=new double[NDIM];
		orthyin[i] = new double[NDIM];
		Q[i] = new double[NDIM];
		R[i] = new double[NDIM];
	}
	double tstep = tau;		              //时间步长。
	double wholetimes = (totaltime/tau);	
	int steps = _steps;			          //每次演化的步数。
	int iteratetimes = int(wholetimes/steps);
	double *mod = new double[NDIM];	      //每次的模值。
	double *lp = new double[NDIM];
	//double *lpold=new double[NDIM];
	double tstart = 0;                    //时间初始值。

	for(param_num = 0; param_num < count; param_num++)
	{
		//初始化的正交基是单位矩阵。
		for(i = 0; i < NDIM; i++)
		{
			for(j = 0; j < NDIM; j++)
			{
				R[i][j] = 0;
				if(i == j)
					orthyin[i][j] = 1;
				else
					orthyin[i][j] = 0;
			}
		}
		//赋予初值，前NDIM为yin的初值，后面是正交的向量。
		//求解方程及其变分方程，同NDIM*(NDIM+1)个变量，将其写入到一个向量中。
		for(i = 0; i < NDIM; i++)
			yin[i] = yinit[i];
		for(i = 0; i < NDIM; i++)
			for(j = 0; j < NDIM; j++)
				yin[NDIM+NDIM*i+j] = orthyin[j][i];

		tstart = 0;                                             //时间初始值。
		
		for(i = 0; i < NDIM; i++)
			lp[i] = 0;
				
		//**********************************************
		for(i = 0; i < int(transtime/tau);i++)
		{
			runge_kutta(yin,tstep,range[param_num],yout);      //runge_kutta求解。
			for(k = 0; k < NDIM; k++)
				yin[k] = yout[k];	                           //所以yout只是用来作为每次迭代的输出临时保存。
		}
		//选择上面的结果作为初值，进行计算……
		//#############################
		for(i = 0; i < iteratetimes; i++)
		{
			for(j = 0; j < steps; j++)
			{
				//此处调用runge kutta法传人的参数没意义。
				//系统的参数在model中更改。
				runge_kutta(yin,tstep,range[param_num],yout);//runge_kutta求解。
				for(k = 0; k < NDIM*(NDIM+1);k++)
					yin[k] = yout[k];
			}
			tstart = tstart+steps*tstep;	//更新当前的时间。
			//将变分方程恢复成矩阵形式。
			for(j = 0; j < NDIM; j++)
				for(k = 0; k < NDIM; k++)
					orthyin[k][j] = yin[NDIM+j*NDIM+k];
			//此处改为QR分解：

			//正交化，但不单位化。
			//GS(orthyin,orthyout,NDIM);
			QR(orthyin,NDIM,Q,R);
			//Q作为初值，而R取对角元素。

			//按列对正交化的结果取模，此数据用来计算lyapunov指数。
			for(j = 0; j < NDIM; j++)
			{
				/*
				double temp=0;
				for(k=0;k<NDIM;k++)
					temp+=orthyout[k][j]*orthyout[k][j];
				temp=sqrt(temp);
				mod[j]=temp;	//mod of every column.
				for(k=0;k<NDIM;k++)
				{
					//此处将正交的矩阵单位化
					orthyin[k][j]=orthyout[k][j]/mod[j];
				}
				//
				*/
				lp[j] = lp[j]+log(R[j][j]);
			}
						
			//然后将正交的矩阵再按列转换为向量。
			for(j = 0; j < NDIM; j++)
				for(k = 0;k < NDIM; k++)
				{
					yin[NDIM+NDIM*j+k] = Q[k][j];
				}
		}
		//###################################
		cout<<setiosflags(ios::left);
		cout<<setw(5)<<range[param_num]<<":\t";
		//#################
		/*
		for(j=0;j<NDIM;j++)
			lpold[j]=lp[j];

		//以下二重循环对指数排序。。
		for(j=0;j<NDIM-1;j++)
		{
			int temp_index=j;

			for(k=j+1;k<NDIM;k++)
			{
				if(lpold[k]>lpold[temp_index])
				{
					temp_index=k;
					
				}

			}
			double temp_max=lpold[temp_index];
			lpold[temp_index]=lpold[j];
			lpold[j]=temp_max;
		}
		//#################
		*/
		for(i = 0; i < NDIM; i++)
		{
				spectrum[i][param_num] = lp[i]/tstart;
				cout<<setw(8)<<spectrum[i][param_num]<<'\t';
		}
		cout<<endl;
	}
	cout<<"Saving data...."<<endl;
	//将随时间的演进数据保存到文件。
	ofstream fout;
	fout.open(filename);
	for(i = 0; i < count; i++)
	{
		fout<<range[i]<<'\t';
		for(j = 0; j < NDIM-1; j++)
			fout<<spectrum[j][i]<<'\t';
		fout<<spectrum[j][i]<<endl;
	}
   	fout.close();
	//回收资源……
	//***********************************

	delete []yinit;
	delete []yout;
	delete []yin;
	delete []mod;
	delete []lp;
	//delete []lpold;
	for(i = 0; i < NDIM; i++)
	{
		//delete [] orthyout[i];
		delete [] orthyin[i];
		delete [] spectrum[i];
	}
	//delete [] orthyout;
	delete []orthyin;
	delete []spectrum;
	//***********************************
}

void ChaosTB::bifurcation(double *_range,double * init,double tau,int _base,int _yaxis,int npoint,double transtime,double stabletime,const char * filename,int direction)
{	
	int i,j,k;

	double range_min = _range[0];		//参数最小值。
	double range_max = _range[1];		//参数最大值。
	double interval = _range[2];		//步长。
	int count = int((range_max-range_min)/interval+1);	//分岔图中参数个数。
	cout<<count<<endl;
	double * range = new double[count];
	for(i = 0; i < count; i++)
		range[i] = range_min+interval*i;

	double * yin = new double[NDIM];
	double * yinit = new double[NDIM];
	double * yout = new double[NDIM];
	
	for(i = 0; i < NDIM; i++)
		yinit[i] = init[i];

	double tstep = tau;
	int trans_iteration = int(transtime/tstep);
	int stable_iteration = int(stabletime/tstep);
	int base = _base;
	int yaxis = _yaxis;	//y轴
	//要求base与yaixs都小于NDIM，且不同。
	int point_num = npoint;//每个参数对应30个点。
	//保存分岔数据的点。
	double ** bifdata = new double*[point_num];
	for(i = 0; i < point_num; i++)
		bifdata[i] = new double[count];
	for(i = 0; i < point_num; i++)
		for(int j = 0;j < count; j++)
			bifdata[i][j] = 0;
 
	double ** chaosdata = new double*[NDIM];
	for(i = 0; i < NDIM; i++)
		chaosdata[i] = new double[stable_iteration];

	for(i = 0; i < count; i++)
	{
		cout.precision(8);
		cout<<range[i]<<endl;
		for(j = 0;j < NDIM; j++)
			yin[j] = yinit[j];

		//每次循环计算一个参数对应的分岔数据。
		for(j = 0; j < trans_iteration; j++)
		{
			runge_kutta(yin,tstep,range[i],yout);
			for(k = 0; k < NDIM; k++)
				yin[k] = yout[k];
		}
		for(j = 0; j < stable_iteration; j++)
		{
			//认为已经在吸引子上了，获得对于此参数的混沌数据。
			runge_kutta(yin,tstep,range[i],yout);
			for(k = 0; k < NDIM; k++)
			{
				yin[k] = yout[k];
				chaosdata[k][j] = yin[k];
			}
		}
		//现在tempchaosdata中包含所有的chaos数据，
		//对其进行处理来获得分岔图数据。
		
		//参考数据是tempchaosdata[base][..]
		double tempavg = 0;
		for(j = 0; j < stable_iteration; j++)
			tempavg += chaosdata[base][j];
		tempavg = tempavg/stable_iteration;	    //数据的平均值。

		double d1;
		double d2;
		int point_count = 0;	                //直到point_num就可以跳出循环。

		double yfit;
		for(j = 0; j < stable_iteration-1; j++)
		{
			//在tempchaosdata[base]中搜索穿过temp的数据。
			d1 = chaosdata[base][j]-tempavg;
			d2 = chaosdata[base][j+1]-tempavg;
			
			if(d1*d2 <= 0)
			{
				if(direction == 0)
				{
					if(d1 < 0)
					{
						yfit = polyfit(chaosdata[base][j],chaosdata[base][j+1],chaosdata[yaxis][j],chaosdata[yaxis][j+1],tempavg);
						bifdata[point_count][i] = yfit;
						point_count++;
					}
				}	
				else if(direction == 1)
				{
					if(d1 > 0)
					{
						yfit = polyfit(chaosdata[base][j],chaosdata[base][j+1],chaosdata[yaxis][j],chaosdata[yaxis][j+1],tempavg);
						bifdata[point_count][i] = yfit;
						point_count++;
					}
				}
				else if(direction == 2)
				{
					//当d1,d2异号时，进行线性差值。
					yfit = polyfit(chaosdata[base][j],chaosdata[base][j+1],chaosdata[yaxis][j],chaosdata[yaxis][j+1],tempavg);
					bifdata[point_count][i] = yfit;
					point_count++;
				}
				else
				{
					cout<<"direction number must 0,1 or 2"<<endl;
					exit(0);
				}
			}
			if(point_count >= point_num)
				break;
		}
		//当然，有可能退出时候不到point_num个点，那样应该将stabletime取大些。
		if(point_count<point_num)
		{
			cout<<"Warning: you should use more stabletime for parameter "<<range[i]<<endl;
		}
		
	}
	//将bifdata数据保存为文件，同时保存参数值。
	cout<<"Saving data...."<<endl;
	ofstream fout(filename);
	for(i = 0; i < count; i++)
	{
		fout.precision(8);
		fout<<range[i]<<'\t';
		for(j = 0; j < point_num; j++)
			fout<<bifdata[j][i]<<'\t';
		fout<<endl;
	}
	fout.close();
		
	//回收空间
	delete []yinit;
	
	delete []yin;
	delete []yout;
	delete []range;
	for(i = 0; i < point_num; i++)
		delete []bifdata[i];
	delete []bifdata;
	for(i = 0; i < NDIM; i++)
		delete []chaosdata[i];
	delete []chaosdata;
}


double ChaosTB::polyfit(double x1,double x2,double y1,double y2,double x0)
{
	double a = (y2-y1)/(x2-x1);	
	double b = y1-a*x1;
	return (a*x0+b);
}


void ChaosTB::QR(double **A,int n,double **Q,double**R)
{
	//QR 分解。
	int k,m,j;
	double temp = 0;
	for(k = 0; k < n; k++)
	{
		temp = 0;
		for(m = 0;m < n; m++)
			temp += A[m][k]*A[m][k];
		R[k][k] = sqrt(temp);
		if(R[k][k] == 0)
		{
			cout<<"R singular"<<endl;
			exit(1);
		}
		for(m = 0; m < n; m++)
			Q[m][k] = A[m][k]/R[k][k];
		for(j = k+1; j < n; j++)
		{
			temp = 0;
			for(m = 0; m < n; m++)
				temp += Q[m][k]*A[m][j];
			R[k][j] = temp;
			for(m = 0; m < n; m++)
				A[m][j] = A[m][j]-R[k][j]*Q[m][k];
		}
	}
}

//此函数正交化输入的n阶矩阵V，
//正交的结果放到out中。
void ChaosTB::GS(double** V,double** out,int n)
{
	double eps = 1e-10;
	int i,j,k;
	double temp = 0;
	//首先计算第一列的模。
	for(i = 0; i < n; i++)
	{
		out[i][0] = V[i][0];
		temp += out[i][0]*out[i][0];
	}
	prod1[0] = temp+eps;

	//从第二列开始做正交化。
	for(i = 1; i < n; i++)                               //分别对于第i列正交化。
	{
		for(k = 0; k < i; k++)                           //对前i列计算a1'*vi,a2'*vi...
		{
			temp = 0;
			for(j = 0; j < n; j++)
				temp += out[j][k]*V[j][i];               //(*(out+n*j+k))*(*(V+j*n+i));
			prod2[k] = temp;                             //对每个vi有不同的prod2
		}
		//下面对i列的每一个元计算正交后的值。
		for(k = 0; k < n; k++)	//k表示行。
		{
			temp = 0;
			temp = V[k][i];                              //*(V+k*n+i);//V[k][i];
			for(j = 0; j < i; j++)
			{
				temp += -prod2[j]/prod1[j]*out[k][j];    //(*(out+k*n+j));//out[k][j];
			}
			out[k][i] = temp;
		}

		temp = 0;
		for(k = 0; k < n; k++)
			temp += out[k][i]*out[k][i];                 //(*(out+k*n+i))*(*(out+k*n+i));
		prod1[i] = temp+eps;
	}
	
}


//矩阵的乘积函数，将动态分配的n*n矩阵Jaco与Y之积存入到res空间中。
void ChaosTB::multi(double **Jaco,double **Y,int n,double** res)
{
	int i,j,k;

	for(i = 0; i < n;i++)
		for(j = 0; j < n; j++)
		{
			double temp = 0;
			for(k = 0; k < n; k++)
				temp += Jaco[i][k]*Y[k][j];
			res[i][j] = temp;
		}
}


void ChaosTB::model(double*y,double param,double *deriv)
{
//**********************************************
//******对不同的模型就只需要修改下面部分的表达式。
//###################################
	double bb = 6;
	double cc = 6;
	double dd = 6;
	double aa = param;  //definition of the control parameter versus which the lyapunov exponent will be ploted

	deriv[0] = aa*y[1]+dd*y[4];
	deriv[1] = -aa*y[0]+cc*y[2]+(bb*y[3])*(1+y[0]*y[0]);
	deriv[2] = cc*(y[3]-y[1]);
	deriv[3] = (-bb*y[1])*(1+y[0]*y[0])-cc*y[2];
	deriv[4] = -dd*y[0];

    //系统的雅克比矩阵 
	double temp_Jaco[][5] = {{0,aa,0,0,dd},
							 {-aa+bb*y[3]*(2*y[0]),0,cc,bb*(1+y[0]*y[0]),0},
							 {0,-cc,0,cc,0},
                             {(-bb*y[1])*(2*y[0]),-bb*(1+y[0]*y[0]),-cc,0,0},
                             {-dd,0,0,0,0}}; 
                            
//下面的部分不用更改。注意：求Lyapunov指数谱时需要下面的一段程序；但是求分叉图时需注释掉
	int i,j;
	for(i = 0; i < NDIM; i++)
		for(j = 0; j < NDIM; j++)
			Y[j][i] = y[NDIM+i*NDIM+j];
	
	for(i = 0; i < NDIM; i++)
		for(j = 0; j < NDIM; j++)
			Jaco[i][j] = temp_Jaco[i][j];

	multi(Jaco,Y,NDIM,tempres);		//矩阵乘积，存放在tempres空间。
	//下面将NDIM*NDIM矩阵按列存入到输入向量中。
	for(i = 0; i < NDIM; i++)
		for(j = 0; j < NDIM; j++)
		{
			deriv[NDIM+i*NDIM+j] = tempres[j][i];
		}
}

