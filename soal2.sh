#!/bin/bash

result1=`cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, '
$7 ~ /2012/ {
country[$1] += $10
}
END {
for (i in country) {
print country[i]","i
}
}
' | sort -nr | awk -F, 'NR == 1 {print $2}'`

echo "$result1"
echo "=================="

readarray -t result2 < <(cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, -v pattern="$result1" '
$1 ~ pattern {
productline[$4] += $10
}
END {
for (i in productline) {
print productline[i]","i
}
}
' | sort -nr | awk -F, 'NR <= 3 {print $2}')

# for i in {0..2}; do
# echo "${result2[$i]}"
# done
# echo "================"

for i in {0..2}; do
echo "${result2[$i]}"
done

echo "================"

for i in {0..2}; do
cat /home/durianpeople/Downloads/WA_Sales_Products_2012-14.csv | awk -F, -v pattern="${result2[$i]}" '
$4 ~ pattern {
product[$6] += $10
}
END {
for (i in product) {
print product[i]","i
}
}
'
done | sort -nr | awk -F, 'NR <=3 {print $2}'