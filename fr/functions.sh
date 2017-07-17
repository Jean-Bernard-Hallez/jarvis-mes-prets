#!/bin/bash
# Here you can define translations to be used in the plugin functions file
# the below code is an sample to be reused:
# 1) uncomment to function below
# 2) replace XXX by your plugin name (short)
# 3) remove and add your own translations
# 4) you can the arguments $2, $3 passed to this function
# 5) in your plugin functions.sh file, use it like this:
#      say "$(pv_myplugin_lang the_answer_is "oui")"
#      => Jarvis: La réponse est oui

#pv_XXX_lang () {
#    case "$1" in
#        i_check) echo "Je regarde...";;
#        the_answer_is) echo "La réponse est $2";;
#    esac
#} 
testprets_chemin() {
testprets_chemin_etape="/home/pi/jarvis/plugins_installed/jarvis-mes-prets/testprets_etape.txt";
testprets_chemin_lu="/home/pi/jarvis/plugins_installed/jarvis-mes-prets/testprets_luaujourdhui.txt"
}

jv_pg_testprets () {
testprets_chemin

if test -e "$testprets_chemin_etape"; then
testprets_compteur=`cat $testprets_chemin_etape`;
else
testprets_compteur="1";
echo "$testprets_compteur" > $testprets_chemin_etape;
fi

if [[ "$order" =~ "commence" ]]; then 
say "Ok on repart à zéro..."
testprets_reset;
jv_pg_testprets;
return;
fi

if [[ "$testprets_compteur" =~ "1" ]]; then 
ajoutepret=$(cat ~/PRET.txt | sed -e 's/ajoute //g' | sed -e 's/à la liste//g' | sed -e 's/à ma liste//g' | sed -e 's/des prêts//g' | sed -e 's/de prêt//g' | sed -e 's/prêts//g' | sed -e 's/  / /g');
# echo "-----$ajoutepret-----"
echo "$ajoutepret" > ~/prelistedesprets.txt;
say "A quelle date avez vous prêté $ajoutepret ? aujourd'hui ?"; 
# sudo rm ~/PRET.txt
testprets_boucle;
# jv_pg_testprets;
return;
fi

# echo "----------$ajoutepret---------------"
if [[ "$ajoutepret" == "" ]]; then
ajoutepret=$(cat ~/PRET.txt | sed -e 's/ajoute //g' | sed -e 's/à la liste//g' | sed -e 's/à ma liste//g' | sed -e 's/des prêts//g' | sed -e 's/de prêt//g' | sed -e 's/prêts//g' | sed -e 's/  / /g');
say "il y a un redemarrage de jarvis, on reprend...";
testprets_compteur=$(( $testprets_compteur - 1 ));
# echo "----------$testprets_compteur---------------"

	if [[ "$testprets_compteur" =~ "0" ]]; then 
	testprets_compteur="1"; 
	echo "$testprets_compteur" > $testprets_chemin_etape;
	fi

echo "$testprets_compteur" > $testprets_chemin_etape;
jv_pg_testprets;
return;
	 
fi


if [[ "$testprets_compteur" =~ "2" ]]; then 
Jour_pret_aujourdhui_court=`date "+%m/%d/%y"`
Jour_pret_aujourdhui_long=`date "+%A %d %B %Y"`
Jour_pret_aujourdhui_sec=`date +%s`
typedepret=`cat ~/prelistedesprets.txt`


	if [[ "$order" =~ "aujourd" ]] || [[ "$order" =~ "oui" ]]; then
	say "Je l'enregistre à la date aujourd'hui..."; 
	echo "$Jour_pret_aujourdhui_court, $typedepret" > ~/prelistedesprets.txt;
	say "A qui l'avez-vous preté ?"
	testprets_boucle;
	return;
	fi;

	if [[ "$order" =~ "non" ]]; then
	say "A quelle date je l'enregistre ?"; 
	return;
	fi;

	if [[ "`echo $order | sed -e "s/\//^ /g" | grep "\^" |  wc -w`" == "3" ]]; then 
	Jour_pret_order_jour=`echo "$order" | cut -d"/" -f1`
	Jour_pret_order_mois_court=`echo "$order" | cut -d"/" -f2`
	Jour_pret_order_annee=`echo "$order" | cut -d"/" -f3`
	Jour_pret_order_court=`echo "$Jour_pret_order_mois_court/$Jour_pret_order_jour/$Jour_pret_order_annee"`
	Jour_pret_order_long=`date -d "$Jour_pret_order_court" "+%B"`
	Jour_pret_order_sec=`date -d "$Jour_pret_order_court" "+%s"`
	say "tu as donc prété le $Jour_pret_order_long $typedepret";
	echo "$Jour_pret_order_court, $typedepret" > ~/prelistedesprets.txt;
	# sudo rm ~/prelistedesprets.txt
	say "A qui l'avez-vous preté ?"
	jv_pg_testprets;	
	return;
	else
	date_utilisateur_pret=`echo "$order" | sed -e "s/le //g" | sed -e "s/au //g" | sed -e "s/pour //g"`
	date_utilisateur_pret_jour=`echo "$date_utilisateur_pret" | cut -d" " -f1`
	date_utilisateur_pret_mois_long=`echo "$date_utilisateur_pret" | cut -d" " -f2`
	date_utilisateur_pret_annee=`echo "$date_utilisateur_pret" | cut -d" " -f3`
	# echo "-----$date_utilisateur_pret-----"
	testlemoisinverse_pret
	# echo "---mois=$date_utilisateur_pret_mois_court---"
	testlejourinverse_pret
	# echo "---jour=$date_utilisateur_pret_jour---"

		if [[ "$date_utilisateur_pret_mois_long" == "" ]]; then
		say "J'ai un problème de reconnaissance avec le mois énnoncée, veuillez reformuler"
		fi

		if [[ "$date_utilisateur_pret_annee" == "" ]]; then
		date_utilisateur_pret_annee_court=`date "+%y"`
		date_utilisateur_pret_annee_long=`date "+%Y"`
		
		else

			if [[ `echo "$date_utilisateur_pret_annee" | wc -c` =~ "5" ]]; then 
			date_utilisateur_pret_annee_long="$date_utilisateur_pret_annee"
			date_utilisateur_pret_annee_court=`echo $date_utilisateur_pret_annee_long | cut -c3-`
			fi

			if [[ `echo "$date_utilisateur_pret_annee" | wc -c` =~ "3" ]]; then 
			date_utilisateur_pret_annee_long="20$date_utilisateur_pret_annee"
			date_utilisateur_pret_annee_court="$date_utilisateur_pret_annee"		
			fi
		fi


# echo "---$date_utilisateur_pret_jour---"

		if [[ `echo "$date_utilisateur_pret_jour" | wc -c` != "3" ]] || [[ "$date_utilisateur_pret_jour" -gt "31" ]] ; then
		say "Il y a une erreur avec le jour détecté... veuillez redonner la date du prêt sous forme jour, mois et éventuellement l'année";
		return;
		fi

# echo "---$date_utilisateur_pret_mois_court---"
		if [[ `echo "$date_utilisateur_pret_mois_court" | wc -c` != "3" ]] || [[ "$date_utilisateur_pret_mois_court" -gt "12" ]] ; then
		say "Il y a une erreur avec le mois détecté... veuillez redonner la date du prêt sous forme jour, mois et éventuellement l'année";
		return;
		fi

# echo "---$date_utilisateur_pret_annee_court--"
		if [[ `echo "$date_utilisateur_pret_annee_court" | wc -c` != "3" ]] || [[ "$date_utilisateur_pret_annee_court" -gt `date "+%y"` ]] ; then
		say "Il y a une erreur avec l'année détecté... veuillez redonner la date du prêt sous forme jour, mois et éventuellement l'année";
		return;	
		fi

	jour_pret_order_court="$date_utilisateur_pret_mois_court/$date_utilisateur_pret_jour/$date_utilisateur_pret_annee_court"
	say "vous me demandez d'enregistrer le $date_utilisateur_pret_jour $date_utilisateur_pret_mois_long $date_utilisateur_pret_annee_long c'est bien ça ?"
	date_utilisateur_pret="$date_utilisateur_pret_mois_court/$date_utilisateur_pret_jour/$date_utilisateur_pret_annee_court"
	echo $jour_pret_order_court > ~/PRET1.txt
	testprets_boucle;
	return;
	fi
return;
fi

if [[ "$testprets_compteur" =~ "3" ]]; then 
	if test -e ~/PRET1.txt; then
		if [[ "$order" =~ "oui" ]]; then 
		date_utilisateur_pret=`cat ~/PRET1.txt`
		echo "$date_utilisateur_pret, $typedepret" > ~/prelistedesprets.txt;
		sudo rm ~/PRET1.txt
		echo "3" > $testprets_chemin_etape;
		say "A qui l'avez vous prêté ?";
		return;
		else
		say "Veuillez me redonner le jour, le mois et l'année du prêt !"
		echo "2" > $testprets_chemin_etape;
		return;
		fi
	fi

typedepret=`cat ~/prelistedesprets.txt`
echo "$typedepret, à $order" >> ~/listedesprets.txt;
say "ok c'est bien noté !"
# sudo rm ~/prelistedesprets.txt
testprets_boucle;
GOTOSORTIPRET="FIN";
testprets_reset;
return;
fi
}

testlemoisinverse_pret() {
if [[ "$date_utilisateur_pret_mois_long" == "janvier" ]]; then
date_utilisateur_pret_mois_court="01"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "fevrier" ]]; then
date_utilisateur_pret_mois_court="02"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "mars" ]]; then
date_utilisateur_pret_mois_court="03"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "avril" ]]; then
date_utilisateur_pret_mois_court="04"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "mai" ]]; then
date_utilisateur_pret_mois_court="05"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "juin" ]]; then
date_utilisateur_pret_mois_court="06"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "juillet" ]]; then
date_utilisateur_pret_mois_court="07"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "aout" ]]; then
date_utilisateur_pret_mois_court="08"
return
fi


