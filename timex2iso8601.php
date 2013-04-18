<?php header('Content-type: text/xml');

// Todo :
// - Gestion des combinaison date+time avec des parenthèses
// - "Calculer" l'année pour les durées de type (no-jour-)mois

include_once('nec.php');

// Création d'un gestionnaire d'assertionsfunction my_assert_handler($file, $line, $code){    echo "<hr>Échec de l'assertion :        File '$file'<br />        Line '$line'<br />        Code '$code'<br /><hr />";}
// Activation des assertions et mise en mode discret
//Option	Paramètre d'ini	Valeur par défaut	Description//ASSERT_ACTIVE	assert.active	1	active l'évaluation de la fonction assert()//ASSERT_WARNING	assert.warning	1	génère une alerte PHP pour chaque assertion fausse//ASSERT_BAIL	assert.bail	0	termine l'exécution en cas d'assertion fausse//ASSERT_QUIET_EVAL	assert.quiet_eval	0	désactive le rapport d'erreur durant l'évaluation d'une assertion//ASSERT_CALLBACK	assert.callback	(NULL)	fonction utilisateur de traitement des assertions fausses
assert_options(ASSERT_ACTIVE, 1);assert_options(ASSERT_WARNING, 0);assert_options(ASSERT_QUIET_EVAL, 1);// Configuration de la méthode de callbackassert_options(ASSERT_CALLBACK, 'my_assert_handler');

#-------------------
# les ordinaux en chiffres
$entier='[0-9]';
$non_entier='[^0-9]';
$suite_entier="$entier+";
$ieme='(?:ièmes|iemes|ième|ieme|èmes|emes|ème|eme|iers|ier|ers|er|e)';
$card_num_ord="(?:($suite_entier)$ieme)";

# les ordinaux en lettres
$ord_let_ch= '(?:[P,p]remier|[S,s]econd|[U,u]nième|[D,d]euxième|[T,t]roisième|[Q,q]uatrième|[C,c]inquième|[S,s]ixième|[S,s]eptième|[H,h]uitième|[N,n]euvième)';
$ord_let_10_19= '(?:[O,o]nzième|[D,d]ouzième|[T,t]reizième|[Q,q]uatorzième|[Q,q]uinzième|[S,s]eizième|[D,d]ix septième|[D,d]ix-septième|[D,d]ix huitième|[D,d]ix-huitième|[D,d]ix neuvième|[D,d]ix-neuvième|[D,d]ixième)';
$ord_let_dizaine='(?:[V,v]ingtième|[T,t]rentième|[Q,q]uarentième|[C,c]inquantième|[S,s]oixantième|[S,s]oixante dixième|[Q,q]uatre vingtième|[Q,q]uatre vingt dixième|[C,c]entième])';
$ord_let_big= '(?:[M,m]illième|[M,m]illionième|[B,b]illionième|[T,t]rillionième)';
$ord_let="(?:$ord_let_big|$ord_let_dizaine|$ord_let_10_19|$ord_let_ch)";

