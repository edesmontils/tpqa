#!/usr/bin/perl 

# Créé par : ???
# Modifié par E. Desmontils le 05/10/07, 20/11/07
# Version : 2.0 Beta 1

# usage
# entitetemporelle.pl <source> <cible> 


# IN
# source file : a sentence per line

# OUT 
#    FILEOutputText = file with numeric entities tags, whose name = cible

# TODO List :
# - regarder la manipulation des suffixes
# - regarder aussi les modi. sur les "durées"
# - "<duree>12 heures 30</duree>" tagger les valeurs

if( @ARGV != 2 ) {
    die "usage: entitetemporelle.pl <source> <cible>\n";
}

$source = $ARGV[0];
$cible = $ARGV[1];

#@files = readpipe( "find $dir -name \"*NE$step\" -print" );
#foreach $file ( @files ) {
#    chop( $file );
#    chop( $file );
#    if ( open( FILEInputText , "<$file$step" ) 
#	 && open( FILEOut , ">$file$step.xml" ) ) {
#            &xi_quant_time;
#            close( FILEOut );
#            close( FILEInputText );
#    }
#}

if ( open( FILEInputText , "<$source" ) 
	 && open( FILEOut , ">$cible" ) ) {
	 		print FILEOut "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
			print FILEOut "<texte-tmp>\n";
            &xi_quant_time;
            print FILEOut '</texte-tmp>';
            close( FILEOut );
            close( FILEInputText );
    }