if [[ "$date_utilisateur_pret_mois_long" == "septembre" ]]; then
date_utilisateur_pret_mois_court="09"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "octobre" ]]; then
date_utilisateur_pret_mois_court="10"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "novembre" ]]; then
date_utilisateur_pret_mois_court="11"
return
fi

if [[ "$date_utilisateur_pret_mois_long" == "decembre" ]]; then
date_utilisateur_pret_mois_court="12"
return
fi
}

testlejourinverse_pret() {
if [[ "$date_utilisateur_pret_jour" == "1" ]]; then
date_utilisateur_pret_jour="01"
return
fi

if [[ "$date_utilisateur_pret_jour" == "2" ]]; then
date_utilisateur_pret_jour="02"
return
fi

if [[ "$date_utilisateur_pret_jour" == "3" ]]; then
date_utilisateur_pret_jour="03"
return
fi

if [[ "$date_utilisateur_pret_jour" == "4" ]]; then
date_utilisateur_pret_jour="04"
return
fi

if [[ "$date_utilisateur_pret_jour" == "5" ]]; then
date_utilisateur_pret_jour="05"
return
fi

if [[ "$date_utilisateur_pret_jour" == "6" ]]; then
date_utilisateur_pret_jour="06"
return
fi

if [[ "$date_utilisateur_pret_jour" == "7" ]]; then
date_utilisateur_pret_jour="07"
return
fi

if [[ "$date_utilisateur_pret_jour" == "8" ]]; then
date_utilisateur_pret_jour="08"
return
fi

if [[ "$date_utilisateur_pret_jour" == "9" ]]; then
date_utilisateur_pret_jour="09"
return
fi
}

