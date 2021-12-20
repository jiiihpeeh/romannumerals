import romannumerals
useRomanCache()
for i in countup(1, 3120):
    discard i.arabicToRoman
echo arabicToRoman(5106)
echo arabicToRoman(5107)
doAssert arabicToRoman(99) == "XCIX"
doAssert arabicToRoman(994) == "CMXCIV"

var rmn: string
try:
    rmn = arabicToRoman(-34)
except ValueError:
    rmn = "VII"
doAssert rmn == "VII"
echo romanToArabic("DLXXIV")
echo romanToArabic("XXIV")
doAssert romanToArabic("XXIV") == 24
doAssert romanToArabic("MXXViI", false) == 1027
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
echo num
doAssert num == 9878
var
    a = 5.toRoman
    b = "VI".toRoman
    c = newRoman()
echo c
c = a + b
echo $c
doAssert "XI" == $ c
doAssert a < b
doAssert 10.toRoman < c
var d = c - "II".toRoman
doAssert d == "IX".toRoman
doAssert (d * 3) == "XXVII".toRoman
d += 3
doAssert d == "xii".toRoman
d -= 4
doAssert d.int == 8
doAssert d.roman == "VIII"


useRomanCache(false)
for i in countup(1, 3120):
    discard i.arabicToRoman
useRomanCache(true)
for i in countup(1, 3120):
    discard i.arabicToRoman
echo "Success"
