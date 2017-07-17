<!---
IMPORTANT
=========
This README.md is displayed in the WebStore as well as within Jarvis app
Please do not change the structure of this file
Fill-in Description, Usage & Author sections
Make sure to rename the [en] folder into the language code your plugin is written in (ex: fr, es, de, it...)
For multi-language plugin:
- clone the language directory and translate commands/functions.sh
- optionally write the Description / Usage sections in several languages
-->
## Tuto pour pouvoir utilisé mpack si vous voulez envoyer la liste par Email
Il faut configurer le fichier ssmtp.conf:
`nano /etc/ssmpt/ssmtp.conf`
Puis le configurer en ajoutant c'est quelques lignes avec vos infos (là c'est pour gmail).
Dans le config.sh ce n'est pas important si ce n'est pas la même adresse que ci dessous car c'est celle du config.sh qui serra prise en compte !!!
root=adresse@gmail.com
mailhub=smtp.gmail.com:587
hostname=raspberry
AuthUser=adresse@gmail.com
AuthPass=MotDePasseGmail
FromLineOverride=YES
UseSTARTTLS=YES
Puis sauvegarder : Ctrl+X puis O pour oui et entrer

## mettre ce plugin avant jarvis-FREE-sms si vous voulez envoyer la liste par SMS...

## Description
Gestion de la liste des prêts personnel avec rappel si oublie, paramètrable dans config.sh

## Usage
```
You: Ajoute le CD du mariage à mes prêts
jarvis: A quelle date avez vous prêté Ajoute le CD du mariage à mes  ? aujourd'hui ?
You: oui
jarvis: Je l'enregistre à la date aujourd'hui...
jarvis: A qui l'avez-vous preté ?
You: mon papa
jarvis: ok c'est bien noté !

You: Ajoute clé de 8  à mes prêts
jarvis: A quelle date avez vous prêté Ajoute clé de 8 à mes  ? aujourd'hui ?
You: non
jarvis: A quelle date je l'enregistre ?
You: le 12 juin
jarvis: vous me demandez d'enregistrer le 12 juin 2017 c'est bien ça ?
You: oui
jarvis: A qui l'avez vous prêté ?
You: mon voisin jacques
jarvis: ok c'est bien noté !

Si le nombre de jour inscrit dans la variable $RAPPEL_FAIRE_COURSES du ficghier config.sh est déppasé il y a un rappel par jour quand il reçoit l'ordre du trigger...
Jarvis: Hé !? ça fait 12 jours que tu n'aurais pas fait les courses... !?
Jarvis:Pense à supprimer la liste c'est tu l'as fait depuis...


jarvis: Hé !? ça fait 63 jours soit depuis le lundi 15 mai 2017 que tu aurais prété:
jarvis: perceuse sans fil , à pierre
jarvis: Penses à le récupérer et à l'effacer de la liste des prêts.

```

## Author
[JB-Hallez] (https://github.com/Jean-Bernard-Hallez/jarvis-mes-prets)