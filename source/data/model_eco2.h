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

#ifndef RAKYA_H_
#define RAKYA_H_

/*
 * Some model specific parameters can be defined here
 */
// toutes les valeurs ont été divisées par 100 pour faciliter le calcul
double r=0.15;
double k=100000;  // tonnes
//double alpha = 0.1144 ; //
double a = 0.8;
double p = 542025 ;   //fcfa
double c1 = 0.3 ;  //tonnes/an
double c2 = 0.5 ; //tonnes/an
double g = 0.002 ;


//double u1max = 0.3;
//double u2max = 0.5;
//double u3max = 20000000;
//x[0] quantité de poissons x[1] effort de peche variant entre 0 et 1 représentant 
//la proportion des poissons présents attrappés
//par les pêcheurs 1, idem pour pêcheurs 2
//u[0] l'effort de pêche des 1, idem avec les 2
//u[2] les subventions

void dynamics(double * x, double *u, double * image)
{
  image[0]=  r*x[0]*(1-x[0]/k)-min(a*c1*u[0]+a*c2*u[1],1.0)*x[0];
  image[1]=  u[2]*(a*c1*u[0]+a*c2*u[1])*x[0] - p*(u[0] + u[1]) -g*x[1];
  
  //cout<< " dynamique renvoie "<<image[0]<< " "<<image[1]<<endl;
}

inline void jacobian(double *x, double *u , double ** jacob)
{

	jacob[0][0]=r*(1-x[0]/k)-r*x[0]/k-min(a*c1*u[0]+a*c2*u[1],1.0);
	jacob[0][1]=0;

	jacob[1][0]=u[2]*(a*c1*u[0]+a*c2*u[1]);
	jacob[1][1]=-g;

}
inline void localDynBounds(double * x, double * res)
{
  res[0]=abs(r*x[0]*(1-x[0]/k)-min(a*c1+a*c2,1.0)*x[0]);
  res[1]=abs((a*c1+a*c2)*x[0] - p - g*x[1]);

}

#endif /* VIAB2D_H_ */
