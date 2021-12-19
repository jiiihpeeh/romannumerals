import
    strutils,
    tables

type
    Roman*{.borrow: `.`.} = distinct tuple
        arabic: int
        roman: string
const
    arabicRomanArrayN = [1000, 100, 10, 1]
    ones = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]
    tens = ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"]
    hundreds = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"]

var
    arabicRomanTable = {0: ""}.toTable
    romanArabicTable = {"": 0}.toTable
    romanNumeralCache = false

proc addToNumeralTables(n: int, s: string) =
    arabicRomanTable[n] = s
    romanArabicTable[s] = n

proc arabicToRoman*(n: int): string =
    ## Converts an interger (> 0) to a roman string.
    runnableExamples:
        var roman = arabicToRoman(24)
        doAssert roman == "XXIV"
    if n >= 0:
        if romanNumeralCache:
            if n < 1000:
                return arabicRomanTable[n]
            else:
                let
                    goesIn = n div 1000
                    num = n - (goesIn * 1000)
                return repeat('M', goesIn) & arabicRomanTable[num]
        else:
            var
                modArray: array[4, int]
                number = n
                goesIn: int
                index = 0
            for k in arabicRomanArrayN:
                goesIn = number div k
                number = number mod k
                modArray[index] = goesIn
                index += 1
            return repeat('M', modArray[0]) & hundreds[modArray[1]] & tens[
                    modArray[2]] & ones[modArray[3]]
    else:
        raise newException(ValueError, "Value can not be negative")
    


proc useRomanCache*(state: bool = true, clear: bool = true) =
    ## Enable/disable and generates/clears searchable tables for roman / arabic  numerals for values 1..999. Can be used for > 1000 (for their basis).
    runnableExamples:
        import romannumerals
        useRomanCache()
    if state:
        if arabicRomanTable.len < 2:
            romanNumeralCache = false
            var rs: string
            for i in 1..999:
                rs = i.arabicToRoman
                addToNumeralTables(i, rs)
        romanNumeralCache = true
    else:
        romanNumeralCache = false
        if clear:
            arabicRomanTable = {0: ""}.toTable
            romanArabicTable = {"": 0}.toTable



proc startsWithIn(s: string, a: openArray[string]): (int, string) =
    let aLen = a.len
    for i in 1..aLen:
        let index = aLen - i 
        if s.startsWith(a[index]):
            return (index, a[index])
    return (-1,"")


proc romanToArabic*(s: string): int =
    ##Converts a roman string to an int.
    runnableExamples:
        var arabic= romanToArabic("XXXV")
        doAssert arabic == 35

    var 
        arabic = 0
        roman = s.toUpperAscii
    while roman[0] == 'M':
        arabic += 1000
        roman = roman[1..^1]
    
    if romanNumeralCache:
        try:
            return arabic + romanArabicTable[roman]
        except KeyError:
            raise newException(ValueError, "an illformed numeral: $1" % [s])
    else:
        for p in [(100, hundreds), (10, tens), (1, ones)]:
            let 
                (k, v) = p
                (r, ep) = roman.startsWithIn(v)
            if r > 0:
                arabic += r * k
                roman = roman[ep.len..^1]
    if roman.len > 0:
        raise newException(ValueError, "an illformed numeral: $1" % [s])

    return arabic


proc romanToArabic*(s: string, caseSensitive: bool): int =
    ##Converts a roman string to an int. Checks that cases are uniform.
    if caseSensitive:
        if (s.toUpperAscii == s) or (s.toLowerAscii == s):
            return romanToArabic(s)
        else:
            raise newException(ValueError, "an illformed numeral: $1" % [s])
    else:
        return romanToArabic(s)

proc toRoman*(s: string): Roman =
    ##Converts a roman string to the Roman type.
    runnableExamples:
        var romantype = "XXXV".toRoman
        doAssert romantype.arabic == 35
        romantype = "ii".toRoman
        doAssert romantype.arabic == 2
        doAssert romantype.roman == "II"
    return (arabic: romanToArabic(s), roman: s.toUpperAscii).Roman

proc toRoman*(n: int): Roman =
    ##Converts an integer to the Roman type.
    runnableExamples:
        var roman = 33.toRoman
        doAssert roman.roman == "XXXIII"
    return (n, arabicToRoman(n)).Roman

