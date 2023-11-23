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

#ifndef RAKYA_H_
#define RAKYA_H_

/*
 * Some model specific parameters can be defined here
 */
double r=0.15;
double k=10000;
double u2max = 0.02;
double g=0.002;
double p=826.1; //542025;
//double rakya_u2max = 0.02;
//x[0] quantité de poissons x[1] effort de peche variant entre 0 et 1 représentant 
//la proportion des poissons présents attrappés
//par les pêcheurs 1, idem pour pêcheurs 2
//u[0] variation de l'effort de pêche des 1, idem avec les 2

void dynamics(double * x, double *u, double * image)
{
  image[0]=  r*x[0]*(1-x[0]/k)-min(x[1],1.0)*x[0];
  image[1]=  u[0]*x[1]*x[0] - p*x[1] - g*x[2];
  image[2]=  u[1];
  //cout<< " dynamique renvoie "<<image[0]<< " "<<image[1]<<endl;
}

inline void jacobian(double *x, double *u , double ** jacob)
{

	jacob[0][0]=r*(1-x[0]/k)-r*x[0]/k-min(x[1],1.0);
	jacob[0][1]=x[0];
	jacob[0][2]=0;

	jacob[1][0]=u[0]*x[1];
	jacob[1][1]=u[0]*x[0] - p;
	jacob[1][2]=-g;

	jacob[2][0]=0;
	jacob[2][1]=0;
	jacob[2][2]=0;

}
inline void localDynBounds(double * x, double * res)
{
  res[0]=abs(r*x[0]*(1-x[0]/k)-min(x[1],1.0)*x[0]);
  res[1]=abs((x[1]*x[0]) - p*x[1] - g*x[2]);
  res[2]=u2max;

}

#endif /* VIAB2D_H_ */
