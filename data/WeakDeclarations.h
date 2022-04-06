/*
 * WeakDeclarations.h
 *
 *  Created on: 27 juil. 2021
 *      Author: adesi
 */

#ifndef DATA_WEAKDECLARATIONS_H_
#define DATA_WEAKDECLARATIONS_H_

#include "../include/defs.h"
extern double level;
extern int sortieOKinf[];
extern int sortieOKsup[];
extern double l_Lip;
extern double l_max;
extern int saveSubLevel;
unsigned long long int * initPoints_fd;
double *initValues_fd;
double *initValues;

double  constraintsXU_fd( unsigned long long int * x, unsigned long long int * u ) __attribute__((weak));
void dynamics_tych_fd(unsigned long long int  * x, unsigned long long int *u,unsigned long long int *v, unsigned long long int * image) __attribute__((weak));
double  constraintsX_fd( unsigned long long int * x ) __attribute__((weak));

void dynamics_fd(unsigned long long int  * x, unsigned long long int *u, unsigned long long int * image) __attribute__((weak));
double dynConstraintsForTraj(double * x, double * image) __attribute__((weak));
double  constraintsXUY_fd( unsigned long long int * x, unsigned long long int * u ) __attribute__((weak));
double target_fd (unsigned long long int * x)  __attribute__((weak));
double l_fd(unsigned long long int  * x, unsigned long long int * u )  __attribute__((weak));
double dynConstraintsForTraj_default(double * x, double * image);

double dynConstraintsForTraj_default(double * x, double * image)
{
	return 1.0;
}


inline  double target_fd_default (unsigned long long int * x)
{
	return 0.0;
}

inline double l_fd_default(unsigned long long int  * x, unsigned long long int * u )
{
	return 0.0;
}


inline double  constraintsXUY_fd_default( unsigned long long int * x, unsigned long long int * u )
{
	return -PLUS_INF;
}

#endif /* DATA_WEAKDECLARATIONS_H_ */
