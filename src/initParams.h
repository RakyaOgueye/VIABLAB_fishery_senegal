/*
 * initParams.h
 *
 *  Created on: 24 août 2018
 *      Author: anna_desilles
 */

#ifndef SRC_INITPARAMS_H_
#define SRC_INITPARAMS_H_

#include "../include/defs.h"
#include "../include/ParametersManager.h"

ParametersManager * initParams(gridParams &gp, algoViabiParams &avp, controlParams &cp,systemParams &sp, int nbOmpThreads);
ParametersManager * initParams(gridParams &gp, algoViabiParams &avp, controlParams &cp,systemParams &sp, int nbOmpThreads)
{

	cout<< " initialization of parameter manager\n";
	ParametersManager * pm = new ParametersManager(&gp, &avp, &cp, &sp, nbOmpThreads, paramsFile);

	if(dynamics)
	{
		sp.DYNAMICS=&dynamics;
	}
	else
	{
		sp.DYNAMICS=&dynamics_default;
	}
	if(sp.DYN_TYPE == 4)
	{
		sp.DYNAMICS=&dynamics_hybrid;
	}

	switch(sp.DYN_TYPE)
	{
	case 2:
	{
		sp.COMPUTE_LC=0.0;
		sp.COMPUTE_MF=0.0;
		sp.LIP=1.0;
		sp.MF=1.0;
		break;
	}
	case 3:
	{
		sp.COMPUTE_LC=0.0;
		sp.COMPUTE_MF=0.0;
		sp.LIP=1.0;
		sp.MF=1.0;
		break;
	}
	}
	if(constraintsX)
	{
		sp.CONSTR_X = &constraintsX;
	}
	else
	{
		sp.CONSTR_X = &constraintsX_default;
	}

	if(constraintsXU)
		{
			sp.CONSTR_XU = &constraintsXU;
		}
		else
		{
			sp.CONSTR_XU = &constraintsXU_default;
		}
	if(jacobian)
	{
		sp.JACOBIAN=&jacobian;
	}
	else
	{
		sp.JACOBIAN=&jacobian_default;
	}
	if(localDynBounds)
	{
		sp.LOCAL_DYN_BOUNDS=&localDynBounds;
	}
	else
	{
		sp.LOCAL_DYN_BOUNDS=&localDynBounds_default;
	}
	if(m)
	{
		sp.M_FUNC=&m;
	}
	else
	{
		sp.M_FUNC=&m_default;
	}
	if(l)
	{
		sp.L_FUNC=&l;
	}
	else
	{
		sp.L_FUNC=&l_default;
	}
	if(target)
	{
		sp.TARGET=&target;
	}
	else
	{
		sp.TARGET=&target_default;
	}


	if(l_fd)
	{
		sp.L_FUNC_FD=&l_fd;
	}
	else
	{
		sp.L_FUNC_FD=&l_fd_default;
	}


	if(target_fd)
	{
		sp.TARGET_FD=&target_fd;
	}
	else
	{
		sp.TARGET_FD=&target_fd_default;
	}
	if(constraintsXU_fd)
		sp.CONSTR_XU_fd = &constraintsXU_fd;
	else
		sp.CONSTR_XU_fd  =NULL;
	if(dynamics_fd)
		sp.DYNAMICS_FD = &dynamics_fd;
	else
		sp.DYNAMICS_FD = NULL;
	if(dynamics_tych_fd)
		sp.DYNAMICS_TYCH_FD = &dynamics_tych_fd;
	else
		sp.DYNAMICS_TYCH_FD = NULL;
	if(constraintsX_fd)
		sp.CONSTR_X_fd = &constraintsX_fd;
	else
		sp.CONSTR_X_fd = NULL;
	if(dynConstraintsForTraj)
		sp.DYN_CONSTR_FOR_TRAJ = &dynConstraintsForTraj;
	else
		sp.DYN_CONSTR_FOR_TRAJ = &dynConstraintsForTraj_default;

	if(constraintsXUY_fd)
		sp.MU_FUNC_FD = &constraintsXUY_fd;
	else
		sp.MU_FUNC_FD = &constraintsXUY_fd_default;
	/*
	 * Initialisation des paramètres de systèmes dynamique
	 * Ici toutes les valeurs sont par defaut, non utilisés
	 */

	return pm;

}


#endif /* SRC_INITPARAMS_H_ */
