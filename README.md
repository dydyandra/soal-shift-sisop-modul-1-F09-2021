# soal-shift-sisop-modul-1-F09-2021 #

### Anggota kelompok:
Anggota | NRP
------------- | -------------
Muthia Qurrota Akyun | 05111940000019
Ifanu Antoni | 05111940000064
Dyandra Paramitha W. | 05111940000119

### Soal
1. [File Soal 1](https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/tree/master/soal1/soal1.sh) | [Penjelasan No. 1](https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021#penjelasan-no-1)
2. [File Soal 2](https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/tree/master/soal2) | [Penjelasan No. 2](https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021#penjelasan-no-2)
3. [File Soal 3](https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/tree/master/soal3) 

## Penjelasan No. 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:
### a. Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log
Sebelumnya, yang dilakukan yaitu menambahkan shebang yaitu `#!/bin/bash` agar script dapat berjalan, dan untuk memudahkan, memasukkan file-file yang akan digunakan/dibuat ke dalam variabel. 
```bash
file=/home/dyandra/praktikum1/syslog.log
errorFile=error_message.csv
userFile=user_statistic.csv
```

```bash
errLog="(ERROR.)(.*)"
log=$(grep -P -o "$errLog" $file)

infLog="(INFO.)(.*)"
log2=$(grep -P -o "$infLog" $file)

```
- `errLog` dan `infLog` merupakan regex yang digunakan untuk mencari data dalam file syslog.log. Keduanya akan mencari *pattern* dalam file dan mengmabil jenis informasi yang dibutuhkan oleh soal, yaitu jenis informasi (maka dari itu dipisah menjadi dua regex), pesan log dan username. Pattern dalam regex yaitu mencari mulai dari tulisan ERROR/INFO, kemudian mengambil semua informasi setelah tulisan. 
- `log` dan `log2` untuk mengetes apakah regex yang digunakan benar atau tidak, dimana menggunakan `grep` dalam file syslog.log. Dikarenakan menggunakan regex Perl, maka agar dapat mengambil pola di file menggunakan `-P`, dan menggunakan `-o` untuk mengambil bagian yang tidak kosong dari file (hanya datanya saja yang diambil). 

### b. Menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
```bash
errorType="(?<=ERROR.)(.*)((?<![)])(?=.[(]))" #regex 
errorCount=$(grep -P -o "$errorType" $file | sort -V | uniq -c | sort -n)
errorList=$(grep -P -o "$errorType" $file | uniq)
# echo $errorCount
# echo $errorList
```
- Untuk menampilkan semua pesan error, menggunakan regex `(?<=ERROR.)(.*)((?<![)])(?=.[(]))`, untuk mencari isi setelah kata `ERROR`, akan tetapi sebelum bagian username
yang ditandai dengan adanya tanda kurung "(". 
- `errorCount` digunakan untuk mengambil data dalam file log sesuai dengan regex. `sort -V` untuk mengelompokkan pesan, `uniq -c` digunakan agar pesan dari yang telah dikelompokkan hanya muncul sekali saja per tipe dan menghitung kemunculan pesan tersebut di dalam file, dan `sort -n` digunakana agar *sum* yang sebelumnya dicari urut. 
- `errorList` sama dengan `errorCount` hanya saja untuk mencari pesan-pesan error tanpa dihitung kemunculannya. 

### c. Menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.
```bash
user="(?<=[(])(.*)(?=[)])" #regex 
userCount=$(grep -P -o "$user" $file | sort -n | uniq -c)
userList=$(grep -P -o "$user" $file | uniq)
# echo $userCount
# echo $userList
```
- `user` adalah regex yang digunakan untuk mencari nama user. Dikarenakan username memiliki karakteristik khusus yaitu dikelilingi oleh "()" dan ada di bagian terakhir baris, maka untuk mencari dapat menggunakan pola regex `(?<=[(])(.*)(?=[)])`, dimana hanya akan mencari isi dari dalam pasangan tanda kurung. 
- `userCount` digunakan untuk mengambil data menggunakan pola regex `user`. Seperti pada 1b, menggunakan `grep -P -o` karena pola yang digunakan merupakan regex Perl, dan menggunakan `sort -n | uniq -c` untuk menghitung kemunculan user dan mengurutkannya. 
- `userList` hanya untuk mencari nama user saja. 

### d. Memasukkan informasi yang telah diambil di b ke dalam file csv, secara urut. 
```bash
printf "ERROR, COUNT\n" > $errorFile
echo "$errorCount" | sort -nr | \
while read count
do
    name=$(echo $count | cut -d " " -f 2-)
    sum=$(echo $count | cut -d " " -f 1 )
    echo "$name, $sum" 
done >> $errorFile
```
- Memanfaatkan informasi dari 1b (di dalam `errorCount`), dan dikarenakan urutan pada 1b dari paling kecil, maka menggunakan `sort -nr` untuk meng-*reverse* urutan. Kemudian, dalam while loop, akan menggunakan info dari `errorCount`. Karena di 1b, informasi terdiri atas <pesan error><jumlah>, untuk memasukkan ke dalam csv harus dalam dua *field* yang berbeda, maka dari itu menggunakan variabel `name` dan `sum` untuk memisahkan data tersebut, juga dengan memanfaatkan `cut -d " " -f 2-` dan `cut -d " " -f 2-` sebagai *delimiter*. 
- Data kemudian akan dimasukkan ke dalam `error_message.csv`. 

### e. Memasukkan 1c ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
Coming soon!

## Penjelasan No. 2
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.
### a. Menentukan ROW ID dan *profit percentage* terbesar
Sebelumnya, yang pertama kali kita lakukan adalah memberikan *shebang* yaitu `#!/bin/bash` agar file dapat dibaca dalam terminal bash
```bash
#!/bin/bash

#SOAL A
LC_ALL=C \
awk -F"\t" '
BEGIN{}
{percentage=$21/($18-$21)*100}
{if (NR !=1 && max<=percentage){
    max=percentage
    ID=$1}
}
END{
print "Transaksi terakhir dengan profit percentage terbesar yaitu", ID, "dengan persentase", max,"%\n"}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv > hasil.txt #untuk soal E
```

Penjelasan:
- `LC_ALL=C` digunakan agar settingan user tidak menghambat jalannya *script*. Hal ini dikarenakan agar format data (koma) terbaca dengan benar. 
- `awk -F"\t"` digunakan untuk mengaktifkan awk, sedangkan `-F"\t" digunakan dikarenakan file berupa tsv dimana *field separator* menggunakan tab/("\t")
- Dalam bagian `BEGIN{}`, proses yang berjalan yaitu mengkalkulasi profit percentage di setiap baris file. `$21` merupakan index kolom profit, sedangkan `$18` merupakan index kolom sales. `Percentage` merupakan rumus yang diberikan di dalam soal. 
  ```bash
  {if (NR !=1 && max<=percentage){
    max=percentage
    ID=$1}
  }
  ```
  Digunakan untuk mendapatkan profit percentage terbesar, dengan cara membandingkan profit percentage setiap baris dengan nilai max. Apabila sudah ditemukan yang paling besar, row ID dari nilai yang paling besar tersebut dimasukkan ke dalam variabel ID. 
- Di bagian `END`, mengeprint ID dan nilai maksimum yang didapatkan. 
- Hasil kemudian disimpan di dalam hasil.txt. `/home/dyandra/praktikum1/Laporan-TokoShiSop.tsv` merupakan input-file yang dibaca oleh AWK sedangkan `hasil.txt` merupakan output-file, dimana jawaban soal akan disimpan. 


### b. Mencari nama customer di tahun 2017, kota Albuquerque
```bash
#SOAL B
LC_ALL= \
awk -F"\t" \
-v year="2017" \
-v city="Albuquerque" '
BEGIN{}
{if (NR!=1){
{if ($2~year){
 {if ($10==city)
 {names[c]=$7; c++}}
}}}}
END {
print "\nDaftar nama customer di",city,"pada tahun",year,"antara lain:"
{for (i=1; i<=c; i++){
   if (names[i]!=names[i+1]){
   print names[i]}
}}}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt #untuk soal E
```
Penjelasan: 
- Mengembalikan script ke setting user menggunakan `LC_ALL`, dan mengaktifkan AWK seperti di soal atas. Kemudian mendeklarasikan beberapa variabel yang akan digunakan di awk yaitu `year` dan `city` yang berisi nilai yang dicari oleh soal. 
- Di dalam rule `BEGIN`, yang dieksekusi adalah untuk mencari nama-nama customer. 
  ```bash
  {if (NR!=1){
  {if ($2~year){
  {if ($10==city)
  {names[c]=$7; c++}}
  }}}}
  ```
  berarti apabila bukan baris pertama (diabaikan dikarenakan baris pertama hanya merupakan keterangan index) dan data di dalam kolom kedua (kolom Order ID) menunjukkan bahwa order dibuat pada tahun 2017, dan kota di dalam data yaitu Albuquerque, nama-nama customer di dalam kolom ke-7 disimpan ke dalam suatu array (`{names[c]=$7; c++}`). Di rule ini akan dicek untuk semua baris sehingga tersimpan beberapa nama di dalam array. 
- Di dalam rule `END`, untuk mengeprint nama-nama customer, menggunakan for loop.  Dikarenakan ada beberapa nama yang mungkin sama, dibuatlah kondisi if, sehingga nama yang diprint tidak ada yang *duplicate*.

### c. Mencari segment customer dan jumlah transaksi yang paling sedikit
```bash
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
```
Penjelasan: 
- Sama seperti soal-soal di atas, yang pertama kali dilakukan adalah mengaktifkan AWK dan field separator, dan juga mendeklarasikan variabel yang akan digunakan. Dalam soal kali ini, yang digunakan adalah variabel min. 
Seperti pada halnya saat akan mengcompare nilai untuk mendapatkan nilai minimum, variabel diset dengan nilai yang besar terlebih dahulu. 
- Di dalam rule `BEGIN`,`{if (NR!=1){a[$8]++}}` digunakan untuk menyimpan segment customer (yang merupakan kolom berindex 8) di dalam suatu array dan jumlahnya di dalam array, dengan syarat mengabaikan barisan pertama. 
- Di dalam rule `END`, yang dilakukan yaitu membandingkan nilai-nilai di dalam array dengan variabel minimum yang telah dibuat. 
  ```bash
  {for (i in a){
    if (min > a[i]){
	  min = a[i]
	  min = i}
  }}
   ```
   Dengan memanfaatkan for loop, array berisi segment customer diiterasi, dan setiap nilai di dalam array dikomparasi dengan nilai minimum. Nilai yang lebih kecil akan dimasukkan kembali ke dalam variabel minimum, 
   kemudian minimum akan diset sesuai index keberapa nilai kecil itu ditemukan, akan tetapi isi index ini tidak seperti index biasanya, melainkan berisi string segment customer, sedangkan isi array dalam index tersebut berupa jumlah kemunculan segment di dalam file. 
   Cara membandingkan nilai minimum didapatkan dari [sini.](https://www.thegeekstuff.com/2010/03/awk-arrays-explained-with-5-practical-examples/)
   
### d. Mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.
```bash
#SOAL D
LC_ALL=C \
awk -F"\t" \
-v min=999999 '
BEGIN{}
{if (NR!=1)
{a[$13]+=$21}}
END{
{for (i in a){
    if (min > a[i]){
        min = a[i]
        min = i}
}}
print "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah", min, "dengan total keuntungan", a[min], "\n"}
' /home/dyandra/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt  #untuk soal E
```
Penjelasan: 
- Mengaktifkan kembali `LC_ALL=C` agar settingan user tidak menghambat jalannya script, dan agar data dalam tsv terbaca dengan benar. 
- Mengaktifkan kembali awk, field separator dan variabel. Seperti pada nomor 2c, variabel min diset dengan nilai yang besar (dengan perkiraan lebih besar daripada nilai terbesar dalam file). 
- Di dalam rule `BEGIN`, `{if (NR!=1){a[$13]+=$21}}` berarti menghitung total profit (index kolom di tsv ke-21) berdasarkan wilayahnya (index kolom di tsv ke-13), sama halnya seperti men-*group-by* suatu data dan mencari *sum* dari setiap bagian.
  Dalam rule ini, data akan diiterasi per baris dan akan dimasukkan ke dalam array sesuai pengelompokkan wilayah. 
  Seperti di atas, baris pertama di data diabaikan dikarenakan hanya merupakan keterangan kolom dan hanya akan membuat jumlah data tidak sesuai.
- Di dalam rule `END`, 
  ```bash
  END{
  {for (i in a){
    if (min > a[i]){
        min = a[i]
        min = i}
  }}
  ```
  sama seperti nomor 2c, nilai-nilai di dalam array (yang berupa total profit per wilayah) akan dibandingkan dengan variabel min dalam sebuah iterasi *for loop*. Nilai yang lebih kecil akan menjadi nilai variabel min yang baru,
  dan array akan diiterasi terus hingga telah dibandingkan semua. Index (dengan nilai berupa jenis wilayah) akan disimpan di dalam variabel min tersebut.
- Yang akan diprint yaitu jenis wilayah (i) dan total profit (yang sebelumnya telah disimpan di dalam array, a[i]). 

### e. Membuat script yang akan menghasilkan hasil.txt
- Dikarenakan saat pembuatan script, setiap nomor menggunakan perintah AWK yang berbeda, di setiap jawaban soal, output AWK akan dimasukkan ke dalam hasil.txt. 
- Perbedaannya yaitu untuk AWK soal 2a, AWK disimpan ke dalam output file menggunakan `> hasil.txt` agar file txt tidak akan terus terappend melainkan akan meng-overwrite apabila sebelumnya sudah ada isi dalam txt. 
- Untuk soal-soal berikutnya menggunakan `>> hasil.txt` untuk mengappend jawaban dari 2a. 

  


