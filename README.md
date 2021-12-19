Convert between Arabic and Roman numbers. Supports also substraction, addition, division and multiplication
```
nimble install https://gitlab.com/jiiihpeeh/romannumerals/
```
Documentation
https://gl.githack.com/jiiihpeeh/romannumerals/raw/main/htmldocs/romannumerals.html

Examples

```
import romannumerals
for i in 1..3214:
    discard i.arabicToRoman
doAssert arabicToRoman(99) == "XCIX"
doAssert arabicToRoman(994) == "CMXCIV"

var num: int
try:
    num = romanToArabic("ViI", true)
except ValueError:
    num = 9878
doAssert num == 9878
try:
    num = romanToArabic("IC", true)
except ValueError:
    num = 9878
doAssert num == 9878

echo c
c = a + b
echo $c
doAssert "XI" == $ c
doAssert a < b

echo "Success"
```



