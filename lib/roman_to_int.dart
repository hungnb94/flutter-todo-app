class RomanToInt {
  static const String symbols = 'IVXLCDM';

  int rank(String code) {
    for (int i = 0; i < symbols.length; i++) {
      if (symbols[i] == code) return i;
    }
    return -1;
  }

  int getValue(String code) {
    switch (code) {
      case 'I':
        return 1;
      case 'V':
        return 5;
      case 'X':
        return 10;
      case 'L':
        return 50;
      case 'C':
        return 100;
      case 'D':
        return 500;
      case 'M':
        return 1000;
      default:
        throw FormatException(code + ' is not a roman character');
    }
  }

  int romanToInt(String s) {
    int res = 0;
    int prevValue = getValue(s[0]);
    int prevRank = rank(s[0]);
    for (int i = 1; i < s.length; i++) {
      int r = rank(s[i]);
      int v = getValue(s[i]);
      if (r > prevRank) {
        prevValue = -prevValue + v;
      } else {
        res += prevValue;
        prevValue = v;
      }
      prevRank = r;
    }
    return res + prevValue;
  }
}

void main() {
  var solution = RomanToInt();
  assert(solution.romanToInt('III') == 3);
  assert(solution.romanToInt('LVIII') == 58);
  assert(solution.romanToInt('MCMXCIV') == 1994);
}