testprets_boucle() {
testprets_compteur=`cat $testprets_chemin_etape`
testprets_compteur=$(( $testprets_compteur + 1 ));
echo "$testprets_compteur" > $testprets_chemin_etape;
# echo "compteur=$testprets_compteur"
}


testprets_reset() {
testprets_chemin
testprets_addition=""
testprets_compteur=""

if test -e $testprets_chemin_etape; then
sudo rm $testprets_chemin_etape
fi

if test -e ~/PRET.txt; then
sudo rm ~/PRET.txt
fi

if test -e ~/PRET1.txt; then
sudo rm ~/PRET1.txt
fi


}

jv_pg_ct_supprime_prettout() {
if test -e /home/pi/listedesprets.txt; then
pretcontien="$(cat ~/listedesprets.txt | uniq | paste -s -d ',' | sed -e 's/,/, /g')" ;
pretcontien_total=`echo $pretcontien | grep -o "," | wc -w`;
pretcontien_total=$(( $pretcontien_total + 1 ));
	if [[ "$pretcontien_total" -gt "1" ]]; then
	say "êtes vous sûr de vouloir supprimer les $pretcontien_total prêts de la listes ?";
	else
	say "êtes vous sûr de vouloir supprimer la listes des prets, il y a 1 ?";
	fi
else
say "Il n'y a atuellement aucune liste de pret...";
GOTOSORTIPRET="Fin"; 
fi
}

