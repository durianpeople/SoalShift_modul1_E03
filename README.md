# Laporan

## SOAL 1

### Bash script

Meng-unzip file .zip ke dalam sebuah folder:

```bash
unzip /home/durianpeople/Downloads/nature.zip -d /home/durianpeople/Downloads
```

Membuat folder **nature2** untuk menampung hasil dekripsi file-file:

```bash
mkdir /home/durianpeople/Downloads/nature2
```

Konten dari salah satu file dalam folder **nature** adalah sebagai berikut:

![1550802747902](./1550802747902.png)

Karena terlihat seperti hasil dari enkripsi base64, maka didekripsi sehingga menghasilkan output berikut:

![1550802884790](./1550802884790.png)

Bentuk output hexdump, sehingga harus di-reverse untuk mendapatkan binary file

Loop untuk setiap file dalam folder **nature**, *decrypt* menggunakan Base64 kemudian melakukan reverse hexdump menggunakan xxd

```bash
for i in `ls /home/durianpeople/Downloads/nature/`; do 
	base64 -d /home/durianpeople/Downloads/nature/$i | 
	xxd -r > /home/durianpeople/Downloads/nature2/$i; 
done
```

### crontab

Entri crontab untuk soal ini

```
14 14 14 2 5 /bin/bash /<path>/<ke>/soal1.sh
```

## SOAL 2

### A

Membaca konten dari .csv:

```bash
cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv |
```

Lalu output perintah tersebut di-pipe ke dalam **awk** dengan ketentuan sebagai berikut

- Menggunakan field separator koma (,) (karena comma-separated values)

- Mencocokkan kolom ke-7 dengan string **2012**

- Menghitung jumlah dari kolom ke-10 berdasarkan kolom ke-1, sehingga menggunakan array counter

- Saat berakhir, menampilkan jumlah kolom ke-10 berdasarkan nilai kolom ke-1

  ```bash
  awk -F, ' \
  $7 ~ /2012/ { \
  country[$1] += $10 \
  } \
  END { \
  for (i in country) { \
  print country[i]","i \
  } \
  } \
  ' |
  ```

Kemudian hasil dari perintah tersebut di-pipe untuk sorting secara numerik dan reverse, lalu menampilkan entri pertama kolom ke-2 dari output perintah tersebut

```bash
| sort -nr | awk -F, 'NR == 1 {print $2}'
```

Hasil dari perintah tersebut dimasukkan ke dalam sebuah variabel, sehingga menjadi:

```bash
result1=`cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, ' \
$7 ~ /2012/ { \
country[$1] += $10 \
} \
END { \
for (i in country) { \
print country[i]","i \
} \
} \
' | sort -nr | awk -F, 'NR == 1 {print $2}'`
```

Kemudian cetak isi variabel

```bash
echo "$result1"
```

### B

Sama seperti poin **A** dengan perubahan di kriteria kolom, penjumlahan, dan menggunakan hasil dari poin **A** (**$result1**).

Memasukkan ke dalam array **result2**

```bash
readarray -t result2 < <(cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, -v pattern="$result1" ' \
$1 ~ pattern { \
productline[$4] += $10 \
} \
END { \
for (i in productline) { \
print productline[i]","i \
} \
} \
' | sort -nr | awk -F, 'NR <= 3 {print $2}')
```

Loop untuk 3 hasil dari **$result2**

```bash
for i in {0..2}; do
echo "${result2[$i]}"
done
```

### C

Loop untuk setiap hasil dari **$result2** untuk kolom ke-4, menjumlahkan kolom ke-10 berdasarkan kolom ke-6, sortir, lalu ambil 3 teratas

```bash
for i in {0..2}; do
cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, -v pattern="${result2[$i]}" ' \
$4 ~ pattern { \
product[$6] += $10 \
} \
END { \
for (i in product) { \
print product[i]","i \
} \
} \
'
done
```

## SOAL 3

## SOAL 4

### Enkripsi

Mengambil jam sekarang, tanpa nol di depan angka

```bash
hour=`date +"%-H"`
```

Membuat array dengan range (a..z) dan (A..Z)

```bash
sourcelower=({a..z})
sourceupper=({A..Z})
```

Menghitung huruf harus digeser berapa banyak, berdasarkan **$hour**

```bash
offset=$(($hour % 26))
```

Memastikan, jika **$offset** kurang dari nol maka dijadikan nol

```bash
if [ "$offset" -lt 0 ]; then
    offset=0
fi
```

Menambahkan array **$sourcelower** dan **$sourceupper** dengan **$offset** untuk enkripsi

```bash
destlower=(${sourcelower[*]:$offset} ${sourcelower[*]:0:$offset})
destupper=(${sourceupper[*]:$offset} ${sourceupper[*]:0:$offset})
```

Menggabungkan array-array tersebut

```bash
source=(${sourcelower[*]} ${sourceupper[*]})
dest=(${destlower[*]} ${destupper[*]})
```

Menggunakan perintah **tr** untuk mentranslasi file sumber menggunakan daftar perubahan dari array **$source** dan **$dest**

```bash
cat /var/log/syslog | 
tr "${source[*]}" "${dest[*]}" > "/home/durianpeople/Documents/Notes/SISOP/`date +"%H:%M %d-%m-%Y"`.encrypted"
```

### Dekripsi

Melalui proses yang sama, namun dibalik dari **$dest** ke **$source**, serta menerima path menuju file yang terenkripsi untuk didekripsi

```bash
echo "Ketik path ke file"
read path
hour=`echo $path | awk -F/ '{print $NF}' | awk -F: '{print $1}'`

sourcelower=({a..z})
sourceupper=({A..Z})
offset=$(($hour % 26))
if [ "$offset" -lt 0 ]; then
    offset=0
fi
destlower=(${sourcelower[*]:$offset} ${sourcelower[*]:0:$offset})
destupper=(${sourceupper[*]:$offset} ${sourceupper[*]:0:$offset})

source=(${sourcelower[*]} ${sourceupper[*]})
dest=(${destlower[*]} ${destupper[*]})

echo "${dest[*]}"
echo "${source[*]}"

filename=`echo $path | awk -F/ '{print $NF}' | awk -F "'" '{print $1}' | awk -F. '{print $1}'`


tr "${dest[*]}" "${source[*]}" < "$path" > "/home/durianpeople/Documents/Notes/SISOP/$filename.decrypted"
```



## SOAL 5

