/*! \file  testZermelo.h
 *
 *
 *  \author: A. D�silles, LATSRE
 *  \brief  Fichier contant la d�finition d'un mod�le de viabilit� pour les tests
 *
 *  Ce fichier  contient les d�finitions  de tous les �l�ments qui d�crivent un
 *  un probl�me de viabilit� concret et  qui sont consid�r�s comme
 *  param�tres par le code; Ce fichier repr�sente ainsi une interface d'entr�e primitive pour le code.
 *
 *  Les �l�ments principaux d�finis ici  sont :
 *    -la  dynamique f(t,x,u)
 *    -les contraintes:
 *      -# sur l'�tat k(t,x)
 *      -# sur le controles U(x)
 *    - la cible c(t,x)
 *    -les fonctions d�finissant l'objectif  d'un probl�me d'optimisation
 *      -# fonction l(t,x,u)
 *      -# fonction m(t,x,u)
 *    - diff�rentes options d�finissant plus pr�cis�ment la nature du probl�me � r�soudre
 *    - diff�rentes options d�finissance la m�thode num�rique � utiliser
 *
 *    Voir plus loins dans les commentaires  du fichier la d�finition de chaque fonction et de chaque param�tre
 *
 *
 *
 */

#include <math.h>
#include <algorithm>
//#include <stdlib>

#ifndef MODEL_H_
#define MODEL_H_

/*
 * Some model specific parameters can be defined here
 */
double r=0.9;
double a=0.8;
double k=10560;
double lambda=98700; // 987000;
double g=0.1;
double q=0.0001;
// bornes contraintes
double B_min=1000; // borne min ensemble des contraintes sur B
double C_min=34252025;//342520250; // borne min ensemble des contraintes sur C

void dynamics(double * x, double *u, double * image)
{
  image[0]=r*x[0]*(1-x[0]/k)-(a*q*u[0])*x[0]; // variation de la biomasse
  image[1]=u[1]*(a*q*u[0])*x[0] - lambda*u[0] - g*x[1];  // capital de la pêche

  //cout<< " dynamique renvoie "<<image[0]<< " "<<image[1]<<endl;
}

inline void jacobian(double *x, double *u , double ** jacob)
{
	jacob[0][0]=r*(1-x[0]/k)-r*x[0]/k-(a*q*u[0]);
	jacob[0][1]=0;

	jacob[1][0]=u[1]*(a*q*u[0]);
	jacob[1][1]= - g;

}

inline void localDynBounds(double * x, double * res)
{
  res[0]=abs(r*x[0]*(1-x[0]/k)-(a*q)*x[0]);
  res[1]=abs((a*q)*x[0] - lambda  - g*x[1]);
}

/*!
* This function defines the set K for admissible  states
 * @param x state variable
 * @return  value that caraterise the constraints set
 */
inline double constraintsX( double * x )
{
double res = (x[0] >= B_min   & x[1] >= C_min)?1.0:PLUS_INF;
return res;
}

#endif /* VIAB2D_H_ */