proc `>`*(a, b: Roman): bool=
    runnableExamples:
        var firstroman = "XXXV".toRoman
        var secondroman = 120.toRoman
        doAssert secondroman > firstroman

    return a.arabic > b.arabic

proc `<`*(a, b: Roman): bool =
    return a.arabic < b.arabic

proc `<=`*(a, b: Roman): bool =
    return a.arabic <= b.arabic

proc `>=`*(a, b: Roman): bool =
    return a.arabic >= b.arabic

proc `==`*(a, b: Roman): bool =
    return a.arabic == b.arabic

proc `+=`*(a: var Roman, b: Roman) =
    let r = a.arabic + b.arabic
    a = (r, arabicToRoman(r)).Roman

proc `+=`*(a: var Roman, b: int) =
    runnableExamples:
        var rnf = 20.toRoman
        rnf += 2
        doAssert $rnf == "XXII"
        doAssert rnf == 22.toRoman
    let r = a.arabic + b
    a = (r, arabicToRoman(r)).Roman

proc `-=`*(a: var Roman, b: Roman) =
    let r = a.arabic - b.arabic
    a = (r, arabicToRoman(r)).Roman

proc `-=`*(a: var Roman, b: int) =
    let r = a.arabic - b
    a = (r, arabicToRoman(r)).Roman

proc `*=`*(a: var Roman, b: Roman) =
    let r = a.arabic * b.arabic
    a = (r, arabicToRoman(r)).Roman

proc `*=`*(a: var Roman, b: int) =
    let r = a.arabic * b
    a = (r, arabicToRoman(r)).Roman

proc `!=`*(a, b: Roman): bool =
    return a.arabic != b.arabic

proc `-`*(a, b: Roman): Roman =
    let r = a.arabic - b.arabic
    return (r, arabicToRoman(r)).Roman

proc `-`*(a: Roman, b: int): Roman =
    let r = a.arabic - b
    return (r, arabicToRoman(r)).Roman

proc `-`*(a: int, b: Roman): Roman =
    let r = a - b.arabic
    return (r, arabicToRoman(r)).Roman

proc `+`*(a, b: Roman): Roman =
    let r = a.arabic + b.arabic
    return (r, arabicToRoman(r)).Roman

proc `+`*(a: Roman, b: int): Roman =
    let r = a.arabic + b
    return (r, arabicToRoman(r)).Roman

proc `+`*(a: int, b: Roman): Roman =
    let r = a + b.arabic
    return (r, arabicToRoman(r)).Roman

proc `*`*(a, b: Roman): Roman =
    let r = a.arabic * b.arabic
    return (r, arabicToRoman(r)).Roman

proc `*`*(a: int, b: Roman): Roman =
    let r = a * b.arabic
    return (r, arabicToRoman(r)).Roman

proc `*`*(a: Roman, b: int): Roman =
    let r = a.arabic * b
    return (r, arabicToRoman(r)).Roman

proc `div`*(a, b: Roman): Roman =
    let r = a.arabic div b.arabic
    return (r, arabicToRoman(r)).Roman

proc `div`*(a: int, b: Roman): Roman =
    let r = a div b.arabic
    return (r, arabicToRoman(r)).Roman

proc `div`*(a: Roman, b: int): Roman =
    let r = a.arabic div b
    return (r, arabicToRoman(r)).Roman

proc `mod`*(a, b: Roman): Roman =
    let r = a.arabic mod b.arabic
    return (r, arabicToRoman(r)).Roman

proc `mod`*(a: int, b: Roman): Roman =
    let r = a mod b.arabic
    return (r, arabicToRoman(r)).Roman

proc `mod`*(a: Roman, b: int): Roman =
    let r = a.arabic mod b
    return (r, arabicToRoman(r)).Roman

proc `$`*(r: Roman): string =
    runnableExamples:
        var rt = 20.toRoman
        doAssert $rt == "XX"
    return r.roman

proc newRoman*: Roman =
    ##Generates a new Roman [arabic:1, roman: "I"].
    runnableExamples:
        var newr = newRoman()
        newr *= 10 
        newr -= 1 
        doAssert "IX" == $newr
    return (1, "I").Roman


when isMainModule:
    useRomanCache()
    echo arabicRomanTable
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
    doAssert d.arabic == 8
    doAssert d.roman == "VIII"


    echo arabicRomanTable
    useRomanCache(false)
    echo arabicRomanTable
    useRomanCache(true)
    echo arabicRomanTable
    echo "Success"