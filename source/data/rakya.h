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
double r=0.15;
double a=0.8;
double k=100000; //tonne
double Emax=20000;//17337.5; // tonne/pirogue/an (2500pirogues x 0.019t x 365)
double c=6.935; // capture en tonne/an (0.019t x 365)
double p=542025; // coût en cfa de sortie en un an
double g=0.002;
double u2max = 0.2;


void dynamics(double * x, double *u, double * image)
{
  image[0]=r*x[0]*(1-x[0]/k)-((a*c*x[1])/Emax)*x[0];
  image[1]=u[0]*((a*c*x[1])/Emax)*x[0] - p*x[1] - g*x[2];
  

  //cout<< " dynamique renvoie "<<image[0]<< " "<<image[1]<<endl;
}

inline void jacobian(double *x, double *u , double ** jacob)
{
	jacob[0][0]=r*(1-x[0]/k)-r*x[0]/k-((a*c*x[1])/Emax);
	jacob[0][1]=-((a*c)/Emax)*x[0];
  jacob[0][2]=0;

	jacob[1][0]=u[0]*((a*c*x[1])/Emax);
	jacob[1][1]=u[0]*((a*c)/Emax)*x[0] - p;
  jacob[1][2]=-g;

 // jacob[2][0]=0;
	//jacob[2][1]=0;
  //jacob[2][2]=0;

 
}
inline void localDynBounds(double * x, double * res)
{
  res[0]=abs(r*x[0]*(1-x[0]/k)-((a*c*x[1])/Emax)*x[0]);
  res[1]=abs(((a*c*x[1])/Emax)*x[0] - p*x[1] - g*x[2]);
  
}

#endif /* VIAB2D_H_ */
