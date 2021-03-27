#!/bin/bash

for namaFolder in K*_*; 
do
	zip -P `date +"%m%d%Y"` -r Koleksi.zip $namaFolder
	rm -r $namaFolder
done
