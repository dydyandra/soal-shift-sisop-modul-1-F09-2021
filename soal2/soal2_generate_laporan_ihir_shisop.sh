#!/bin/bash

#SOAL A
export LC_ALL=C
awk -F"\t" '
BEGIN{}
{percentage=$21/($18-$21)*100}
{if (NR>1 && max<=percentage){
    max=percentage
    ID=$1}
}

END{
print "Transaksi terakhir dengan profit percentage terbesar yaitu", ID, "dengan persentase", max,"%\n"}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv > hasil.txt #untuk soal E


#SOAL B
export LC_ALL=
awk -F"\t" \
-v year="2017" \
-v city="Albuquerque" '
BEGIN{}

{if ($2~year){
 {if ($10==city){names[$7]++}}
}}

END {
print "\nDaftar nama customer di",city,"pada tahun",year,"antara lain:"
{for (name in names){
   print name
}}}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt #untuk soal E



#SOAL C
awk -F"\t" \
-v min=9999 '
BEGIN{}

{if (NR!=1){a[$8]++}}

END{

{for (i in a){
    if (min > a[i]){
	min = a[i]
        min = i}
}}


print "\nTipe segmen customer yang penjualannya paling sedikit adalah", min, "dengan", a[min], "transaksi\n"}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt  #untuk soal E

#SOAL D
export LC_ALL=C
awk -F"\t" \
-v min=999999 '
BEGIN{}

{if (NR!=1){a[$13]+=$21}}

END{

{for (i in a){
    if (min > a[i]){
        min = a[i]
	min = i}
}}
print "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah", min, "dengan total keuntungan", a[min], "\n"}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt  #untuk soal E


