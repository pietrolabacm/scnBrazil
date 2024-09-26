#!/usr/bin/perl
use POSIX;
#
# gera os limites em lat e lon das folhas cartografica de acordo com a nomeclatura cartografica nacional
# geref internacional 6o x 4o, 
# longitude dividida em fusos a partir de greewn, 
# f = 30 + lat/6 ou f * 6 - 180 = fuso, os fusos no territorio nacional são de 18 a 25 
# latitude dividida em sequencia A,B,C,D... de 4o em 4o
# 1.000.000 milionesimo (Norte ou Sul)(A,...)(fuso) ex SB 23
#   500.000 3o x 2o    nomeadas superior esquerdo V, superior direito X, inferior esquerdo Y, inferior direito Z
#   250.000 1o x 1o30' nomeadas idem A, B, C, D
#   100.000 30' x 30' (0.5) nomeadas idem I, II, III, IV, V, VI
#    50.000 15' x 15' (0.25) nomeadas idem 1, 2, 3, 4
#    25.000 7'30" x 7'30" (0.125)  nomeadas idem NO, NE, SO, SE
#
#   pontos das quadriculas: 1 CIE, 2 CSE, 3 CSD, 4 CID
#
# EMPLASA, Sistema Cartográfico Metropolitano, Governo do Estado de São Paulo, 1993:12
#    10.000 3'45" x 2'30" (0.0625 x 0.0417) nomeadas idem A, B, C, D, E, F
#     5.000  nomeadas idem I, II, III, IV  
#     2.000  nomeadas idem 1, 2, 3, 4, 5, 6
#     1.000  nomeadas idem A, B, C, D
#
# junho, 2017, Alvaro Gomes Sobral Barcellos
#
@folhas = (
"Manaus-SA-20", "Boa_Vista-NA-20", "Aracaju-SC-24", "Araguaia-SB-22", "Natal-SB-25", "Assuncion-SG-21", "Paranapanema-SF-22", "Belém-SA-22", "Pico_da_Neblina-NA-19", "Belo_Horizonte-SE-23", "Porto_Alegre-SH-22", "Porto_Velho-SC-20", "Purus-SB-20", "Brasília-SD-23", "Rio_Apa-SF-21", "Contamana-SC-18", "Rio_Branco-SC-19", "Corumbá-SE-21", "Rio_de_Janeiro-SF-23", "Cuiabá-SD-21", "Rio_Doce-SE-24", "Curitiba-SG-22", "Rio_São_Francisco-SC-23", "Fortaleza-SA-24", "Recife-SC-25", "Goiânia-SE-22", "Roraima-NB-20", "Goiás-SD-22", "Salvador-SD-24", "Guaporé-SD-20", "Santarém-SA-21", "Iça-SA-19", "São_Luís-SA-23", "Iguapé-SG-23", "Tapajós-SB-21", "Jaguaribe-SB-24", "Teresina-SB-23", "Javari-SB-18", "Tocantins-SC-22", "Juruá-SB-19", "Tumucumaque-NA-21", "Juruema-SC-21", "Uruguaiana-SH-21", "Lagoa_Mirim-SI-22", "Vitória-SF-24", "Macapá-NA-22"
);

@i500k = ( 'V', 'X', 'Y', 'Z' );
@i250k = ( 'A', 'B', 'C', 'D' );
@i100k = ( 'I', 'II', 'III', 'IV', 'V', 'VI' );
@i50k = ( '1', '2', '3', '4' );
@i25k = ( 'NO','NE','SO', 'SE' );

foreach $folha (@folhas) {

($name,$lat,$lon) = split('-',$folha);

($hm,$lt) = split (//,$lat);

# o nome da folha situa o canto superior direito

$fx = ($hm eq 'S' ? -1 : 1);

$ilat = index('ABCDEFGHIJ',$lt) * 4 * $fx;

$ilon = ($lon) * 6 - 180;

#printf ("# %s\t (%s\t %s\t %d) == %s\t %s\t %d\n", $folha, $name, $lat, $lon, $hm, $ilat, $ilon);
printf ("# %s\n", $folha);

# hemisferio SUL

if ($fx < 0) {

#1.000.000
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon-6,$ilat-4);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon-6,$ilat);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon,$ilat);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon,$ilat-4);