$tabMois = array( 
	'janvier' => '01', 'Janvier' => '01', 'jan' => '01', 'Jan' => '01', 'jan.' => '01', 'Jan.' => '01', 'JAN.' => '01','JAN' => '01',
	'février' => '02', 'Février' => '02','fevrier' => '02', 'Fevrier' => '02', 'fev' => '02', 'Fev' => '02', 'fev.' => '02', 'Fev.' => '02', 'FEV.' => '02','FEV' => '02',
	'mars' => '03', 'Mars' => '03', 'mar' => '03', 'Mar' => '03', 'mar.' => '03', 'Mar.' => '03','MAR.' => '03','MAR' => '03',
	'avril' => '04', 'Avril' => '04', 'avr' => '04', 'Avr' => '04', 'avr.' => '04', 'Avr.' => '04','AVR.' => '04','AVR' => '04',
	'mai' => '05', 'Mai' => '05','MAI' => '05',
	'juin' => '06', 'Juin' => '06', 'jun' => '06', 'Jun' => '06', 'jun.' => '06', 'Jun.' => '06', 'jui.' => '06', 'Jui.' => '06','JUI.' => '06','JUI' => '06','JUN.' => '06','JUN' => '06',
	'juillet' => '07', 'Juillet' => '07', 'jul' => '07', 'Jul' => '07', 'jul.' => '07', 'Jul.' => '07','JUL.' => '07','JUL' => '07',
	'août' => '08', 'Août' => '08', 'aout' => '08', 'Aout' => '08','aou' => '08', 'Aou' => '08', 'aou.' => '08', 'Aou.' => '08','AOU.' => '08','AOU' => '08',
	'septembre' => '09', 'Septembre' => '09', 'sep' => '09', 'Sep' => '09', 'sep.' => '09', 'Sep.' => '09','sept' => '09','sept.' => '09', 'Sept.' => '09', 'SEP.' => '09', 'SEP' => '09', 'SEPT.' => '09', 'SEPT' => '09',
	'octobre' => '10', 'Octobre' => '10', 'oct' => '10', 'Oct' => '10', 'oct.' => '10', 'Oct.' => '10', 'OCT.' => '10', 'OCT' => '10',
	'novembre' => '11', 'Novembre' => '11', 'nov' => '11', 'Nov' => '11', 'nov.' => '11', 'Nov.' => '11', 'NOV.' => '11', 'NOV' => '11',
	'décembre' => '12', 'Décembre' => '12','decembre' => '12', 'Decembre' => '12', 'dec' => '12', 'Dec' => '12', 'dec.' => '12', 'Dec.' => '12', 'DEC.' => '12', 'DEC' => '12'
	);
     
$tabJour = array(
	'lundi' => '01', 'Lundi' => '01', 'Lun' => '01', 'lun.' => '01', 'Lun.' => '01', 'lun' => '01',
	'mardi' => '02', 'Mardi' => '02', 'Mar' => '02', 'mar.' => '02', 'Mar.' => '02', 'mar' => '02',
	'mercredi' => '03', 'Mercredi' => '03', 'Mer' => '03', 'mer.' => '03', 'Mer.' => '03', 'mer' => '03',
	'jeudi' => '04', 'Jeudi' => '04', 'Jeu' => '04', 'jeu.' => '04', 'Jeu.' => '04', 'jeu' => '04',
	'vendredi' => '05', 'Vendredi' => '05', 'Ven' => '05', 'ven.' => '05', 'Ven.' => '05', 'ven' => '05',
	'samedi' => '06', 'Samedi' => '06', 'Sam' => '06', 'sam.' => '06', 'Sam.' => '06', 'sam' => '06',
	'dimanche' => '07', 'Dimanche' => '07', 'Dim' => '07', 'dim.' => '07', 'Dim.' => '07', 'dim' => '07'
	);	

//==============================================================================
// Fonctions
//==============================================================================

function getItemValue($noeud, $table) {
	global $suite_entier, $ieme;
	$type = $noeud->getAttribute('type');
	$val = $noeud->firstChild->nodeValue;
	if ($type=='car') {
		if (isset($table)) $val = $table[utf8_decode($val)];
		else if (preg_match("/^($suite_entier)$ieme$/i",$val,$t)) $val = $t[1];
		else $val = enchiffres($val);
	}
	return $val;
}

function getVal($nom, $item, $table = null) {
	global $suite_entier, $ieme;
	$noeuds = $item->getElementsByTagName($nom);
	if ($noeuds->length > 0) {
		$noeud = $noeuds->item(0);
		$val = $noeud->getAttribute('val');
		if (!isset($val)) $val = getItemValue($noeud,$table);
	} else $val=null;
	return $val;
}

