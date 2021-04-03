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
- Untuk pencarian dan uji coba regex menggunakan website [Link](https://regexr.com/)

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
userList=$(grep -P -o "$user" $file | sort -u)
# echo $userCount
# echo $userList
```
- `user` adalah regex yang digunakan untuk mencari nama user. Dikarenakan username memiliki karakteristik khusus yaitu dikelilingi oleh "()" dan ada di bagian terakhir baris, maka untuk mencari dapat menggunakan pola regex `(?<=[(])(.*)(?=[)])`, dimana hanya akan mencari isi dari dalam pasangan tanda kurung. 
- `userCount` digunakan untuk mengambil data menggunakan pola regex `user`. Seperti pada 1b, menggunakan `grep -P -o` karena pola yang digunakan merupakan regex Perl, dan menggunakan `sort -n | uniq -c` untuk menghitung kemunculan user dan mengurutkannya. 
- `userList` hanya untuk mencari nama user saja, dengan menggunakan `sort -u` untuk hanya mengambil data-data yang *unique/distinct* saja. 

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
```bash
printf "USERNAME, INFO, ERROR\n" > $userFile
echo "$userList" | \
while read username
do 
    info_user=$(echo $username | grep -c -P "$infLog.*((?<=[(])($username)(?=[)]))" $file)
    error_user=$(echo $username | grep -c -P "$errLog.*((?<=[(])($username)(?=[)]))" $file)
    echo "$username,$info_user, $error_user" 
done >> $userFile
```
- Dari data yang telah di-grep pada 1c menggunakan userList, userList kemudian diiterasi kembali untuk menemukan jenis log tersebut. 
- Untuk mencari jumlah log berjenis INFO pada setiap user, data dari setiap iterasi userList (yang diwakilkan dengan $username) diambil dan dihitung menggunakan `grep -c -P "$infLog.*((?<=[(])($username)(?=[)]))" $file`. Dengan menggunakan option grep `-c`, setiap line hanya dihitung, dan dengan `-P` hanya membaca line dengan pattern regex `$infLog.*((?<=[(])($username)(?=[)]))` yang berarti membaca yang depannya INFO (seperti pada regex 1a), dan nama user. 
- Untuk mencari jumlah log berjenis ERROR pada setiap user juga sama, yaitu dengan mengiterasi data userList dan mencari menggunakan regex, yang kemudian diambil menggunakan `grep -c -P`. 
- Hasil kemudian akan dicetak dan dimasukkan ke dalam variabel $userFile, yang berisi user_statistic.csv. 

### Output
#### Untuk error_message.cv berisi data-data error dan jumlahnya (seperti 1d)
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no1d.png"> | <img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/error_message.png" width="350">

### Untuk user_statistic.csv berisi data tiap user dan jumlah jenis info log dan errornya. 
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no1e.png"> | <img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/user_statistic.png" height="375">

### Kendala yang dialami
- Awal-awal masih bingung dengan penggunaan regex dan jenis-jenis grep dan sort sehingga untuk pengerjaan banyak mencoba-coba jenis-jenis tersebut.
  apalagi di sesi lab atau di mudul tidak ada materi tantang regex   
- Untuk no 1e, grep juga membaca substring dari data sehingga regex harus dimodifikasi kembali agar tidak terjadi pengambilan data yang salah. 


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

### Output
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no2bash.png" width="500"> | <img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/hasiltxt.png" height="350">

### Kendala yang Dialami
- Hasil yang tidak tepat dengan dugaan setelah melihat data di csv, ternyata diakibatkan oleh sistem. Maka dari itu diselesaikan dengan penggunaan LC_ALL=C yang bermaksud untuk meng-override setting sistem. 


## Penjelasan No. 3
Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian. Idenya adalah :
### a. Membuat script untuk mengunduh 23 gambar serta menyimpan log-nya ke file "Foto.log". Kemudian menyimpan gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan tanpa ada nomor yang hilang.
Pertama membuat file dengan nama soal3a.sh kemudian menambahkan shebang yaitu `#!/bin/bash` agar script dapat berjalan. Kemudian untuk mengunduh gambar kucing menggunakan perintah `wget -a Foto.log -O "Koleksi_$i.jpg" https://loremflickr.com/320/240/kitten >> a.log`. Perintah tersebut juga digunakan untuk menyimpan log ke file Foto.log.
Kemudian perintah `diff Koleksi_$j.jpg Koleksi_$i.jpg &> /dev/null;` digunakan untuk mengecek apakah gambar yang diunduh ada yang sama atau tidak, jika ada maka salah satu gambar yang sama akan dihapus. 

### Output
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no3a.png">

### b. Menjalankan script sehari sekali pada jam 8 malam, dari tanggal 1 tujuh hari sekali serta dari tanggal 2 empat hari sekali. Gambar yang telah diunduh beserta log-nya, dipindahkan ke folder dengan nama tanggal unduhnya dengan format "DD-MM-YYYY" .
Untuk membuat direktori baru menggunakan perintah mkdir dan mv untuk memindahkan file yang telah di unduh ke direktori baru 
```
namaFolder="$(date +%d)-$(date +%m)-$(date +%Y)"
mkdir $namaFolder
mv *.jpg $namaFolder
mv Foto.log $namaFolder
```
Untuk menjalankan script secara otomatis maka digunakan crontab sebagai berikut
```
0 20 */7 * * /bin/bash soal3b.sh
0 20 2-31/4 * * /bin/bash soal3b.sh
```

### Output
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no3b.png">

### c. Mengunduh gambar kucing dan kelinci secara bergantian dengan nama folder diberi awalan "Kucing_" atau "Kelinci_".
Untuk mengunduh gambar kelinci dan kucing secara bergantian perlu untuk menghitung jumlah direktori dari kucing dan kelinci yang telah ada
```
countKucing=$(find Kucing_* -type f | wc -l)
countKelinci=$(find Kelinci_* -type f | wc -l)
```
Jika jumlah direktori kucing < kelinci atau direktori kucing = kelinci, maka yang diunduh adalah gambar kucing. Selain syarat tersebut, maka yang diunduh adalah gambar kelinci. 

### Output
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no3c.png">

### d. Membuat script yang akan memindahkan seluruh folder ke zip yang diberi nama “Koleksi.zip” dan mengunci zip tersebut dengan password berupa tanggal saat ini dengan format "MMDDYYYY".
Perintah `zip -P `date +"%m%d%Y"` -r Koleksi.zip $namaFolder` digunakan untuk membuat file zip dengan nama file Koleksi.zip. Lalu file zip tersebut diberi password sesuai tanggal saat itu dengan format "MMDDYYYY".

### Output
<img src="https://github.com/dydyandra/soal-shift-sisop-modul-1-F09-2021/blob/master/screenshot/no3d.png">

### e. Membuat koleksi ter-zip saat kuliah (jam 07.00-18.00 hari senin-jumat), kemudian koleksi ter-unzip dan tidak ada file zip sama sekali saat jam diluar kuliah. 
Membuat crontab seperti berikut. 
- Crontab `0 7 * * 1-5 /bin/bash soal3d.sh` digunakan untuk membuat file zip pada jam 07.00 pada hari senin-jumat
- Crontab 
```
0 18 * * 1-5 unzip -P `date +"\%m\%d\%Y"` Koleksi.zip
0 18 * * 1-5 rm Koleksi.zip
```
digunakan untuk me-unzip file Koleksi.zip dan menghapus file zip-nya pada jam 18.00 pada hari senin-jumat.

### Kendala yang Dialami
- Pada no 3e, password yang digunakan untuk me-unzip file Koleksi.zip penggunaannya masih salah pada crontab. Agar password dapat terbaca perlu digunakan backslash seperti -P `date +"\%m\%d\%Y"`

