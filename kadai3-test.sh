#!/bin/sh

# このスクリプトは、２つの自然数から最大公約数を出力するシェルスクリプトkadai3.shの動作確認を行う。
# kadai3.shで機能追加を行った際に、これまでの引数チェックや演算にデグレードがないか確認をするのに
#　役立つ。

# 引数の数が２ではない場合エラーとする　"Plz input 2 arguments" (exprステータス利用）
# 引数が文字や記号など自然数でない場合はエラーとする  "input natural number　（exprステータス利用)
# 引数のいずれかがゼロである場合はエラーとする "zero is invalid"（exprステータス利用)
# 引数のいずれかがexpr演算の上限値を超える場合はエラーとする　"input number not exceeding $max_val" (exprステータス利用)
# 引数のいずれかが正常ではない場合（上記のケースを除く）エラーとする　"input number not exceeding $max_val"'exprステータス利用）
# 引数のいずれかがマイナスである場合はエラーとする　"input natural number, not minus" 　　　　          

tmp=/tmp/$$
max_val=9223372036854775807  # 16進数　0x7FFFF FFFF FFFF FFFFに該当

ERROR_EXIT(){
	echo "$1" 1>&2
	rm -r ${tmp}*
	exit 1
}

# TEST1: obtain 2 arguments    
echo "Plz input 2 arguments" > ${tmp}-ans

./kadai3.sh 2> $tmp-result &&  ERROR_EXIT "error in test1-1(no arguments) no error message"  #　引数なしで実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test1-1(no arguments) wrong error message"  # error message比較

./kadai3.sh 1 2> ${tmp}-result && ERROR_EXIT "error in test1-2(1 argument) no error message"  #　引数１個で実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test1-2(1 argument) wrong error message"  # error message比較

./kadai3.sh 1 2 3 2> ${tmp}-result && ERROR_EXIT "error in test 1-3(3 arguments) no error message" # 引数３個で実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test1-3(3 arguments) wrong error message"  # error message比較

echo "pass test1(check 2 arguments)"



# TEST2: obtain natural number except character and decimal number    
echo "input natural number" > ${tmp}-ans

./kadai3.sh a b 2> ${tmp}-result && ERROR_EXIT "error in test2-1(character) no error message"  #　引数:文字で実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test2-1(character) wrong error message"  # error message比較

./kadai3.sh 1.1 2.2 2> ${tmp}-result && ERROR_EXIT "error in test2-2(decimal) no error message"  #　引数:小数付き数値で実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test2-2(decimal) wrong error message"  # error message比較

echo "pass test2(check not includig character and decimal number)"



# TEST3: obtain natural number except 0      
echo "zero is invalid" > ${tmp}-ans

./kadai3.sh  0 1 2> ${tmp}-result && ERROR_EXIT "error in test3-1(zero) no error message"  #　引数:zero数値で実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test3-2(zero) wrong error message"  # error message比較

echo "pass test3(check not includig zero number)"



# TEST4: obtain number not exceeding $max_val
echo "input number not exceeding $max_val" > ${tmp}-ans

./kadai3.sh  99223372036854775807223372036854775808 3 2> ${tmp}-result && ERROR_EXIT "error in test4-1(exceeding max limit)" # 引数上限超えで実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test4-2(exceeding max limit) wrong error message"  # error message比較

echo "pass test4(check not exceeding max limit)"



# TEST5: obtain natural number, not minus number 　　　　          
echo "input natural number, not minus" > ${tmp}-ans

./kadai3.sh -1 -2  2> ${tmp}-result && ERROR_EXIT "error in test5-1(minus)" # 引数上限超えで実行
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test5-2(minus) wrong error message"  # error message比較

echo "pass test5(check not minus number)"

#  ＜公約数の演算確認＞
#　TEST5までの確認で、引数として適さない条件を排除することを確認できたため、
#　ここからは、最大公約数のいくつかのパターンを求める
#　TEST6：・テストパターン(799、187で、最大公約数は17)を確認
#　 　　　・引数の順序を入れ替えて確認
#  TEST7:  上限値=9223372036854775807 と10の組み合わせで最大公約数1を確認   


# TEST6: obtain correct caluculation reseuts(standard) 　　　　          
echo "17" > ${tmp}-ans

./kadai3.sh 799 187 1> ${tmp}-result || ERROR_EXIT "error in test6-1(standard)" # 高校数学教科書に掲載例
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test6-2(standard) wrong result"  # error message比較

./kadai3.sh 187 799 1> ${tmp}-result || ERROR_EXIT "error in test6-3(standard)" # 6-1の引数１、２を入れ替えて確認
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test6-4(standard) wrong result"  # error message比較

echo "pass test6(standard calculation 799,187の最大公約数は17)"



# TEST7: obtain correct caluculation reseuts(max limit)　　　　          

echo "1" > ${tmp}-ans

./kadai3.sh 9223372036854775807 10 1> ${tmp}-result || ERROR_EXIT "error in test7-1(max limit)" # 上限値と10で最大公約数が１であることを確認
diff $tmp-ans $tmp-result || ERROR_EXIT "error in test7-2(max limit) wrong result"  # error message比較

echo "pass test7( calculation for maximum)"