function rechercheComplement($noeud,$nom) {
	$listeNoeuds = array();
	$fin = false; $ok = !$fin;
	$frere = $noeud->nextSibling;
	while(isset($frere) && $ok && !$fin){
		if ($frere->nodeType == XML_TEXT_NODE) {
			$txt = utf8_decode($frere->data);
			$ok = $ok && ( (trim($txt) == '') or (trim($txt) == ',') );
			if ($ok) {
				$listeNoeuds[] = $frere;
				$frere = $frere->nextSibling;
			}
		} else {//c'est un élément !
			$fin = true;
			if ($frere->tagName == $nom) {
				$listeNoeuds[] = $frere;
			} else {$ok = false;}
		}
	}
	return array($ok, $fin, $listeNoeuds);
}

function startsWith($ch,$source){return stripos($source, $ch) === 0;}
function endsWith($ch,$source){return strripos($source, $ch) === (strlen($source)-strlen($ch)+1);}
function contains($ch,$source){return !(stripos($source, $ch) === false);}

function rechercheComplement2($noeud,$nom) {
	$listeNoeuds = array();
	$fin = false; $ok = !$fin;
	$etat=0;
	$frere = $noeud->nextSibling;
	while(isset($frere) && $ok && !$fin){
		if ($frere->nodeType == XML_TEXT_NODE) {
			$txt = trim(utf8_decode($frere->data));
			if ((startsWith($txt,'(')) && ($etat==0)) $etat = 2 ;
			else if (($txt=='') && ($etat==0)) $etat = 1 ;
			else if ((startsWith($txt,'(')) && ($etat==1)) $etat = 2 ;
			else if (($txt=='') && ($etat==1)) $etat = 1 ;
			else if ((!contains($txt,')')) && (!contains($txt,' . ')) && ($etat == 2)) $etat = 2;
			else if ((!contains($txt,')')) && (!contains($txt,' . ')) && ($etat == 3)) $etat = 3;
			else if ((contains($txt,')')) && ($etat == 3)) $fin = true;
			else $ok = false;
			if ($ok) {
				$listeNoeuds[] = $frere;
				$frere = $frere->nextSibling;
			}
		} else {//c'est un élément !
			if ($frere->tagName == $nom && (($etat==2) || ($etat==1))) {
				$listeNoeuds[] = $frere;
				if ($etat==2) $etat=3; else $fin=true;
			} else {$ok = false;}
		}
	}
	return array($ok, $fin, $listeNoeuds);
}

function createDateTime($doc, $xpath,$nomref,$nomsuite) { 
	$refs = $xpath->query("//$nomref");
	#$refs = $xpath->query("/texte-tmp/$nomref");
	foreach($refs as $ref) {
		echo 'Traitement de '.$ref->getAttribute('iso8601')."\n";
		list($ok, $fin, $liste) = rechercheComplement2($ref,$nomsuite);
		if ($ok && $fin) {
			//Construction du nouveau sous-arbre
			$pere = $ref->parentNode;
			if ($ref->hasAttribute('iso8601')) $iso = $ref->getAttribute('iso8601'); else $iso=null;
			$datetime = $doc->createElement('date-time');
			$datetime->appendChild($ref->cloneNode(true)); 
			$datetime->setAttribute('type','lin');
			$pere->replaceChild($datetime,$ref);
			foreach($liste as $noeud) {
				echo $doc->saveXML($noeud)."\n";
				$datetime->appendChild($noeud->cloneNode(true)); 
				$pere->removeChild($noeud);
			}
			if (isset($iso) && ($datetime->lastChild->hasAttribute('iso8601'))) 
				$datetime->setAttribute('iso8601',$iso.$datetime->lastChild->getAttribute('iso8601'));
		}
	}
	return $doc;
}

function setValues($elementName,$xpath,$tableRef) {
	$liste_elements_tmps = $xpath->query("//$elementName");
	#$liste_elements_tmps = $xpath->query("/texte-tmp//$elementName");
	foreach($liste_elements_tmps as $element) {
		$element->setAttribute('val',getItemValue($element,$tableRef));
	}
}

//==============================================================================
// Programme Principal
//==============================================================================

