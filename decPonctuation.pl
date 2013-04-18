#!/usr/bin/perl

# =============================================================
# CONTENT:      Filtrage des symboles
# AUTHOR:       Emmanuel MORIN
# DATE:         14/05/99
# MODIFIED : 	E. Desmontils 05/10/07
# =============================================================

# Todo :
# - Manque de recoller le '.' des sigles S.A . -> S.A. : règle = on recolle si autre ponctuation ou minuscule après ?





use locale;

$line=<STDIN>;

while($line ne "") {
 # $line =~ s/^([^ ])(.*)$/ $1$2/g;	
	
  $line =~ s/\n/ \n/;
  
  $line =~ s/\t/ /g;
  $line =~ s/([^ ])\? /$1 ? /g;
  $line =~ s/([^ ])\! /$1 ! /g;
  $line =~ s/([^ ]), /$1 , /g;
  $line =~ s/([^ ]); /$1 ; /g;
  $line =~ s/([^ ]): /$1 : /g;

  $line =~ s/([^ _])\.\.\. /$1 ... /g;	# forme... -> forme ...
  $line =~ s/([^ _])\.\.\.([^ _])/$1 ... $2/g;	# forme...forme -> forme ... forme
#$line =~ s/ \.\.\. / _..._ /g; # forme ... -> forme _..._
  $line =~ s/ \.\.\.([^ _])/ ... $2/g; # forme ...forme -> forme ... forme

  $line =~ s/\. +\n/ \. \n/g;	# ajouté par manu dans une-phrase-par-ligne.pl et déplacé par Nordine

  $line =~ s/([^ ])\(\.\) /$1 (.) /g;	# forme(.) -> forme (.)
#$line =~ s/ \(\.\) / _(.)_ /g; # forme (.) -> forme _(.)_
  $line =~ s/([^ ])\(\.\.\) /$1 (..) /g; # forme(..) -> forme (..)
#$line =~ s/ \(\.\.\) / _(.)_ /g; # forme (..) -> forme _(..)_
  $line =~ s/([^ ])\(\.\.\.\) /$1 (...) /g; # forme(...) -> forme (...)
#$line =~ s/ \(\.\.\.\) / _(...)_  /g;	# forme (...) -> forme _(...)_
  $line =~ s/([^ ])\[\.\.\.\] /$1 [...] /g; # forme[...] -> forme [...]
#$line =~ s/ \[\.\.\.\] / _[...]_  /g;	# forme [...] -> forme _[...]_
  $line =~ s/([^ ])\[\.\.\] /$1 [..] /g; # forme[..] -> forme [..]
#$line =~ s/ \[\.\.\] / _[..]_  /g; # forme [..] -> forme _[..]_
  $line =~ s/([^ ])\[\.\] /$1 [.] /g; # forme[.] -> forme [.]
#$line =~ s/ \[\.\] / _[.]_  /g; # forme [.] -> forme _[.]_
  $line =~ s/([^ ])\[\] /$1 [] /g; # forme[] -> forme []
#$line =~ s/ \[\] / _[]_  /g; # forme [] -> forme _[]_
#$line =~ s/ etc \.\.\. / _etc..._ /g;	# forme etc ... forme -> forme _etc..._ forme
#$line =~ s/ etc\.\.\. / _etc..._ /g; # forme etc... forme -> forme _etc..._ forme
  $line =~ s/ etc\.\.\.([^ ])/ etc... $1/g; # forme etc...forme  -> forme etc... forme
  $line =~ s/([^ ])etc(\.|\.\.\.)? /$1 etc$2 /g; # x, y,etc. -> x, y, etc.
  $line =~ s/ etc \. / etc. /g; # x, y, etc . -> x, y, etc.
#$line =~ s/ etc(\.|\.\.\.)? / _etc$1_ /g; # x, y, etc. -> x, y, _etc._
  $line =~ s/ etc(\.|\.\.\.)?([^ ])/ etc$1 $2/g; # x, y, etc.forme  -> x, y, etc. forme
  $line =~ s/([^ ])etc(\.|\.\.\.)?([^ ])/$1 etc$2 $3/g; # x, y,etc.forme  -> x, y, etc. forme

  $line =~ s/\(([^ ])/ ( $1/g; # (forme -> ( forme
  
  $line =~ s/([^ ])\)/$1 ) /g; # forme) -> forme )

  $line =~ s/ -([^ ])/ - $1/g; # forme -forme -> forme - forme
  $line =~ s/([^ ])- /$1 - /g; # forme- forme -> forme - forme

  $line =~ s/ «([^ ])/ « $1/g; # «forme -> « forme
  $line =~ s/\A«([^ ])/« $1/g; # «forme -> « forme
  $line =~ s/([^ ])» /$1 » /g; # forme» -> forme »
  $line =~ s/([^ ])\. «/$1 . «/g;	# forme. " -> forme . "

  $line =~ s/ \"([^ ])/ \" $1/g; # "forme -> " forme
  $line =~ s/\A\"([^ ])/\" $1/g; # "forme -> " forme
  $line =~ s/([^ =])\" /$1 \" /g; # forme" -> forme "
  $line =~ s/([^ ])\. \"/$1 \. \"/g;	# forme. " -> forme . "

  $line =~ s/((\A| )[CcDdJjLlMmNnSsTt]\')/$1 /g; # forme' -> forme '


  $line =~ s/\A //;
  $line =~ s/ \Z//g;

  $line =~ s/([^ .])\.([ \n\r])/$1 \. $2/g;
  #$line =~ s/([^ .])\.[ ]+\n/$1 \.\ \n/g;
  $line =~ s/\ ([\n\r])/$1/g;
  $line =~ s/[ ]+/ /g;
  
  #$line =~ s/([\n\r])([\n\r])+/$1$2/g;
  
  $line =~ s/\<(.*?) ([^ ]+?=".+?) (" .*?)\>/\<$1 $2$3\>/g;
  
  print STDOUT $line;
  $line=<STDIN>;
}
