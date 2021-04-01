#!/bin/bash

namaFolder="$(date +%d)-$(date +%m)-$(date +%Y)"
mkdir $namaFolder

for ((i=1; i<=23; i++));
do
        wget -a Foto.log -O "Koleksi_$i.jpg" https://loremflickr.com/320/240/kitten >> Foto.log
        for ((j=1; j<i; j++));
        do
                if diff Koleksi_$j.jpg Koleksi_$i.jpg &> /dev/null;
                then
                        rm Koleksi_$i.jpg
			break;
                fi
        done
done

for ((i=1; i<=23; i++)); 
do
    if [ ! -f Koleksi_$i.jpg ]; then
        for ((j = 23; i < j; j--)); do
            if [ -f Koleksi_$j.jpg ]; then
                mv Koleksi_$j.jpg Koleksi_$i.jpg
                break
            fi
        done
    fi
done

for i in {1..9}; do
        mv Koleksi_$i.jpg Koleksi_0$i.jpg
done

mv *.jpg $namaFolder
mv Foto.log $namaFolder
