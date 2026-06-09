#ifndef CHAOS_TOOL_BOX
#define CHAOS_TOOL_BOX
//*******************************************************
//*					混沌工具箱 version 1.0
//
//	written by klein, Nankai University, Tian jin, China
//	2005.11
//

class ChaosTB
{
public:
	int NDIM;		         //自治系统的维数。
	int NTOTAL;	 	         //=NDIM*(NDIM+1)。
	ChaosTB(int ndim,int _flag);
	~ChaosTB();

	//4阶runge kutta法求解微分方程，其中x为输入，tao为时间间隔，param为方程中用到的系数，xout为迭代后的输出。
	void  runge_kutta (double *x, double tau, double param, double *xout);

	//将n*n方阵正交化，输出out也要提前分配空间。
	void  GS(double ** V,double **out,int n);
	void  QR(double **A,int n,double **Q,double**R);
	
	//double *init是指向NDIM维数组的初始值指针，double tau是积分时间间隔，int _steps
	//是进行GS正交化的步数，transtime是过渡时间，totaltime是计算指数总时间，filename是保存数据的文件名。
	//spectrums()函数是计算随一个参数变化的lyapunov指数谱
   
    void spectrumsQR(double* _range,double*init,double tau,int _steps,double transtime,double totaltime,const char * filename);
	void bifurcation(double* _range,double* init,double tau,int base,int yaxis,int npoint,double transtime,double stabletime,const char * filename,int direction);
	
private:
	static const int nvarf;	                                                //自治系统中Jacobi矩阵的维数。
	int flag;	                                                            //表示计算的是lyapunov指数还是分岔图。flag=1指数。
	double * prod1;		                                                    //计算laypunov指数正交化时所需。
	double * prod2;
	double * F1,*F2,*F3,*F4,*xtemp;	                                        //求解runge kutta法时候所用的临时变量。
	double **Y,** Jaco,**tempres;	                                        //保存正交矩阵的空间，在计算lyapunov指数时所需。
	//double **A,**Q,**R;
	void model (double *y, double param, double *deriv);
	void multi(double **Jaco,double **Y,int n,double **res);                //两个矩阵的乘积。
	double polyfit(double x1,double x2,double y1,double y2,double x0);  	//线性插值。
};
#endif
