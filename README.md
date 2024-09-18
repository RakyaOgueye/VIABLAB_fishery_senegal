# VIABLAB
VIABLAB  is a numerical lybrary implementing a set of numerical algorithms of mathematical viability theory
It was developped by Anna DESILLES in collaboration with researchers of LASTRE, under direction of Jean-Pierre Aubin. 
The mathematical viability theory allows the analysis of controlled dynamical systems under state constraints. 

The current version of VIABLAB implements the viability kernel algorithm for discrete time and continuous time dynamical systems. 
It conteins also epigraphical algorithms for micro-macro systems. This class of algorithms is adapted to study value functions of 
some optimal control systems, using viability theory approach. 

This librairy was used for different research projects, in different application domains 
(path planning for autonomous vehicles, economic analysys of farm planning under 
soil restauration constraints, etc). 

# FisheryViability

## Installer viabLab sur ubuntu 

On installe dans un premier temps les dependances 
```bash
apt-get install cmake
apt-get install gcc
apt-get install libboost-dev-all
```

se mettre dans le repertoire `VIABLAB/source`

```bash
cmake .
make
```
Une fois le `make` executé la compilation doit avoir produit un executable qu'on peut lancer comme cela :
```
./viabLabExe 
```
VIABLAB s'execute alors sur un modèle pré enregistré. Les résultats du modèle sont à retrouver dans le repertoire `OUTPUT`

## faire tourner un premier modele :

Comme vous avez déjà fait tourner viablab, il faudra refaire la compilation en nettoyant le cache avec `make clean`

1. Ensuite vous pourrez déplacer le fichier `ModelDataInclusion.h` et `model_peche.h` dans `VIABLAB/source/data`
2. Deplacer le fichier `peche.json` dans `VIABLAB/INPUT`
3. lancer la compilation avec `make`
4. executer votre modèle `./viabLabExe`

les resultats sont alors générés dans `OUTPUT` avec le préfix `peche`

## Le fonctionnement générique

creer un fichier `.h` dans `VIABLAB/source/data` qui va contenir les dynamiques du systèmes, les contraintes, *etc.*
creer un fichier `.json` dans `VIABLAB/INPUT` on trouvera les parametres du systèmes, les variables d'état et de controle.

ajouter `string paramsFile = "fichier.json"` et `#include "../data/fichier.h"` dans `VIABLAB/source/data/ModelDataInclusion.h`
Une fois que les fichiers
ont les bon pointeurs, dans le terminal on va dans le répertoire `VIABLAB/source` pour lancer les commandes suivantes :
```bash
make
./viabLabExe 
``` 
Les fichiers résultat sont produits dans `VIABLAB/OUTPUT`sous forme de fichier `.dat`que l'on peut ensuite manipuler avec python ou R. 