//var_dump($_SERVER);
$file = $_SERVER['argv'][1];
$doc = new DOMDocument();
//$doc->load('holmes.xml');
echo "Traitement de $file.xml\n";
$doc->load("$file.xml");

$xpath = new DOMXpath($doc);

//Calcul des valeurs des différents éléments de date et heure
echo "Étiquetage des années\n";
setValues("annee",$xpath,null);
echo "Étiquetage des mois\n";
setValues("mois",$xpath,$tabMois);
echo "Étiquetage des numéros de jour\n";
setValues("no-jour",$xpath, null);
echo "Étiquetage des jours\n";
setValues("jour",$xpath,$tabJour);
echo "Étiquetage des heures\n";
setValues("heure",$xpath,null);
echo "Étiquetage des minutes\n";
setValues("minute",$xpath,null);
echo "Étiquetage des secondes\n";
setValues("seconde",$xpath,null);

//Calcul de l'iso8601 des différentes dates. Seulement possible s'il y a au moins l'année.
#$dates = $xpath->query('/texte-tmp//date[annee]');$dates = $xpath->query('//date[annee]');foreach ($dates as $date)  {
	$iso = getVal('annee',$date);
	if (strlen($iso) ==2) {
		if ($iso >50) $iso = '19'.$iso; else $iso = '20'.$iso;
	} else if (strlen($iso)==1) $iso='200'.$iso;
	$mois = getVal('mois',$date,$tabMois);
	if (isset($mois)) {
		$iso = $iso.'-'.$mois;
		$nojour = getVal('no-jour',$date);
		if (isset($nojour)) {
			if (strlen($nojour)==1) $nojour='0'.$nojour;
			$iso = $iso.'-'.$nojour;
		}
	}
	$date->setAttribute('iso8601',$iso);
}

//Calcul de l'iso8601 des différentes dates. Seulement possible s'il y a au moins l'année.
#$dates = $xpath->query('/texte-tmp//duree[annee]');$dates = $xpath->query('//duree[annee]');foreach ($dates as $date)  {
	$iso = getVal('annee',$date);
	if (strlen($iso) ==2) {
		if ($iso >50) $iso = '19'.$iso; else $iso = '20'.$iso;
	} else if (strlen($iso)==1) $iso='200'.$iso;
	$mois = getVal('mois',$date,$tabMois);
	if (isset($mois)) {
		$iso = $iso.'-'.$mois;
		$nojour = getVal('no-jour',$date);
		if (isset($nojour)) {
			if (strlen($nojour)==1) $nojour='0'.$nojour;
			$iso = $iso.'-'.$nojour;
		}
	}
	$date->setAttribute('iso8601',$iso);
}


//Calcul de l'iso8601 des différentes heures. Possible que s'il y a au moins l'heure.
$heures = $xpath->query('//time[heure]');foreach ($heures as $heure)  {
	$nbheure = getVal('heure',$heure);
	if (strlen($nbheure)==1) $nbheure='0'.$nbheure;
	$iso = 'T'.$nbheure;
	$minute = getVal('minute',$heure);
	if (isset($minute)) {
		if (strlen($minute)==1) $minute='0'.$minute;
		$iso = $iso.':'.$minute;
		$seconde = getVal('seconde',$heure);
		if (isset($seconde)) {
			if (strlen($seconde)==1) $seconde='0'.$seconde;
			$iso = $iso.':'.$seconde;
		}
	}
	$heure->setAttribute('iso8601',$iso);
}

$doc = createDateTime($doc,$xpath, 'date','time');
$doc = createDateTime($doc,$xpath, 'time','date');

//echo $doc->saveXML();
//$doc->save('holmes2.xml');
echo 'Écriture de '.$file.".tpqa\n";
$doc->save($file.'.tpqa');
//echo startsWith('Toto','T')?'ok':'ko'."\n";
//echo startsWith('Toto','o')?'ok':'ko'."\n";
//echo endsWith('Toto','T')?'ok':'ko'."\n";
//echo endsWith('Toto','o')?'ok':'ko'."\n";


?>