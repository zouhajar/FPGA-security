

# Projet FPGA : Chiffrement des Signaux ECG avec ASCON

## Présentation

Ce projet met en place un système de chiffrement sécurisé pour des signaux ECG en exploitant un FPGA.
Les trames ECG sont lues depuis un fichier CSV, transmises via UART à une carte FPGA où elles sont chiffrées avec l’algorithme **ASCON** (chiffrement léger et sécurisé). Elles sont ensuite renvoyées vers un script Python pour déchiffrement et visualisation.

## Architecture

* **FPGA (Pynq-Z2)** : implémentation de l’algorithme ASCON et FSM de pilotage
* **UART FSM** : gestion de la communication série
* **Python** : récupération des signaux, déchiffrement et affichage des ECG

## Étapes principales

1. Programmation du FPGA avec le bitstream fourni (`FPGA_ASCON128/`).
2. Connexion du module UART sur le port PMOD A et liaison USB avec l’ordinateur.
3. Exécution du script `communication_fpga.py` (répertoire `communication_python/`) pour l’interface utilisateur.

## Fonctionnalités

* Lecture des ECG depuis un fichier CSV
* Transmission au FPGA pour chiffrement
* Réception et déchiffrement via Python
* Visualisation et comparaison des signaux avant/après chiffrement

## Prérequis

* Carte FPGA **Pynq-Z2**
* Logiciel **Vivado** pour la programmation
* Python 3 avec bibliothèques : `pyserial`, `matplotlib`, `pandas`