sub xi_quant_time() {

$suffix = "dates";
$Tags = "<[a-zA-Z_#0-9]+>";

#############################################################################################
###########################    declarations des variables    ################################
#############################################################################################

# balises sautees
$baliseBG = '(?:<DOCNO>|<DATE>|<PROFILE>|<IN>|<DOCID>|<PAGE>|<SENT:[0-9]+>|</SENT>|<SENT>)';
# variables pour les nombres en chiffres

$tiret= '(?:\-)';
$let='[a-zA-Zéèïïüëâôöü_]';
$not_let='[^a-zA-Zéèïïüëâôöü_]';
$p_let="$let+";
$ponctuation='(?:\.|\,|\;|\!|\?|\:|\-)';
$espace='(?: )';
$point='(?:\.)';
$slash='\/';

#les variables nombre en chiffre
$entier='[0-9]';
$non_entier='[^0-9]';
$suite_entier="$entier+";
$blanc_point='(?: |\.)';
$blanc='(?: )';
$virgule='(?:\,)';
$nombre_entier="(?:(?:$suite_entier$point$suite_entier)(?:$point$suite_entier)*|$suite_entier)";
$nombre_reel="(?:$suite_entier$virgule$suite_entier)";

# variables pour les nombres en lettres
$blanc_tiret='(?: |-)';
$card_let_un='(?:un|une|Un|une)';
$card_let_ch='(?:[U,u]ne|[U,u]n|[D,d]eux|[T,t]rois|[Q,q]uatre|[C,c]inq|[S,s]ix|[S,s]ept|[H,h]uit|[N,n]euf)';
$card_let_unite= '(?:[D,d]eux|[T,t]rois|[Q,q]uatre|[C,c]inq|[S,s]ix|[S,s]ept|[H,h]uit|[N,n]euf)';
$card_let_10_19='(?:[D,d]ix-sept|[D,d]ix sept|[D,d]ix-huit|[D,d]ix huit|[D,d]ix-neuf|[D,d]ix neuf|[D,d]ix|[O,o]nze|[D,d]ouze|[T,t]reize|[Q,q]uatorze|[Q,q]uinze|[S,s]eize)';
$card_let_dizaine= '(?:[V,v]ingt|[T,t]rente|[Q,q]uarante|[C,c]inquante|[S,s]oixante|[Q,q]uatre vingts|[Q,q]uatre-vingts|[Q,q]uatre vingt|[Q,q]uatre-vingt)';
$card_let_70_79="(?:[S,s]oixant-et-onze|[S,s]oixante et onze|[S,s]oixante-$card_let_10_19|[S,s]oixante $card_let_10_19)";
$card_let_90_99="(?:[Q,q]uatre-vingt-et-onze|[Q,q]uatre-vingt et onze|[Q,q]uatre vingt et onze|[Q,q]uatre-vingt-$card_let_10_19|[Q,q]uatre vingt $card_let_10_19)";
$card_let_dizaine_et_un="(?:$card_let_dizaine et une|card_let_dizaine-et-une|$card_let_dizaine-et-un|$card_let_dizaine et un)";
$card_let_21_89="(?:$card_let_dizaine $card_let_unite|$card_let_dizaine et $card_let_un|$card_let_dizaine-$card_let_unite|$card_let_dizaine-et-$card_let_un)";
$card_let_1_99="(?:$card_let_90_99|$card_let_70_79|$card_let_21_89|$card_let_10_19|$card_let_dizaine|$card_let_unite|$card_let_un)";
$card_let_cent='(?:[C,c]ent|[C,c]ents)';
$card_let_1_999="(?:$card_let_unite $card_let_cent $card_let_1_99|$card_let_unite $card_let_cent|$card_let_cent $card_let_1_99|$card_let_cent|$card_let_1_99)";
$card_let_mille='(?:[M,m]ille)';
$card_let_1_999mi="(?:$card_let_1_999 $card_let_mille $card_let_1_999|$card_let_1_999 $card_let_mille et $card_let_un|$card_let_1_999 $card_let_mille|$card_let_mille $card_let_1_999|$card_let_mille et $card_let_un|$card_let_mille|$card_let_1_999)";
$card_let_million='(?:[M,m]illions|[M,m]illion)';
$card_let_1_999mn="(?:$card_let_1_999 $card_let_million $card_let_1_999mi|$card_let_1_999 $card_let_million et $card_let_un|$card_let_1_999 $card_let_million|$card_let_million $card_let_1_999mi|$card_let_1_999 $card_let_million et $card_let_un|$card_let_million et $card_let_un|$card_let_million|$card_let_1_999mi)";
$card_let_milliard='(?:[M,m]illiards|[M,m]illiard)';
$card_let_1_999ml="(?:$card_let_1_999 $card_let_milliard $card_let_1_999mn|$card_let_1_999 $card_let_milliard et $card_let_un|$card_let_1_999 $card_let_milliard|$card_let_milliard $card_let_1_999mn|$card_let_1_999 $card_let_milliard et $card_let_un|$card_let_milliard et $card_let_un|$card_let_milliard|$card_let_1_999mn|$card_let_1_999 $card_let_milliard et $card_let_un|$card_let_milliard et $card_let_un)";
$card_let="(?:$card_let_1_999ml et (?:demi|quart)|$card_let_1_999ml)";

#-------------------
# les ordinaux en chiffres
$ieme='(?:ièmes|iemes|ième|ieme|èmes|emes|ème|eme|iers|ier|ers|er|e)';
$card_num_ord="(?:$suite_entier$ieme)";

# les ordinaux en lettres
$ord_let_ch= '(?:[P,p]remier|[S,s]econd|[U,u]nième|[D,d]euxième|[T,t]roisième|[Q,q]uatrième|[C,c]inquième|[S,s]ixième|[S,s]eptième|[H,h]uitième|[N,n]euvième)';
$ord_let_10_19= '(?:[O,o]nzième|[D,d]ouzième|[T,t]reizième|[Q,q]uatorzième|[Q,q]uinzième|[S,s]eizième|[D,d]ix septième|[D,d]ix-septième|[D,d]ix huitième|[D,d]ix-huitième|[D,d]ix neuvième|[D,d]ix-neuvième|[D,d]ixième)';
$ord_let_dizaine='(?:[V,v]ingtième|[T,t]rentième|[Q,q]uarentième|[C,c]inquantième|[S,s]oixantième|[S,s]oixante dixième|[Q,q]uatre vingtième|[Q,q]uatre vingt dixième|[C,c]entième])';
$ord_let_big= '(?:[M,m]illième|[M,m]illionième|[B,b]illionième|[T,t]rillionième)';

$ord_let="(?:$ord_let_big|$ord_let_dizaine|$ord_let_10_19|$ord_let_ch)";

#######################################################################
#######################################################################
#################  LES DATES, HEURES, DUREES, AGES (NM)  ##############
#######################################################################


#### chiffres cardinaux entiers pour les dates a deux et quatre chiffres ####
$card_num_ch='[0-9]';
$card_num_ch_date_first= '[4-9]';
$card_num_ch_date_second= '[0-9]';
$card_num_ch_date_9= '9';
$card_num_ch_date_1= '1';
$card_num_ch_date_2= '2';

#### jour et année en cardinal lettre ####
$card_let_jour="(?:[T,t]rente et un|[T,t]rente-et-un|[T,t]rente|[V,v]ingt-et-un|[V,v]ingt et un|[V,v]ingt-$card_let_unite|[V,v]ingt $card_let_unite|$card_let_10_19|$card_let_unite)";
$card_let_annee="(?:[D,d]eux $card_let_mille $card_let_1_999|$card_let_mille $card_let_1_999|[D,d]eux $card_let_mille|$card_let_mille|$card_let_1_999)";

#### chiffres et nombres cardinaux pour les mois ####
$card_num_mois='(?:01|02|03|04|05|06|07|08|09|10|11|12)';

### chiffres et nombres ordinaux et cardinaux pour les quantiemes du mois ####
$card_num_ch_date_day_first= '[0-3]';
$card_num_ch_date_day_second= '[0-9]';
$card_num_jour="(?:$card_num_ch_date_day_second|$card_num_ch_date_day_first$card_num_ch_date_day_second)";
$card_num_date_quant= "(?:$card_num_ch_date_day_first){0,1}$card_num_ch_date_day_second";

#### nombre cadinaux romains ##################
$chif_rom='(?:IV|VIII|III|VII|II|VI|V|IX|I)';
$let_rom='(?:X|I|V|C|M)';
$nombre_rom="$let_rom+";

#### nombres cardinaux entiers pour les dates a deux et quatre chiffres ####
$card_num_entier_date= "$card_num_ch_date_first$card_num_ch_date_second";
$card_num_entier_date_4= "(?:$card_num_ch_date_1(?:$card_num_ch){3}|$card_num_ch_date_2(?:$card_num_ch){3})";
$card_num_entier_date_3= '[1-9]{3}';
$card_num_entier_date_2= '[0-9]{2}';
$card_num_entier_decad= '(?:[1-2][0-9][0-9]0|[1-9][0-9]0)';
$card_num_annee="(?:$card_num_entier_date_4|$card_num_entier_date_3|$card_num_entier_date_2)";
$card_num_annee4="(?:$card_num_entier_date_4)";
$card_num_annee2="(?:$card_num_entier_date_2)";

#### les constantes alphanumeriques pour les expressions temporelles de dates, heures et durees ####



$mois='(?:[J,j]anvier|[f,F][e,é]vrier|[m,M]ars|[a,A]vril|[m,M]ai|[J,j]uin|[J,j]uillet|[A,a]out|[A,a]oût|[S,s]eptembre|[O,o]ctobre|[N,n]ovembre|[D,d][e,é]cembre|JAN\.?|FEV\.?|MAR\.?|AVR\.?|MAI|JUN\.?|JUL\.?|AOU\.?|SEP\.?|OCT\.?|NOV\.?|DEC\.?|Jan\.?|Fev\.?|Mar\.?|Avr\.?|Jui\.?|Jul\.?|Aou\.?|Sep\.?|Sept\.?|Oct\.?|Nov\.?|Dec\.?|jan\.?|fev\.?|mar\.?|avr\.?|jui\.?|jul\.?|aou\.?|sep\.?|sept\.?|oct\.?|nov\.?|dec\.?)';

$jour_ch='(?:[L,l]undi|[M,m]ardi|[M,m]ercredi|[j,J]eudi|[V,v]endredi|[s,S]amedi|[d,D]imanche|[L,l]un\.?|[M,m]ar\.?|[M,m]er\.?|[j,J]eu\.?|[V,v]en\.?|[s,S]am\.?|[d,D]im\.?)';

$modif_date_av='(?:[D,d]ébut|[m,M]i|[F,f]in|[D,d]ébut-|[F,f]in-|[m,M]i-|[c,C]ourant)';
$modif_date_ap='(?:prochaines|prochaine|prochains|prochain|dernières|dernière|derniers|dernier|suivantes|suivante|suivants|suivant)';

$post_date_sup = '(?:prochaines|prochaine|prochains|prochain|suivantes|suivante|suivants|suivant)';
$post_date_inf = '(?:dernières|dernière|derniers|dernier|précédent|précédents|précédente|précédentes)';
$post_date= "$post_date_sup|$post_date_inf";

$mi_mois = '(?:mi\-$mois|mi $mois)';
$mi_temps = '(?:mi\-journée|mi\-temps)';
$defMois='(?:[M,m]ois de|[M,m]ois d\')';
$En='(?:en|En)';
$specifierAn  = $En;
$specifierDate = $En;
$specifierPeriode='(?:pendant|Pendant|durant|Durant|En|en|Chaque|chaque|Depuis|depuis|avant|Avant|Courant|courant)';
$timeUnit= '(?:[J,j]ournées|[J,j]ournée|[J,j]ours|[J,j]our|[S,s]emaines|[S,s]emaine|[M,m]ois|[T,t]rimestres|[T,t]rimestre|[S,s]emestres|[S,s]emestre|[A,a]nnées|[A,a]nnée|[A,a]ns|[A,a]n|[D,d]écades|[D,d]écade|[S,s]iècles|[S,s]iècle|[M,m]inutes|[M,m]inute|[M,m]in\.|[M,m]in|[H,h]eures|[H,h]eure|h|H|[S,s]econdes|[S,s]econde|[S,s]ec\.|[S,s]ec|[S,s]aisons|[S,s]aison|[N,n]uits|[N,n]uit|[H,h]ivers|[H,h]iver|[E,é]tés|[E,é]té|[P,p]rintemps|[A,a]utomnes|[A,a]utomne|[D,d]écennies)';

$timeUnitHeure= '(?:[H,h]eures|[H,h]eure|h|H)';
$timeUnitMinute= '(?:[M,m]inutes|[M,m]inute|[M,m]in\.|[M,m]in)';
$timeUnitSeconde= '(?:[S,s]econdes|[S,s]econde|[S,s]ec\.|[S,s]ec)';

$timeUnitS= '(?:[J,j]ournée|[J,j]our|[S,s]emaine|[M,m]ois|[T,t]rimestre|[S,s]emestre|[A,a]nnée|[A,a]n|[D,d]écade|[S,s]iècle|[M,m]inute|[H,h]eure|[S,s]econde|[S,s]aison|[N,n]uit|[H,h]iver|[E,é]té|[P,p]rintemps|[A,a]utomne)';
$Saison='(?:[H,h]ivers|[H,h]iver|[P,p]rintemps|[E,é]tés|[E,e]té|[A,a]utomnes|[A,a]utomne)';
$partOfDayS ='(?:[A,a]près midi|[A,a]près-midi|[M,m]atinée|petit matin|[M,m]atin|[S,s]oirée|[S,s]oir|[D,d]éjeuner|[D,d]iner|[N,n]uit)';
$partOfDayP = '(?:[N,n]uits|[A,a]près midis|[A,a]près-midis|[M,m]atinées|[M,m]atinée|[M,m]atins|[S,s]oirées|[S,s]oirs|[D,d]éjeuners|[D,d]iners)';

$modifDayS='(?:[D,d]ans la|[D,d]ans l\'|[E,e]n fin de|[E,e]n fin d\'|[A,a]u milieu du|[A,a]u milieu de la|[A,a]u milieu de l\'|[E,e]n milieu d\'|[E,e]n milieu de|[E,e]n cours d\'|[E,e]n début d\'|[E,e]n début de|[A,a]u début du|[A,a]u début de l\'|[A,a]u début de la|[A,a]u courant de la|[A,a]u courant de l\'|[A,a]u courant du|[D,d]urant la|[D,d]urant le|[D,d]urant l\'|[E,e]n début|[E,e] fin|[E,e]n milieu|[E,e]n|[C,c]ette|[C,c]et|[C,c]e)';

#Ajouter $modif_date_av, $mi_mois, $specifierPeriode
$pref_duree_eq = '(?:[C,c]ette|[C,c]et|[C,c]e|[E,e]n)';
$pref_duree_in = '(?:pendant|Pendant|durant|Durant|Chaque|chaque|[D,d]ans la|[D,d]ans l\'|[E,e]n cours d\'|[A,a]u courant de la|[A,a]u courant de l\'|[A,a]u courant du|[D,d]urant la|[D,d]urant le|[D,d]urant l\'|Courant|courant)';
$pref_duree_in_mid = '(?:Mi|Mi-|mi|mi-|[A,a]u milieu du|[A,a]u milieu de la|[A,a]u milieu de l\'|[E,e]n milieu d\'|[E,e]n milieu de|[E,e]n milieu)';
$pref_duree_in_inf = '(?:Début|Début-|début|début-|[E,e]n début d\'|[E,e]n début de|[A,a]u début du|[A,a]u début de l\'|[A,a]u début de la|[E,e]n début)';
$pref_duree_inf = '(?:avant|Avant)';
$pref_duree_in_sup = '(?:Fin|Fin-|fin|fin-|[E,e]n fin de|[E,e]n fin d\'|[E,e] fin)';
$pref_duree_sup = '(?:Depuis|depuis)';
$pref_duree = "$pref_duree_eq|$pref_duree_in|$pref_duree_in_mid|$pref_duree_in_inf|$pref_duree_in_sup|$pref_duree_inf|$pref_duree_sup";

$timePeriod='(?:journée|jour|siècle|année|semestre|trimestre)';
$from='(?:De|de|Du|du|Entre\sle)';
$to='(?:à|au|Au|et\sle)';

$pour='(?:pour|Pour)';
$a='(?:A|à|À)';
$au='(?:Au|Aux|aux|au)';
$Avant='(?:avant|Avant)';
$Apres='(?:après|Après)';
$De='(?:De|de|D\'|d\'|Du|du)';
$Le='(?:Le|le|l\')';
$Depuis='(?:depuis|Depuis)';
$Jusque='(?:jusque|Jusque|Jusqu\'|jusqu\')';
$Chaque='(?:Chaque|chaque)';
$plus_tard='(?:plus tard|Plus tard)';
$a_partir = '(?:[A|a] partir)';
$plus_tot='(?:plus tôt|Plus tôt)';

$pref_heure_eq = "$a|$pour";
$pref_heure_inf = "$Avant|$Jusque$a|$au $plus_tard $a";
$pref_heure_sup = "$Depuis|$Apres|$a_partir $De|$au $plus_tot $a";

$pref_heure = "$pref_heure_eq|$pref_heure_inf|$pref_heure_sup";

$pref_date_eq = "$De|$Le|$au|$En";
$pref_date_inf = "$pour\s+$le|$Avant(?:\s+$Le)?|$Jusque$au|$Jusque$En|$au\s+$plus_tard\s+$Le";
$pref_date_sup = "$Depuis(?:\s+$Le)?|$a_partir\s+$De|$Apres(?:\s+$Le)?";

$pref_date = "$pref_date_eq|$pref_date_inf|$pref_date_sup";

$a_venir='(?:à venir)';
$plusieurs='(?:Plusieurs|plusieurs|Quelques|quelques)';
$annee_det='(?:[F,f]in des années|[D,d]ébut des années|[M,m]ilieu des années|[F,f]in de l\'année|[D,d]ébut de l\'année|[M,m]ilieu de l\'année|[F,f]in de l\'an|[D,d]ébut de l\'an|[M,m]ilieu de l\'an|[D,d]epuis les années|[D,d]ans les années|[D,d]epuis l\'année|[D,d]urant les années|[A,a]u cours des années|[D,d]epuis l\'an|[A,a]u courant des années|[A,a]u courant de l\'année|[L,l]es années|[D,d]es années|[E,e]n l\'an|[L,l]\'an|[A,a]n)';
$durantdes='(?:Durant des|durant des)';
$et_ou='(?:et|ou)';
$scie_mil='(?:Siècle|siècle|millénaire|Millénaire)';
$numene='(?:[D,e]mi douzaine|[D,e]mi-douzaine|[D,d]izaines|[D,d]izaine|[D,d]ouzaines|[D,d]ouzaine|[C,c]entaines|[C,c]entaine|[D,e]mi millier|[D,d]emi-millier|[M,m]illiers|[M,m]illier)';

##### l âge     ################

$AgeDe='L\'âge de|l\'âge de|Age de|âge de|agé de|Agées de|Agée de|Agés de|Agé de|agées de|agé de|âgées de|âgée de|âgés de|âgé de';
$Avoir='[A,a]vions|[A,a]viez|[A,a]vaient|[A,a]vais|[A,a]vait|[A,a]vons|[A,a]vez|[O,o]nt|[A,a]s|[A,a]i|[A,a]uront|[A,a]urons|[A,a]urez|[A,a]urai|[A,a]uras|[A,a]voir|[A,a]ura|A|a';

#### les heures et horaires #####
$specifierTimeAnte = '(?:by|By|from|From|until|Until|since|Since|around|Around|at|At|tomorrow|yesterday|today)';
$timeCompo = '(?:am|a\.m\.|a\.m|pm|p\.m\.|p\.m|eastern time|Eastern time|western time|Western time|Pacific time|east time|East time|central time|Central time|gmt|GMT|anti\-meridian|post\-meridian|local time|locales)';
$timeMin ='(?:minutes|minute|min\.|min)';
$timeCompoLet3 = '(?:cinq|dix|quinze|vingt|vingt\-cinq|vingt cinq|trente|trente\-cinq|trente cinq|quarante|quarante\-cinq|quarante cinq|cinquante|cinquante\-cinq|cinquante cinq)';
$timeCompoLet4 = '(?:et quart|et demi)';
$timeCompoNum3 = '(?:5|10|15|20|25|30|35|40|45|50|55)';
$periode_jour  = '(?:matin|soir|après\-midi|après midi)';
$periode_jour_s  = '(?:ce matin|ce soir|cet après\-midi|cet après midi)';
$jour = '(?:aujourd\'hui|hier|demain|avant hier)';
$specifierTimePost = "(?:periode_jour_s|$jour|$jour $periode_jour)";

$timeNumHour12 = '[0-1]{0,1}[0-9]{0,1}';
$timeNumHour24 = '[0-2]{0,1}[0-9]{0,1}';
$timeNumMin = '[0-5]{0,1}[0-9]{0,1}';
$timeNumSec = $timeNumMin;
$timeLetHour = '(?:une|deux|trois|quatre|cinq|six|sept|huit|neuf|dix|onze|douze|treize|quatorze|quinze|seize|dix sept|dix huit|dix neuf|vingt|vingt et un|vingt deux|vingt trois|vingt quatre|minuit|midi)';

$timeUnitHeure= '[Hh]eures|[Hh]eure|h|H';
$timeUnitMinute= '[Mm]inutes|[Mm]inute|[Mm]in\.|[Mm]in';
$timeUnitSeconde= '[Ss]econdes|[Ss]econde|[Ss]ec\.|[Ss]ec';

           $T = 'T';#Pour le format standard

####################################################################################################################################
# traitement apres que tout soit tagge : remplace les balises diverses et variées de nombre en NUMBER. (repris de BG, integre par NM)
#####################################################################################################################################


$tag_entier='<numex TYPE="Nombre_Entier">';
$f_tag_entier='</numex>';
#$tag_score='<numex TYPE="score">';
#$f_tag_score='</numex>';
$tag_intervalle_nombre='<numex TYPE="Intervalle_Nombre">';
$f_tag_intervalle_nombre='</numex>';
$tag_entier_ord='<numex TYPE="Nombre_Entier_ord">';
$f_tag_entier_ord='</numex>';
$tag_entier_let='<numex TYPE="Nombre_Entier_let">';
$f_tag_entier_let='</numex>';
$tag_number='<numex TYPE="NUMBER">';
$f_tag_number='</numex>';
$tag_numene='<numex TYPE="NUMENE">';
$f_tag_numene='</numex>';
$tag_reel='<numex TYPE="Nombre_Reel">';
$f_tag_reel='</numex>';
$tag_num_ord='er|ème|e';

$entier_tagge="($tag_entier)([^<]+)($f_tag_entier)";
$entier_let_tagge="($tag_entier_let)([^<]+)($f_tag_entier_let)";
$reel_tagge="($tag_reel)([^\<]*)($f_tag_reel)";


####################################################################################################################################
#Date & Heure
#####################################################################################################################################

$tiret='-';
$deux_points=':';

$tag_datetime_lin='<date-time type="lin">';
$f_tag_datetime_lin='</date-time>';
$tag_datetimeISO8601='<date-time type="ISO-8601">';
$f_tag_datetimeISO8601='</date-time>';
$tag_datetimeISOXXXX='<date-time type="ISO-xxxx">';
$f_tag_datetimeISOXXXX='</date-time>';
$tag_datetime="$tag_datetime_lin|$tag_datetimeISO8601|$tag_datetimeISOXXXX";
$f_tag_datetime='</date-time>';

$tag_heureISO8601='<time type="ISO-8601">';
$f_tag_heureISO8601='</time>';
$tag_heureISOXXXX='<time type="ISO-xxxx">';
$f_tag_heureISOXXXX='</time>';
$tag_heureISO="$tag_heureISO8601|$tag_heureISOXXXX";
$f_tag_heureISO='</time>';
$tag_heure_lin='<time type="lin">';
$f_tag_heure_lin='</time>';
$tag_heure="$tag_heureISO|$tag_heure_lin";
$f_tag_heure='</time>';

$tag_nbheure2='<heure type="num">';
$f_tag_nbheure2='</heure>';
$tag_nbminute='<minute type="num">';
$f_tag_nbminute='</minute>';
$tag_nbseconde='<seconde type="num">';
$f_tag_nbseconde='</seconde>';

$tag_ltheure2='<heure type="car">';
$f_tag_ltheure2='</heure>';
$tag_ltminute='<minute type="car">';
$f_tag_ltminute='</minute>';
$tag_ltseconde='<seconde type="car">';
$f_tag_ltseconde='</seconde>';

$tag_heure2="(?:$tag_nbheure2|$tag_ltheure2)";
$f_tag_heure2="(?:$f_tag_nbheure2|$f_tag_ltheure2)";
$tag_minute="(?:$tag_nbminute|$tag_ltminute)";
$f_tag_minute="(?:$f_tag_nbminute|$f_tag_ltminute)";
$tag_seconde="(?:$tag_nbseconde|$tag_ltseconde)";
$f_tag_seconde="(?:$f_tag_nbseconde|$f_tag_ltseconde)";

$tag_date_lin='<date type="lin">';
$f_tag_date_lin='</date>';
$tag_dateISO8601='<date type="ISO-8601">';
$f_tag_dateISO8601='</date>';
$tag_dateISOXXXX='<date type="ISO-xxxx">';
$f_tag_dateISOXXXX='</date>';
$tag_dateISO="$tag_dateISO8601|$tag_dateISOXXXX";
$f_tag_dateISO='</date>';
$tag_date="$tag_date_lin|$tag_dateISO";
$f_tag_date='</date>';

$tag_jour='<jour>';
$f_tag_jour='</jour>';

$tag_nbmois='<mois type="num">';
$f_tag_nbmois='</mois>';
$tag_nbnojour='<no-jour type="num">';
$f_tag_nbnojour='</no-jour>';
$tag_nbannee='<annee type="num">';
$f_tag_nbannee='</annee>';
$tag_nbannee_imp='<annee statut="imp">';

$tag_ordnojour='<no-jour type="ord">';
$f_tag_ordnojour='</no-jour>';

$tag_ltmois='<mois type="car">';
$f_tag_ltmois='</mois>';
$tag_ltnojour='<no-jour type="car">';
$f_tag_ltnojour='</no-jour>';
$tag_ltannee='<annee type="car">';
$f_tag_ltannee='</annee>';

$tag_mois="(?:$tag_nbmois|$tag_ltmois)";
$f_tag_mois="(?:$f_tag_nbmois|$f_tag_ltmois)";
$tag_nojour="(?:$tag_nbnojour|$tag_ltnojour)";
$f_tag_nojour="(?:$f_tag_nbnojour|$f_tag_ltnojour)";
$tag_annee="(?:$tag_nbannee|$tag_ltannee)";
$f_tag_annee="(?:$f_tag_nbannee|$f_tag_ltannee)";

#$tag_duree='<duree>';
#$f_tag_duree='</duree>';
$tag_daterel='<date type="relative">';
$f_tag_daterel='</date>';

$tag_duree_date='<duree type="date">';
$f_tag_duree_date='</duree>';
$tag_periode='<duree type="intervalle">';
$f_tag_periode='</duree>';
$tag_duree="(?:$tag_duree_date|$tag_periode)";
$f_tag_duree="(?:$f_tag_duree_date|$f_tag_periode)";

$pref_duree_eq = '(?:[C,c]ette|[C,c]et|[C,c]e|[E,e]n)';
$pref_duree_in = '(?:Courant|courant|pendant|Pendant|durant|Durant|Chaque|chaque|[D,d]ans la|[D,d]ans l\'|[E,e]n cours d\'|[A,a]u courant de la|[A,a]u courant de l\'|[A,a]u courant du|[D,d]urant la|[D,d]urant le|[D,d]urant l\')';
$pref_duree_in_mid = '(?:mi|mi-|[A,a]u milieu du|[A,a]u milieu de la|[A,a]u milieu de l\'|[E,e]n milieu d\'|[E,e]n milieu de|[E,e]n milieu)';
$pref_duree_in_inf = '(?:début|début-|[E,e]n début d\'|[E,e]n début de|[A,a]u début du|[A,a]u début de l\'|[A,a]u début de la|[E,e]n début)';
$pref_duree_inf = '(?:avant|Avant)';
$pref_duree_in_sup = '(?:fin|fin-|[E,e]n fin de|[E,e]n fin d\'|[E,e] fin)';
$pref_duree_sup = '(?:Depuis|depuis)';
$pref_duree = "$pref_duree_eq|$pref_duree_in|$pref_duree_in_mid|$pref_duree_in_inf|$pref_duree_in_sup|$pref_duree_inf|$pref_duree_sup";

$tag_modifieur_inf='<mod-pre type="inf">';
$tag_modifieur_in_inf='<mod-pre type="in-inf">';
$tag_modifieur_in='<mod-pre type="in">';
$tag_modifieur_in_mid='<mod-pre type="in-mid">';
$tag_modifieur_sup='<mod-pre type="sup">';
$tag_modifieur_in_sup='<mod-pre type="in-sup">';
$tag_modifieur_eq='<mod-pre type="eq">';
$tag_modifieur='<mod-pre>';
$f_tag_modifieur='</mod-pre>';

$tag_modifieur_post_inf='<mod-post type="inf">';
$tag_modifieur_post_sup='<mod-post type="sup">';
$f_tag_modifieur_post='</mod-post>';

$tag_age='<age>';
$f_tag_age='</age>';

$tag_saison='<saison>';
$f_tag_saison='</saison>';

#autres (temporaires-locales)
$tag_modifieur_heure='<mod-heure>';
$f_tag_modifieur_heure='</mod-heure>';
$tag_modifieur_date='<mod-date>';
$f_tag_modifieur_date='</mod-date>';
$tag_modifieur_duree='<mod-duree>';
$f_tag_modifieur_duree='</mod-duree>';
$tag_modifieur_post='<mod-post>';
$f_tag_modifieur_post='</mod-post>';

#temporaires2
$tag_mois_annee='<timex-ma TYPE="MOIS_ANNEE">';
$f_tag_mois_annee='</timex-ma>';
$tag_jour_mois='<timex-jm TYPE="DATEDM">';
$f_tag_jour_mois='</timex-jm>';
#$tag_day='<timex TYPE="DAY">';
#$f_tag_day='</timex>';
$tag_periode_day='<timex-pd TYPE="PERIOD_DAY">';
$f_tag_periode_day='</timex-pd>';
$tag_duree_day='<timex-dd TYPE="DUREE_DAY">';
$f_tag_duree_day='</timex-dd>';
$tag_duree_jm='<timex-dj TYPE="DURATION-JM">';
$f_tag_duree_jm='</timex-dj>';


###########################################################
################   REGLES   ##############################
##########################################################

# input file
while(<FILEInputText>){
    

    # lines of text containing words and possible html
    # marks (without blanks inside)
 
    if( !/^\<[^>]+\> *$/ ) {
	chop;

        # saute les lignes contenant certaines balises de debut de
        # document avec des choses derrieres
	if (!/^$baliseBG/)
	{              
            ############################################################
            # Reconaissance de différents types de nombre              #
            ############################################################

   	    #reconnaissance des nombres entier en chiffre
         s/($nombre_entier)/$tag_entier$1$f_tag_entier/g;
	    #reconnaissance des nombres reels en chiffre
	    s/$entier_tagge($virgule)$entier_tagge/$tag_reel$2$4$6$f_tag_reel$8/g;

	    #reconnaissance nombre en lettre
	    s/(\s|^)($card_let)(\s|$|$ponctuation|$not_let)/$1$tag_entier_let$2$f_tag_entier_let$3/g;
         #reconnaissance des nombres en douzaine millier etc.
	    s/(\s|^)($numene)(\s|$|$ponctuation|$not_let)/$1$tag_numene$2$f_tag_numene$3/g;
	    # reconcatener dizaine de milliers 
	    while (m/$tag_numene[^<]+$f_tag_numene $De $tag_numene[^<]+$f_tag_numene/){
	         s/($tag_numene)([^<]+)($f_tag_numene) ($De) ($tag_numene)([^<]+)($f_tag_numene)/$1$2 $4 $6$7/g;
	    }
	   
         s/($tag_entier)($nombre_entier)($f_tag_entier) ($tag_numene)([^<]+)($f_tag_numene)/$tag_numene$2 $5$fin_tag_numene/g;
	    s/($tag_entier_let)($card_let)($f_tag_entier_let) ($tag_numene)([^<]+)($f_tag_numene)/$tag_numene$2 $5$f_tag_numene/g;
	    s/(\s|^)($plusieurs) ($tag_numene)([^<]+)($f_tag_numene)/$1$tag_numene$2 $4$f_tag_numene/g;

         #reconnaissance des ordinaux 1er 2ème 125ème
	    s/($tag_entier)($nombre_entier)($f_tag_entier)($ieme)(\s|$|$ponctuation|$not_let)/$tag_entier_ord$2$4$f_tag_entier_ord$5/g;
	    s/($tag_entier_let)([^<]+)($f_tag_entier_let) ($ord_let)(\s|$|$ponctuation|$not_let)/$tag_entier_ord$2 $4$f_tag_entier_ord$5/g;
	    s/($ord_let)([^<])/$tag_entier_ord$1$f_tag_entier_ord$2/g;
            
####################################################################################################################
# Reconaissance des dates et heures http://fr.wikipedia.org/wiki/ISO_8601 ##########################################
####################################################################################################################
            
#=============================================
#Date/heure dans le format standard
#=============================================

           #reconnaissance d'une date en iso8601 (partiel) : YYYY-MM-DDTHH:MM:SS
#           s/($tag_entier)($card_num_annee4)($f_tag_entier)($tiret)($tag_entier)($card_num_mois)($f_tag_entier)($tiret)($tag_entier)($card_num_jour)($f_tag_entier)$T($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)($deux_points)($tag_entier)($timeNumMin)($f_tag_entier)($deux_points)($tag_entier)($timeNumSec)($f_tag_entier)/$tag_datetime$tag_date$tag_nbannee$2$f_tag_nbannee-$tag_nbmois$6$f_tag_nbmois-$tag_nbnojour$10$f_tag_nbnojour$f_tag_date$T$tag_heure$tag_nbheure2$13$f_tag_nbheure2:$tag_nbminute$17$f_tag_nbminute:$tag_nbseconde$21$f_tag_nbseconde$f_tag_heure$f_tag_datetime/g;
           s/($tag_entier)($card_num_annee4)($f_tag_entier)($tiret)($tag_entier)($card_num_mois)($f_tag_entier)($tiret)($tag_entier)($card_num_jour)($f_tag_entier)/$tag_dateISO8601$tag_nbannee$2$f_tag_nbannee-$tag_nbmois$6$f_tag_nbmois-$tag_nbnojour$10$f_tag_nbnojour$f_tag_dateISO8601/g;
           s/($T)($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)($deux_points)($tag_entier)($timeNumMin)($f_tag_entier)($deux_points)($tag_entier)($timeNumSec)($f_tag_entier)/$tag_heureISO8601$1$tag_nbheure2$3$f_tag_nbheure2:$tag_nbminute$7$f_tag_nbminute:$tag_nbseconde$11$f_tag_nbseconde$f_tag_heureISO8601/g;
 #s/($tag_date.+?$f_tag_date)($tag_heure$T.+?$f_tag_heure)/$tag_datetimeISO$1$2$f_tag_datetimeISO/g;
 
#=============================================
#Date article ATS (base articles de journaux) ATS.<numex TYPE="NUMBER">940109.0047</numex>
#=============================================
#s/ATS\.($tag_entier)($card_num_annee4)($card_num_mois)($card_num_jour)\.([^<]+?)($f_tag_entier)/ATS\.$tag_dateISO8601$tag_nbannee$2$f_tag_nbannee$tag_nbmois$3$f_tag_nbmois$tag_nbnojour$4$f_tag_nbnojour$f_tag_dateISO8601\.$tag_entier$5$f_tag_entier/g;
#s/ATS\.($tag_entier)($card_num_annee2)($card_num_mois)($card_num_jour)\.([^<]+?)($f_tag_entier)/ATS\.$tag_dateISO8601$tag_nbannee$2$f_tag_nbannee$tag_nbmois$3$f_tag_nbmois$tag_nbnojour$4$f_tag_nbnojour$f_tag_dateISO8601\.$tag_entier$5$f_tag_entier/g;

#=============================================
#Heure toute seule
#=============================================
	    
            #reconnaissance des heures HH:MM ou HH:MM:SS (heure iso8601 sans date 
            # et le T normalement obligatoire)
            s/($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)($deux_points)($tag_entier)($timeNumMin)($f_tag_entier)($deux_points)($tag_entier)($timeNumSec)($f_tag_entier)/$tag_heureISOXXXX$tag_nbheure2$2$f_tag_nbheure2:$tag_nbminute$6$f_tag_nbminute:$tag_nbseconde$10$f_tag_nbseconde$f_tag_heureISOXXXX/g;
	        s/($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)($deux_points)($tag_entier)($timeNumMin)($f_tag_entier)/$tag_heureISOXXXX$tag_nbheure2$2$f_tag_nbheure2:$tag_nbminute$6$f_tag_nbminute$f_tag_heureISOXXXX/g;

             #reconnaissance des heures entierhentier 02h00 GMT
	    s/($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)(H|h)($tag_entier)($timeNumMin)($f_tag_entier) ($timeCompo)(\s|$|$not_let)/$tag_heureISOXXXX$tag_nbheure2$2$f_tag_nbheure2$4$tag_nbminute$6$f_tag_nbminute $8$f_tag_heureISOXXXX$9/g;

             #reconnaissance des heures entierhentier 02h00
	    s/($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)(H|h)($tag_entier)($timeNumMin)($f_tag_entier)/$tag_heureISOXXXX$tag_nbheure2$2$f_tag_nbheure2$4$tag_nbminute$6$f_tag_nbminute$f_tag_heureISOXXXX/g;

	    	# le traitement de 2 heures 3 minutes ou 2 heures 36 min. 
	    	# "(à|pour) 12 heures 30 (minutes)"...
	    	# 6 heures 18 = heure ; 6 heures 18 minutes (sans préposition) = durée
	    	
	    	
s/($pref_heure)\s+($tag_heure)(.+?)($f_tag_heure)/$2$tag_modifieur_heure$1$f_tag_modifieur_heure $3$4/g;	    	
# avec des chiffres
s/($pref_heure)\s+$tag_entier($timeNumHour24|$timeNumHour12)$f_tag_entier\s+($timeUnitHeure)\s+$tag_entier($timeNumMin)$f_tag_entier\s+($timeUnitMinute)\s+$tag_entier($timeNumSec)$f_tag_entier\s+($timeUnitSeconde)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_nbheure2$2$f_tag_nbheure2 $3 $tag_nbminute$4$f_tag_nbminute $5 $tag_nbseconde$6$f_tag_nbseconde $7$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier($timeNumHour24|$timeNumHour12)$f_tag_entier\s+($timeUnitHeure)\s+$tag_entier($timeNumMin)$f_tag_entier\s+($timeUnitMinute)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_nbheure2$2$f_tag_nbheure2 $3 $tag_nbminute$4$f_tag_nbminute $5$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier($timeNumHour24|$timeNumHour12)$f_tag_entier\s+($timeUnitHeure)\s+$tag_entier($timeNumMin)$f_tag_entier/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_nbheure2$2$f_tag_nbheure2 $3 $tag_nbminute$4$f_tag_nbminute$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier($timeNumHour24|$timeNumHour12)$f_tag_entier\s+($timeUnitHeure)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_nbheure2$2$f_tag_nbheure2 $3$f_tag_heure_lin/g;

# avec des lettres
s/($pref_heure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitHeure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitMinute)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitSeconde)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_ltheure2$2$f_tag_ltheure2 $3 $tag_ltminute$4$f_tag_ltminute $5 $tag_ltseconde$6$f_tag_ltseconde $7$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitHeure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitMinute)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_ltheure2$2$f_tag_ltheure2 $3 $tag_ltminute$4$f_tag_ltminute $5$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitHeure)\s+$tag_entier_let([^<]+)$f_tag_entier_let/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_ltheure2$2$f_tag_ltheure2 $3 $tag_ltminute$4$f_tag_ltminute$f_tag_heure_lin/g;

s/($pref_heure)\s+$tag_entier_let([^<]+)$f_tag_entier_let\s+($timeUnitHeure)/$tag_heure_lin$tag_modifieur_heure$1$f_tag_modifieur_heure $tag_ltheure2$2$f_tag_ltheure2 $3$f_tag_heure_lin/g;

#=============================================
#Repérage des morceaux "faciles" sur les dates
#=============================================

 	    #reconnaissance des mois (tout seul)  mai juin etc.
	    s/(\s|^|$ponctuation|$not_let)($mois)(\s|$|$ponctuation|$not_let)/$1$tag_ltmois$2$f_tag_ltmois$3/g;
		      
	    #reconnaissance  des jours (tout seul) lundi mardi etc.
	    s/(\s|^|$ponctuation|$not_let|$Le)($jour_ch)(\s|$|$ponctuation|$not_let)/$1$tag_jour$2$f_tag_jour$3/g;
	    
	    #reconnaissance DD-MM-YYYY ou DD/MM/YYYY (date)
	    s/($tag_entier)($card_num_jour)($f_tag_entier)($tiret|$slash)($tag_entier)($card_num_mois)($f_tag_entier)($tiret|$slash)($tag_entier)($card_num_annee4|$card_num_annee2)($f_tag_entier)/$tag_dateISOXXXX$tag_nbnojour$2$f_tag_nbnojour$4$tag_nbmois$6$f_tag_nbmois$8$tag_nbannee$10$f_tag_nbannee$f_tag_dateISOXXXX/g;
	    
	    #reconnaissance DD-MM ou DD/MM (date)
	    s/($tag_entier)($card_num_jour)($f_tag_entier)($tiret|$slash)($tag_entier)($card_num_mois)($f_tag_entier)/$tag_dateISOXXXX$tag_nbnojour$2$f_tag_nbnojour$4$tag_nbmois$6$f_tag_nbmois$f_tag_dateISOXXXX/g;
	    
	                
#=============================================
#Dates avec les années
#=============================================

	    #reconnaissance  mois tagge puis annee : <...>mai<....> 1999
	    s/($tag_mois)($mois)($f_tag_mois) ($tag_entier)($card_num_annee)($f_tag_entier)/$tag_mois_annee$1$2$3 $tag_nbannee$5$f_tag_nbannee$f_tag_mois_annee/g;
	    s/($tag_mois)($mois)($f_tag_mois) ($tag_entier_let)($card_let_annee)($f_tag_entier_let)/$tag_mois_annee$1$2$3 $tag_ltannee$5$f_tag_ltannee$f_tag_mois_annee/g;
	    
	    #reconnaissance jour suivi <...>mois annee</...> : 5 <....>mai 1999</....> => <...> 5 mai 1999 </...>
	    s/($tag_entier)($card_num_jour)($f_tag_entier) ($tag_mois_annee)($tag_mois[^<]+$f_tag_mois\s+$tag_annee[^<]+$f_tag_annee)($f_tag_mois_annee)/$tag_date_lin$tag_nbnojour$2$f_tag_nbnojour $5$f_tag_date_lin/g;
	    s/($tag_entier_let)($card_let_jour)($f_tag_entier_let) ($tag_mois_annee)($tag_mois[^<]+$f_tag_mois\s+$tag_annee[^<]+$f_tag_annee)($f_tag_mois_annee)/$tag_date_lin$tag_ltnojour$2$f_tag_ltnojour $5$f_tag_date_lin/g;
        s/($tag_entier_ord)($card_num_ord)($f_tag_entier_ord) ($tag_mois_annee)($tag_mois[^<]+$f_tag_mois\s+$tag_annee[^<]+$f_tag_annee)($f_tag_mois_annee)/$tag_date_lin$tag_ltnojour$2$f_tag_ltnojour $5$f_tag_date_lin/g;

        #reconnaissance vendredi + 5 mai 1999
        s/($tag_jour[^<]+$f_tag_jour) ($tag_date)(.+?)($f_tag_date)/$tag_date_lin$1 $3$f_tag_date_lin/g;
        
        #reconnaissances "les années 80" ou "en l'an 2000"
            s/(\s|^)($annee_det) ($tag_entier)($card_num_annee)($f_tag_entier)/$1$tag_date_lin$2 $4$f_tag_date_lin/g;
            s/(\s|^)($annee_det) ($tag_entier_let)($card_let_annee)($f_tag_entier_let)/$1$tag_date_lin$2 $4$f_tag_date_lin/g;

            #reconnaissance "printemps 2010"
            s/(\s|^)($Saison) ($tag_entier)($card_num_annee)($f_tag_entier)/$1$tag_date_lin$tag_saison$2$f_tag_saison $tag_nbannee$4$f_tag_nbannee$f_tag_date_lin/g;
#            s/(\s|^)($Saison) ($tag_entier)($card_num_annee)($f_tag_entier)/$1$tag_duree_date$tag_saison$2$f_tag_saison $tag_nbannee$4$f_tag_nbannee$f_tag_duree_date/g;

        #reconnaissance XIe siècle ou 11ème siècle ou onzième siècle
	    s/(\s|^)($nombre_rom$ieme)( $scie_mil)(\s|$|$ponctuation)/$1$tag_date_lin$2$3$f_tag_date_lin$4/g;
        s/($tag_entier_ord)([^>]+)($f_tag_entier_ord)( $scie_mil)(\s|$|$ponctuation)/$tag_date_lin$2$4$f_tag_date_lin$5/g;

	    # 2001,

	    s/($tag_entier)($card_num_annee4)($f_tag_entier)($ponctuation)(\s|$)/$tag_date_lin$2$f_tag_date_lin$4$5/g;

#=============================================
#Dates sans les années
#=============================================

#------------------------------------------------------------------------------------ A retravailler ! -------------
            #reconnaissance : 12 et 21 mai
	        s/($tag_entier)($card_num_jour)($f_tag_entier)( $et_ou )($tag_entier)($card_num_jour)($f_tag_entier) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_nbnojour$2$f_tag_nbnojour$4 $tag_nbnojour$6$f_tag_nbnojour $8$f_tag_jour_mois/g;
            s/($tag_entier)($card_num_jour)($f_tag_entier)( $et_ou )($tag_entier_ord)(1er)($f_tag_entier_ord) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_nbnojour$2$f_tag_nbnojour$4 $tag_nbnojour$6$f_tag_nbnojour $8$f_tag_jour_mois/g;
            s/($tag_entier_ord)(1er)($f_tag_entier_ord)( $et_ou )($tag_entier)($card_num_jour)($f_tag_entier) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_nbnojour$2$f_tag_nbnojour$4 $tag_nbnojour$6$f_tag_nbnojour $8$f_tag_jour_mois/g;
#------------------------------------------------------------------------------------------------------------------

	    #reconnaissance de jour puis mois : 5 mai
            s/($tag_entier)($card_num_jour)($f_tag_entier) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_nbnojour$2$f_tag_nbnojour $4$f_tag_jour_mois/g;
            s/($tag_entier_let)($card_let_jour)($f_tag_entier_let) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_ltnojour$2$f_tag_ltnojour $4$f_tag_jour_mois/g;
            s/($tag_entier_ord)(1er)($f_tag_entier_ord) ($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_ordnojour$2$f_tag_ordnojour $4$f_tag_jour_mois/g;

           # si le mois est collé au numéro 12mai
           s/($tag_entier)($card_num_jour)($f_tag_entier)($tag_mois$mois$f_tag_mois)/$tag_jour_mois$tag_nbnojour$2$f_tag_nbnojour $5$f_tag_jour_mois/g;

	    #reconnaissance mercredi 29 mai
	    s/($tag_jour[^<]+$f_tag_jour) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$2$1 $3$4/g;
            
         s/($tag_jour)([^<]+)($f_tag_jour) ($tag_entier)($card_num_jour)($f_tag_entier) ($to) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$tag_duree_jm$2 $5 $7 $9$f_tag_duree_jm/g;

	    s/($tag_jour_mois)(.+?)($f_tag_jour_mois) ($to) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$tag_duree_jm$2 $4 $6$f_tag_duree_jm/g;

####################################################################################################################
# Reconnaissance des durées                                                #########################################
####################################################################################################################
            
          # recoller 31 mai-30 juin 1999 <jour_mois>-<date> tout duree_date
          s/($tag_jour_mois)(.+?)($f_tag_jour_mois)(-| - )($tag_date)(.+?)($f_tag_date)/$tag_duree_date$2$4$6$f_tag_duree_date/g;

          # reconnaissance duree de date du 8 janvier au 5 février 2002
          s/(\s$from|^$from) ($tag_jour_mois)(.+?)($f_tag_jour_mois) ($to) ($tag_date)(.+?)($f_tag_date)/$1 $tag_duree_date$3 $5 $7$f_tag_duree_date/g;

            # reconnaissance duree de date du 8 janvier au 5 février
            s/(\s$from|^$from) ($tag_jour_mois)(.+?)($f_tag_jour_mois) ($to) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$1 $tag_duree_date$3 $5 $7$f_tag_duree_date/g;

            # reconnaissance duree de date du 8 au 5 février
            s/(\s$from|^$from) ($tag_entier)($card_num_jour)($f_tag_entier) ($to) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$tag_duree_date xxx$1 $tag_nbnojour$3$f_tag_nbnojour $5 $7 xxx$f_tag_duree_date/g;
            s/(\s$from|^$from) ($tag_entier_ord)(1er)($f_tag_entier_ord) ($to) ($tag_jour_mois)(.+?)($f_tag_jour_mois)/$tag_duree_date$1 $tag_nbnojour$3$f_tag_nbnojour $5 $7$f_tag_duree_date/g;

            #
            #reconnaissance $tag_jour_mois .. f_tag_jour_mois prochain => DATEREL
#	    s/($tag_duree_date)(.+?)($f_tag_duree_date) ($modif_date_ap)/$tag_daterel xxxxx $2 $tag_modifieur_post$4$f_tag_modifieur_post xxxx $f_tag_daterel/g;
#	    s/($tag_jour_mois)(.+?)($f_tag_jour_mois) ($modif_date_ap)/$tag_daterel yyyyyy $2 $tag_modifieur_post$4$f_tag_modifieur_post yyyyyy $f_tag_daterel/g;


            #reconnaissance duree de date de 1999 à 2000
            s/(\s$from|^$from) ($tag_entier)($card_num_annee4)($f_tag_entier) ($to) ($tag_entier)($card_num_annee4)($f_tag_entier)/$1 $tag_duree_date$tag_nbannee$3$f_tag_nbannee $5 $tag_nbannee$7$f_tag_nbannee$f_tag_duree_date/g;

            #reconnaissance duree de date 1999-2000
            s/\s($tag_entier)($card_num_annee4)($f_tag_entier)(\-)($tag_entier)($card_num_annee4)($f_tag_entier)\s/ $tag_duree_date$tag_nbannee$2$f_tag_nbannee-$tag_nbannee$6$f_tag_nbannee$f_tag_duree_date /g;


        #reconnaissance des durées 1 à 1
	    s/$entier_tagge( $timeUnit)(\s|$ponctuation|$|$not_let)/$tag_periode$2$4$f_tag_periode$5/g;
	    s/$entier_let_tagge( $timeUnit)(\s|$ponctuation|$|$not_let)/$tag_periode$2$4$f_tag_periode$5/g;
        s/($plusieurs)( $timeUnit)(\s|$ponctuation|$|$not_let)/$tag_periode$1$2$f_tag_periode$3/g;
	    s/($tag_numene)([^<]+)($f_tag_numene) ($De$timeUnit|$De$blanc$timeUnit|$timeUnit)(\s|$ponctuation|$|$not_let)/$tag_periode$2 $4$f_tag_periode$5/g;
	    s/($tag_duree)(.+?)($f_tag_duree)\s+($tag_entier)($timeNumMin)($f_tag_entier)/$1$2 $5$3/g;

	    #reconcaténer les durées <...>5 jours<..> <...>4 nuits<...> <...>3 heures<...>
	    while (m/$tag_duree.+?$f_tag_duree $tag_duree.+?$f_tag_duree/){
	         s/($tag_duree)(.+?)($f_tag_duree) ($tag_duree)(.+?)($f_tag_duree)/$1$2 $5$6/g;
	    }
	   
	    # reconnaissance daterel c'est une durée suivi par plus tot ou plus tard ou à venir
	    #s/($tag_duree)(.+?)($f_tag_duree) ($plus_tot|$plus_tard|$a_venir)(\s|$|$ponctuation|$not_let)/$tag_daterel$2 $4$f_tag_daterel$5/g;

        #reconnaissance de l'age
        s/(\s|^)($AgeDe) ($tag_duree)(.+?)($f_tag_duree)/$1$tag_age$2 $4$f_tag_age/g;

	    # avons 22 ans
	     s/(\s|^)($Avoir) ($tag_duree)(.+?)($f_tag_duree)/$1$2 $tag_age$4$f_tag_age/g;

	    #reconcatener les entiers <...>1<...> <...>200<...> <...>129<...>
	    while (m/$tag_entier[^<]+$f_tag_entier $tag_entier[^<]+$f_tag_entier/)
            {
	         s/($tag_entier)([^<]+)($f_tag_entier) ($tag_entier)([^<]+)($f_tag_entier)/$1$2 $5$6/g;
	
	    }

            # Jeudi à Vendredi tout cour période
            s/($tag_jour)([^<]+)($f_tag_jour) ($to) ($tag_jour)([^<]+)($f_tag_jour)/$tag_duree_day$2 $4 $6$f_tag_duree_day/g;
            
            # Mois annee restant en Date-duration
	    s/(\s|^)($modifDayS) ($tag_mois_annee)(.+?)($f_tag_mois_annee)/$1 $tag_duree_date$tag_modifieur_duree$2$f_tag_modifieur_duree $4$f_tag_duree_date/g;
            s/($tag_mois_annee)(.+?)($f_tag_mois_annee)/$tag_duree_date$2$f_tag_duree_date/g;

             # reconnaissance periode en matinée, le matin, etc
	    if (m/(\s|^)($modifDayS)($partOfDayS| $partOfDayS)(\s|$|$ponctuation|$not_let)/){
                  s/(\s|^)($modifDayS)($partOfDayS| $partOfDayS)(\s|$|$ponctuation|$not_let)/$1$tag_periode_day$tag_modifieur_duree$2$3$f_tag_modifieur_duree$f_tag_periode_day$4/g;
	    }else{
                s/(\s|^)($modifDayS)($timeUnitS| $timeUnitS)(\s|$|$ponctuation|$not_let)/$1$tag_periode$tag_modifieur_duree$2$3$f_tag_modifieur_duree$f_tag_periode$4/g;
	    }
          
            # dans la nuit de jeudi à vendredi
            s/($tag_periode_day)([^<]+)($f_tag_periode_day) ($De) ($tag_duree_day)([^<]+)($f_tag_duree_day)/$tag_periode$2 $4 $6$f_tag_periode/g;
 
            # dans la nuit du 5 janvier au 10 févier
            s/($tag_periode_day)([^<]+)($f_tag_periode_day) ($De) ($tag_duree_jm)(.+?)($f_tag_duree_jm)/$tag_periode$2 $4 $6$f_tag_periode/g;

            # dans la nuit du 50 Janvier 2001
            s/($tag_periode_day)([^<]+)($f_tag_periode_day) ($De) ($tag_date)(.+?)($f_tag_date)/$tag_duree_date$2 $4 $6$f_tag_duree_date/g;

            # dans la nuit du 6 janvier au 7 Janvier 2002
            s/($tag_periode_day)([^<]+)($f_tag_periode_day) ($De) ($tag_duree_date)(.+?)($f_tag_duree_date)/$tag_duree_date$2 $4 $6$f_tag_duree_date/g;
            
            #reconnaissance <lundi>jour après midi en jour
            s/($tag_jour[^<]+$f_tag_jour)( $tag_periode_day)([^<]+)($f_tag_periode_day)/$tag_jour$1 $4$f_tag_jour/g;
	       s/($tag_jour[^<]+$f_tag_jour)( $partOfDayS)(\s|$|$ponctuation|$not_let)/$tag_jour$1$2$f_tag_jour$5/g;

            #reconnaissance en début novembre
            s/(\s|^)($modifDayS|$defMois) ($tag_mois.+?$f_tag_mois)/$1$tag_periode$tag_modifieur_duree$2$f_tag_modifieur_duree $3$f_tag_periode/g;
            s/(\s|^)($modif_date_av) ($tag_mois.+?$f_tag_mois)/$1$tag_periode$tag_modifieur_duree$2$f_tag_modifieur_duree$3$f_tag_periode/g;

            # remettre les periodes de jour à periode
            s/($tag_periode_day)([^<]+)($f_tag_periode_day)/$tag_periode$2$f_tag_periode/g;
            s/($tag_duree_day)([^<]+)($f_tag_duree_day)/$tag_periode$2$f_tag_periode/g;

            #chaque lundi en période et chaque matin en période
	        s/(\s|^)($Chaque) ($tag_jour[^<]+$f_tag_jour)/$1$tag_periode$2 $3$f_tag_periode/g;
            s/(\s|^)($Chaque) ($timeUnitS|$partOfDayS)(\s|$|$ponctuation|$not_let)/$1$tag_periode$2 $3$f_tag_periode$4/g;

            #durant des siècles (années)
	        s/(\s|^)($durantdes) ($timeUnit)(\s|$|$ponctuation|$not_let)/$1$tag_periode$2 $3$f_tag_periode$4/g;
        
        		# manque "durant" puis date => durée
        		
        		# gestion "en novembre dernier"
        		s/($tag_periode)(.+?)($f_tag_periode) ($modif_date_ap)/$tag_periode$2 $tag_modifieur_post$4$f_tag_modifieur_post$f_tag_periode/g;
        
            #deux dernières années
            s/($tag_entier)([^<]+)($f_tag_entier) ($modif_date_ap) ($timeUnit)(\s|$|$ponctuation|$not_let)/$tag_daterel$2 $tag_modifieur_post$4$f_tag_modifieur_post $5$f_tag_daterel$6/g;
	       s/($tag_entier_let)([^<]+)($f_tag_entier_let) ($modif_date_ap) ($timeUnit)(\s|$|$ponctuation|$not_let)/$tag_daterel$2 $tag_modifieur_post$4$f_tag_modifieur_post $5$f_tag_daterel$6/g;
            
            # au courant de l'année 2200
            s/($tag_periode)([^<]+)($f_tag_periode) ($tag_entier)($card_num_annee)($f_tag_entier)/$tag_duree_date$2 $tag_nbannee$5$f_tag_nbannee$f_tag_duree_date/g;
#            s/($tag_entier)([^<]+)($f_tag_entier)(-)($tag_entier)([^<]+)($f_tag_entier)/$tag_score$2$4$6$f_tag_score/g;

#############################################################################################
# Fusion date et heure (fait ailleurs, manip XML pure)
#############################################################################################

 		# "le 5 octobre (2005), 6 heures 18,"...
#		s/($tag_date)([^<]+)($f_tag_date)(\s+\,|\s*|\s+$a)\s+($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)\s+($timeUnitHeure)\s+($tag_entier)($timeNumMin)($f_tag_entier)\s+($timeUnitMinute)\s+($tag_entier)($timeNumSec)($f_tag_entier)\s+($timeUnitSeconde)/$tag_datetime$4$4 $3 $6 $8 $10 $12 $14 $16$f_tag_datetime/g;
#		s/($tag_date)([^<]+)($f_tag_date)(\s+\,|\s*|\s+$a)\s+($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)\s+($timeUnitHeure)\s+($tag_entier)($timeNumMin)($f_tag_entier)\s+($timeUnitMinute)/$tag_datetime$4$4 $3 $6 $8 $10 $12$f_tag_datetime/g;
#		s/($tag_date)([^<]+)($f_tag_date)(\s+\,|\s*|\s+$a)\s+($tag_entier)($timeNumHour24|$timeNumHour12)($f_tag_entier)\s+($timeUnitHeure)\s+($tag_entier)($timeNumMin)($f_tag_entier)/$tag_datetime$2$4 $6 $8 $10$f_tag_datetime/g;
		
#		s/($tag_date)(.+?)($f_tag_date)(\s+\,\s+|\s+|\s+$a\s+)($tag_heure|$tag_duree)(.+?)($f_tag_heure|$f_tag_duree)/$tag_datetime$1$2$3$4$5$6$7$f_tag_datetime/g;
#		s/($tag_date)(.+?)($f_tag_date)\s+\((\s+$a\s+|\s+)($tag_heure|$tag_duree)(.+?)($f_tag_heure|$f_tag_duree)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6$7 )$f_tag_datetime/g;
#		s/($tag_heure)(.+?)($f_tag_heure)\s+\((\s+$Le\s+|\s+)($tag_date|$tag_duree)(.+?)($f_tag_date|$f_tag_duree)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6$7 )$f_tag_datetime/g;


        s/($tag_dateISO8601.+?$f_tag_dateISO8601)($tag_heureISO8601.+?$f_tag_heureISO8601)/$tag_datetimeISO8601$1$2$f_tag_datetimeISO8601/g;
        s/($tag_dateISOXXXX.+?$f_tag_dateISOXXXX)(\s|\s\,\s)($tag_heureISOXXXX.+?$f_tag_heureISOXXXX)/$tag_datetimeISOXXXX$1$2$3$f_tag_datetimeISOXXXX/g;
        
#		s/($tag_date_lin)(.+?)($f_tag_date_lin)\s($tag_heure_lin)(.+?)($f_tag_heure_lin)/$tag_datetime_lin$1$2$3 $4$5$6$f_tag_datetime_lin/g;
#		s/($tag_date_lin)(.+?)($f_tag_date_lin)(\s\,\s)($tag_heure_lin)(.+?)($f_tag_heure_lin)/$tag_datetime_lin$1$2$3$4$5$6$7$f_tag_datetime_lin/g;
		#s/($tag_date)(.+?)($f_tag_date)\s+\(\s+($tag_heure)(.+?)($f_tag_heure)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6 )$f_tag_datetime/g;
		#s/($tag_heure)(.+?)($f_tag_heure)\s+\(\s+($tag_date)(.+?)($f_tag_date)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6 )$f_tag_datetime/g;
		
		#s/($tag_date)(.+?)($f_tag_date)(\s+)($tag_duree)(.+?)($f_tag_duree)/$tag_datetime$1$2$3$4$5$6$7$f_tag_datetime/g;
		#s/($tag_date)(.+?)($f_tag_date)(\s+\,\s+)($tag_duree)(.+?)($f_tag_duree)/$tag_datetime$1$2$3$4$5$6$7$f_tag_datetime/g;
		#s/($tag_date)(.+?)($f_tag_date)\s+\(\s+($tag_duree)(.+?)($f_tag_duree)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6 )$f_tag_datetime/g;
		#s/($tag_duree)(.+?)($f_tag_duree)\s+\(\s+($tag_date)(.+?)($f_tag_date)[^)]+\)/$tag_datetime$1$2$3 ( $4$5$6 )$f_tag_datetime/g;
		
#############################################################################################
# Divers
#############################################################################################
	    # Remettre les jours isoles en Day
        s/($tag_jour)([^<]+)($f_tag_jour)/$tag_day$2$f_tag_day/g;

        # Remettre les jours-mois isolés en date
            #s/($tag_mois)([^<]+)($f_tag_mois)/$tag_periode$2$f_tag_periode/g;
		s/($tag_jour_mois)(.+?)($f_tag_jour_mois)/$tag_date_lin$2$f_tag_date/g;
		   	       
            # Ajouter (en, depuis...) à la date
            s/(\s|^)($pref_date) ($tag_date)(.+?)($f_tag_date)/$1$3$tag_modifieur_date$2$f_tag_modifieur_date $4$5/g;
            s/(\s|^)($pref_date) ($tag_duree)(.+?)($f_tag_duree)/$1$3$tag_modifieur_date$2$f_tag_modifieur_date $4$5/g;
                        
           #reconnaissance date (en ou depuis) 1999
	        s/(\s|^)($pref_date) ($tag_entier)($card_num_annee4)($f_tag_entier)( et )($tag_entier)($card_num_annee4)($f_tag_entier)/$1$tag_date_lin$tag_modifieur_date$2$f_tag_modifieur_date $4$6$8$f_tag_date_lin/g;
            s/(\s|^)($pref_date) ($tag_entier)($card_num_annee4)($f_tag_entier)/$1$tag_date_lin$tag_modifieur_date$2$f_tag_modifieur_date $tag_nbannee$4$f_tag_nbannee$f_tag_date_lin/g;
            s/(\s|^)($pref_date) ($tag_mois_annee)(.+?)($f_tag_mois_annee)/$1$tag_date_lin$tag_modifieur_date$2$f_tag_modifieur_date $4$f_tag_date_lin/g;

            #
            #reconnaissance $tag_jour_mois .. f_tag_jour_mois prochain => DATEREL
	    s/($tag_date)(.+?)($f_tag_date) ($modif_date_ap)/$1$2 $tag_modifieur_post$4$f_tag_modifieur_post$3/g;
	    s/($tag_duree)(.+?)($f_tag_duree) ($modif_date_ap)/$1$2 $tag_modifieur_post$4$f_tag_modifieur_post$3/g;
	    
	    	    # reconnaissance daterel c'est une durée suivi par plus tot ou plus tard ou à venir
	   # s/($tag_duree)(.+?)($f_tag_duree) ($plus_tot|$plus_tard|$a_venir)/$tag_daterel$2 $4$f_tag_daterel/g;


	    
		#Ajustement du marquage des préfixes
		
		s/$tag_modifieur_heure($pref_heure_eq)$f_tag_modifieur_heure/$tag_modifieur_eq$1$f_tag_modifieur/g;
		s/$tag_modifieur_heure($pref_heure_inf)$f_tag_modifieur_heure/$tag_modifieur_inf$1$f_tag_modifieur/g;
		s/$tag_modifieur_heure($pref_heure_sup)$f_tag_modifieur_heure/$tag_modifieur_sup$1$f_tag_modifieur/g;

		s/$tag_modifieur_date($pref_date_eq)$f_tag_modifieur_date/$tag_modifieur_eq$1$f_tag_modifieur/g;
		s/$tag_modifieur_date($pref_date_inf)$f_tag_modifieur_date/$tag_modifieur_inf$1$f_tag_modifieur/g;
		s/$tag_modifieur_date($pref_date_sup)$f_tag_modifieur_date/$tag_modifieur_sup$1$f_tag_modifieur/g;

		s/$tag_modifieur_duree($pref_duree_eq)$f_tag_modifieur_duree/$tag_modifieur_eq$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_in)$f_tag_modifieur_duree/$tag_modifieur_in$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_in_mid)$f_tag_modifieur_duree/$tag_modifieur_in_mid$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_inf)$f_tag_modifieur_duree/$tag_modifieur_inf$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_sup)$f_tag_modifieur_duree/$tag_modifieur_sup$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_in_inf)$f_tag_modifieur_duree/$tag_modifieur_in_inf$1$f_tag_modifieur/g;
		s/$tag_modifieur_duree($pref_duree_in_sup)$f_tag_modifieur_duree/$tag_modifieur_in_sup$1$f_tag_modifieur/g;
		
		s/$tag_modifieur_post($post_date_inf)$f_tag_modifieur_post/$tag_modifieur_post_inf$1$f_tag_modifieur_post/g;
		s/$tag_modifieur_post($post_date_sup)$f_tag_modifieur_post/$tag_modifieur_post_sup$1$f_tag_modifieur_post/g;

         #Supprimer les nombres ordinaux
         s/($tag_entier_ord)([^<]+)($f_tag_entier_ord)/$2/g;            

         # les entiers en num ou ch et reels  restants les mettre à number
	    s/($tag_numene)([^<]+)($f_tag_numene)/$tag_number$2$f_tag_number/g;
	    s/($tag_entier)([^<]+)($f_tag_entier)/$tag_number$2$f_tag_number/g;
	    s/($tag_reel)([^<]+)($f_tag_reel)/$tag_number$2$f_tag_number/g;
	    s/($tag_entier_let)([^<]+)($f_tag_entier_let)/$tag_number$2$f_tag_number/g;

         #reconcatener les number
	    while (m/$tag_number[^<]+$f_tag_number $tag_number[^<]+$f_tag_number/){
	         s/($tag_number)([^<]+)($f_tag_number) ($tag_number)([^<]+)($f_tag_number)/$1$2 $5$6/g;
	    }
 
        # Supprimer les entiers un une isolés
	    s/($tag_number)($card_let_un)($f_tag_number)/$2/g;
            
        #Supprimer les entiers en début de phrase puis une ponctuation
	    s/^($tag_number)($entier)($f_tag_number)($ponctuation)(\s|$)/$2$4$5/g;

	    #supprimer les entiers qui commencent par une lettre
	    s/($let|$tiret)($tag_number)([^<]+)($f_tag_number)/$1$3/g;

	    #supprimer les entiers se terminant par une lettre
	    s/($tag_number)([^<]+)($f_tag_number)($let|$tiret)/$2$4/g;

		#supprimer les entiers isolés
		s/($tag_number)([^<]+)($f_tag_number)/$2/g;

           # Ajouter des blancs aux tags
	   #s/($tag_number)([^<]+)($f_tag_number)/ $1 $2 $3/g;
#           s/($tag_periode)([^<]+)($f_tag_periode)/ $1 $2 $3/g;
#           s/($tag_day)([^<]+)($f_tag_day)/ $1 $2 $3/g;
#           s/($tag_duree)([^<]+)($f_tag_duree)/ $1 $2 $3/g;
#           s/($tag_date)([^<]+)($f_tag_date)/ $1 $2 $3/g;
#           s/($tag_duree_date)([^<]+)($f_tag_duree_date)/ $1 $2 $3/g;
#           s/($tag_daterel)([^<]+)($f_tag_daterel)/ $1 $2 $3/g;
#           s/($tag_jour_mois)([^<]+)($f_tag_jour_mois)/ $1 $2 $3/g;
#           s/($tag_heure)([^<]+)($f_tag_heure)/ $1 $2 $3/g;
#           s/($tag_age)([^<]+)($f_tag_age)/ $1 $2 $3/g;


########################################"   fin des regles   ###########################################
  	 print FILEOut $_ , "\n";
       }
        # lignes avec une balise et des choses derriere a ne pas tagger
	else { 
	    print FILEOut $_ , "\n";
	}
    } 
    # line of text composed of a single html mark
    # (with blanks inside)
    else {
	print FILEOut $_;
    }
}

}
