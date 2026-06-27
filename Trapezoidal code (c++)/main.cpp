#include<iostream>
#include<cmath>
using namespace std;
double f(double x)       
{ double a=1/(1+x*x);
    return a;}
int main()
{ int n,i;        
    double a,b,h,sum=0,integral;    
    cout<<"Enter the limits of integration,\nInitial limit,a=";   
    cin>>a;
    cout<<"Final limit,\n b=";
    cin>>b;
    cout<<"Enter the no. of subintervals,\n n=";            
    cin>>n;    
    double x[n+1],y[n+1];    
    h=(b-a)/n;               
    for (i=0;i<=n;i++)            
    { x[i]=a+i*h;          
        y[i]=f(x[i]);}
    for (i=1;i<n;i++)           
    {sum=sum+h*y[i];}
    integral=h/2.0*(y[0]+y[n])+sum;       
    cout<<"The definite integral  is "<<integral<<endl;
    return 0;}