jv_pg_ct_supprime_prettout1() {
sudo rm /home/pi/listedesprets.txt;
if test -e /home/pi/listedesprets_dit.txt; then
sudo rm /home/pi/listedesprets_dit.txt
fi
say "Ok, la liste des prets a été effacée...";
}


jv_pg_ct_supprime_pret () {
if [[ "$order" =~ "dernie" ]]; then
lirederliste="$(cat /home/pi/listedesprets.txt | tail -1)";
say "$lirederliste est supprimé de la liste";
sed -i -e  "/$lirederliste/d" /home/pi/listedesprets.txt;
return;
fi

efface="$(cat ~/PRET.txt | sed -e 's/ mes//g' | sed -e 's/ mon//g' | sed -e 's/ ma//g' | sed -e 's/ a//g' | sed -e 's/ de//g')";
# echo "--$efface--"
pretcontien_efface=`grep -o "$efface" /home/pi/listedesprets.txt | wc -w`;
if [[ "$pretcontien_efface" -ge "1" ]]; then
sed -i -e  "/$efface/d" /home/pi/listedesprets.txt;
jv_pg_ct_supprime_pret_ok;
return;
fi


efface1="$(cat ~/PRET.txt | cut -d " " -f1)";
# echo "--$efface1--"
pretcontien_efface=`grep -o "$efface1" /home/pi/listedesprets.txt | wc -w`;
if [[ "$pretcontien_efface" -ge "1" ]]; then
sed -i -e  "/$efface1/d" /home/pi/listedesprets.txt;
jv_pg_ct_supprime_pret_ok;
return;
fi



efface1=`echo $efface | sed 's/.* //'`
# echo "--$efface1--"
pretcontien_efface=`grep -o "$efface1" /home/pi/listedesprets.txt | wc -w`;
if [[ "$pretcontien_efface" -ge "1" ]]; then
sed -i -e  "/$efface1/d" /home/pi/listedesprets.txt;
jv_pg_ct_supprime_pret_ok;
return;
fi

efface1=`echo $efface | awk '{print $(NF-1)}'`
# echo "--$efface1--"
pretcontien_efface=`grep -o "$efface1" /home/pi/listedesprets.txt | wc -w`;
if [[ "$pretcontien_efface" -ge "1" ]]; then
sed -i -e  "/$efface1/d" /home/pi/listedesprets.txt;
jv_pg_ct_supprime_pret_ok
return;
fi

say "désolé je ne trouve pas le prêt $efface1 à supprimer"
}

jv_pg_ct_supprime_pret_ok () {
efface="$(cat ~/PRET.txt | sed -e 's/ mes//g' | sed -e 's/ mon//g' | sed -e 's/ ma//g' | sed -e 's/ a//g' | sed -e 's/ de//g')";
say "$efface est supprimé de la liste des prets";
sudo rm ~/PRET.txt;
}


jv_pg_ct_lis_pret () {
jv_pg_ct_testjour_pret

if test -e /home/pi/listedesprets.txt; then
pretcontien=`cat ~/listedesprets.txt`;
pretcontien_total=`cat /home/pi/listedesprets.txt | wc -l`;

	if [[ "$pretcontien_total" -gt "1" ]]; then
	say "voici les $pretcontien_total prêt le:";
	pretcontien_compte="1"
	jv_pg_ct_lis_pret1
	else
	say "il n'y a que 1 prêt:";
	pretcontien1=`echo $pretcontien | cut -d"," -f1 | date "+%A %d %B %Y"`
	pretcontien=`echo  $pretcontien | cut -d"," -f2- `;
	say "Le $pretcontien1: $pretcontien"
	fi
else
say "la liste des prêts est vide..."
fi
}

jv_pg_ct_lis_pret1 () {
pretcontien=`cat ~/listedesprets.txt | sed -n $pretcontien_compte\p`
say "$pretcontien";
if [[ "$pretcontien_compte" -lt "$pretcontien_total" ]]; then 
pretcontien_compte=$(( $pretcontien_compte + 1 ))
jv_pg_ct_lis_pret1
else
pretcontien_compte=""
return
fi 
}



jv_pg_ct_testjour_pret () {
Jour_pret_aujourdhui=`date +%d`;
if test -e /home/pi/listedespret.txt; then
	Jour_pret_enregis=`date -r ~/listedespret.txt | cut -d" " -f2`;
	Jour_pret_enregis_entiere=`date -r ~/listedespret.txt | cut -d" " -f1-3`;
	if [[ "$Jour_pret_aujourdhui" =~ "$Jour_pret_enregis" ]]; then
	return;
	else
	jv_pg_ct_testjour_pret1;
	fi
fi
}

