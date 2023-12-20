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
double a=0.8; // accessibilité
double k=100000; //tonne
double Emax=30000; // tonne/pirogue/an 
double c=6.935; // capture en tonne/an/pirogue
double lambda=987000; // coût en cfa de sortie par pirogue par an
double g=0.1; // proportion du capital perdue dû à l'inflation
double umax=200;

// u[0] et u[1] sont respectivement le contrôle prix du poisson en tonne
// et variation du nombre de sorties de pirogues

void dynamics(double * x, double *u, double * image)
{
  image[0]=r*x[0]*(1-x[0]/k)-((a*c*x[2])/Emax)*x[0];
  image[1]=u[0]*((a*c*x[2])/Emax)*x[0] - lambda*x[2] - g*x[1];
  image[2]=u[1];

  //cout<< " dynamique renvoie "<<image[0]<< " "<<image[1]<<endl;
}

inline void jacobian(double *x, double *u , double ** jacob)
{
	jacob[0][0]=r*(1-x[0]/k)-r*x[0]/k-((a*c*x[2])/Emax);
	jacob[0][1]=0;
  jacob[0][2]=-((a*c)/Emax)*x[0];

	jacob[1][0]=u[0]*((a*c*x[2])/Emax);
	jacob[1][1]=-g;
  jacob[1][2]=u[0]*((a*c)/Emax)*x[0] -lambda;

  jacob[2][0]=0;
	jacob[2][1]=0;
  jacob[2][2]=0;
}
inline void localDynBounds(double * x, double * res)
{
  res[0]=abs(r*x[0]*(1-x[0]/k)-((a*c*x[2])/Emax)*x[0]);
  res[1]=abs(((a*c*x[2])/Emax)*x[0] - lambda*x[2] - g*x[1]);
  res[2]=umax;
}

#endif /* VIAB2D_H_ */