#500.000
$a = 0;
for ($lta = $ilat; $lta > $ilat - 4; $lta -= 2) {
for ($lga = $ilon - 6; $lga < $ilon ; $lga += 3) {

printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga,$lta-2);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga,$lta);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga+3,$lta);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga+3,$lta-2);

# 250.000
$b = 0;
for ($ltb = $lta; $ltb > $lta - 2; $ltb -= 1) {
for ($lgb = $lga; $lgb < $lga + 3; $lgb += 1.5) {

printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb,$ltb-1);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb,$ltb);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb+1.5,$ltb);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb+1.5,$ltb-1);

# 100.000
$c = 0;
for ($ltc = $ltb; $ltc > $ltb - 1; $ltc -= 0.5) {
for ($lgc = $lgb; $lgc < $lgb + 1.5; $lgc += 0.5) {

printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc,$ltc-0.5);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc,$ltc);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc+0.5,$ltc);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc+0.5,$ltc-0.5);

#  50.000
$d = 0;
for ($ltd = $ltc; $ltd > $ltc - 0.5; $ltd -= 0.25) {
for ($lgd = $lgc; $lgd < $lgc + 0.5; $lgd += 0.25) {

printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd,$ltd-0.25);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd,$ltd);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd+0.25,$ltd);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd+0.25,$ltd-0.25);

#  25.000
$e = 0;
for ($lte = $ltd; $lte > $ltd - 0.25; $lte -= 0.125) {
for ($lge = $lgd; $lge < $lgd + 0.25; $lge += 0.125) {

printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge,$lte-0.125);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge,$lte);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge+0.125,$lte);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge+0.125,$lte-0.125);

$e++;
}}

$d++;
}}

$c++;
}}

$b++;
}}

$a++;
}}

}

# hemisferio NORTE

if ($fx > 0) {

#1.000.000
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon-6,$ilat);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon-6,$ilat+4);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon,$ilat+4);
printf ("A, %s-%s, %.3f, %.3f\n",$lat,$lon,$ilon,$ilat);

#500.000
$a = 0;
for ($lta = $ilat + 4; $lta > $ilat ; $lta -= 2) {
for ($lga = $ilon - 6; $lga < $ilon ; $lga += 3) {

printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga,$lta-2);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga,$lta);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga+3,$lta);
printf ("B, %s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$lga+3,$lta-2);

# 250.000
$b = 0;
for ($ltb = $lta; $ltb > $lta - 2; $ltb -= 1) {
for ($lgb = $lga; $lgb < $lga + 3; $lgb += 1.5) {

printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb,$ltb-1);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb,$ltb);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb+1.5,$ltb);
printf ("C, %s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$lgb+1.5,$ltb-1);

# 100.000
$c = 0;
for ($ltc = $ltb; $ltc > $ltb - 1; $ltc -= 0.5) {
for ($lgc = $lgb; $lgc < $lgb + 1.5; $lgc += 0.5) {

printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc,$ltc-0.5);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc,$ltc);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc+0.5,$ltc);
printf ("D, %s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$lgc+0.5,$ltc-0.5);

#  50.000
$d = 0;
for ($ltd = $ltc; $ltd > $ltc - 0.5; $ltd -= 0.25) {
for ($lgd = $lgc; $lgd < $lgc + 0.5; $lgd += 0.25) {

printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd,$ltd-0.25);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd,$ltd);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd+0.25,$ltd);
printf ("E, %s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$lgd+0.25,$ltd-0.25);

#  25.000
$e = 0;
for ($lte = $ltd; $lte > $ltd - 0.25; $lte -= 0.125) {
for ($lge = $lgd; $lge < $lgd + 0.25; $lge += 0.125) {

printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge,$lte-0.125);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge,$lte);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge+0.125,$lte);
printf ("F, %s-%s-%s-%s-%s-%s-%s, %.3f, %.3f\n",$lat,$lon,$i500k[$a],$i250k[$b],$i100k[$c],$i50k[$d],$i25k[$e],$lge+0.125,$lte-0.125);

$e++;
}}

$d++;
}}

$c++;
}}

$b++;
}}

$a++;
}}

}


}