jv_pg_ct_envoi_pret_email () {
mpack -s "Contenu de ma liste de prêt:" /home/pi/listedesprets.txt $VOTREMAIL_PRET && say "La liste de mes prêt a été envoyé à $NOM_EMAIL_CONCERNE_PRET";
}

jv_pg_ct_envoi_pret_sms () {
if test -e /home/pi/listedesprets.txt; then
	if jv_plugin_is_enabled "jarvis-FREE-sms"; then
	say "Est-ce que je vous envoie la liste des prets par sms à $(jv_pg_ct_ilyanom) ou personne ?";
	else
	say "vous n'avez pas le plugin jarvis free sms pour faire cela... annulation";
	GOTOSORTIPRET="Fin";
	return;
	fi
else
say "vous n'avez pas de liste de prêt à envoyer par sms... annulation";
GOTOSORTIPRET="Fin";
return;
fi

}

jv_pg_ct_envoi_pret_sms1 () {
if jv_plugin_is_enabled "jarvis-FREE-sms"; then

	if [[ "$order" =~ "personn" ]]; then
	say "Ok, annulation...";
	return; 
	fi	

	jv_pg_ct_verinoms;
	if [[ "$PNOM" == "" ]]; then
	return;
	fi

	say "Voilà je fais partir la liste par sms à $PNOM."
	commands="$(jv_get_commands)"
 	listepretacheter=`echo "Ma liste de ce que j'ai prété:%0d* $(cat /home/pi/listedesprets.txt)" | paste -s -d "*" | sed -e 's/*/%0d%0d* /g'`

	jv_handle_order "MESSEXTERNE ; $PNOM ; $listepretacheter";
else
say "vous n'avez pas le plugin jarvis free sms pour faire cela... annulation";
GOTOSORTIPRET="Fin"; 
return;
fi
}


jv_pg_ct_datereprendre_pret () {
testprets_chemin

if test -e $testprets_chemin_lu; then
testprets_chemin_lu1=`cat $testprets_chemin_lu`
Jour_pret_enregis_diff=`echo $((($(date +%s)-$(date -d $testprets_chemin_lu1 +%s))/86400))`
                        
#	if [[ "$Jour_pret_enregis_diff" -ge "$RAPPEL_PRET_A_REPRENDRE" ]]; then
# echo "-----------$Jour_pret_enregis_diff----------------"

	if [[ "$Jour_pret_enregis_diff" != "0" ]]; then
	pretcontien_total=`cat /home/pi/listedesprets.txt | wc -l`;
	pretcontien_compte=$(( $pretcontien_compte + 1 ))
	pretcontien=`cat ~/listedesprets.txt | sed -n $pretcontien_compte\p`
	jv_pg_ct_lis_pret1_recupere 
	fi
else
date +%D > $testprets_chemin_lu
pretcontien_compte=""
fi
}

	
jv_pg_ct_lis_pret1_recupere () {
# echo "-----pretcontien_compte=$pretcontien_compte < pretcontien_total=$pretcontien_total-----"
if [[ "$pretcontien_compte" -le "$pretcontien_total" ]]; then 

pretcontien1=`echo $pretcontien | cut -d "," -f1`
# echo "-----pretcontien1=$pretcontien1-----"

pretcontien_date=`echo $((($(date +%s)-$(date -d $pretcontien1 +%s))/86400))`
pretcontien_date_long=`date -d $pretcontien1 "+%A %d %B %Y"`
# echo "-----pretcontien_date=$pretcontien_date-----"
# echo "pretcontien_date=$pretcontien_date -ge RAPPEL_PRET_A_REPRENDRE=$RAPPEL_PRET_A_REPRENDRE"
	if [[ "$pretcontien_date" -ge "$RAPPEL_PRET_A_REPRENDRE" ]]; then
	say "Hé !? ça fait $pretcontien_date jours soit depuis le $pretcontien_date_long que tu aurais prété:"
	say "$(echo $pretcontien | cut -d ',' -f2-)"
	say "Penses à le récupérer et à l'effacer de la liste des prêts."
	fi
jv_pg_ct_datereprendre_pret
date +%D > $testprets_chemin_lu
pretcontien_compte=""

fi
}	

