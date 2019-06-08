#!/bin/sh

# このスクリプトは、２つの数値を引数とし、最大公約数を出力する

# 引数の数が２以外の場合、エラー　"Plz input 2 arguments"

if [ $# -ne 2 ];
then
       echo "Plz input 2 arguments" 1>&2
       exit 1
fi

# 数値チェック：exprによる引数を含む数値計算が成立するかにより判定

expr $1 + $2 > /dev/null  2>&1
if [ $? -eq 2 ]; 
then
     echo "input natural number" 1>&2 
     exit 1
fi     

# 引数を個別にチェック
#　expr演算の戻り値(RET_1,RET_2)　0：正常
#                                 1:ゼロ値で対象外とする　　　　　　　　　　　　　　
#　　　　　　             　　　　2以上:演算エラー
#                                   (3:範囲を超える）　　

expr $1 \* 1 > /dev/null 2>&1
RET_1=$?
expr $2 \* 1 > /dev/null 2>&1
RET_2=$?

if [ $RET_1 -eq 1 ] || [ $RET_2 -eq 1 ]; 
then
     echo "zero is invalid"  1>&2
     exit 1
fi

# exprコマンドの演算対象の上限値が、

# 現在　16進数0x7FFF FFFF FFFF FFFF(＝10進9223372036854775807)

# となっていることから、 

# 今回の最大公約数の演算対象の２値の上限値をexprと同じ値とし、下限値は1とする

max_val=9223372036854775807  # 16進数 0x7FFF FFFF FFFF FFFF に該当　

min_val=1

if [ $RET_1 -eq 3 ] || [ $RET_2 -eq 3 ]; 
then
     echo "input number not exceeding $max_val" 1>&2
     exit 1
fi

if [ $RET_1 -ne 0 ] || [ $RET_2 -ne 0 ];
then 
     echo "calculation  can't be operated "  1>&2	
     exit 1　
fi     

if [ $1 -lt $min_val ] || [ $2 -lt $min_val ];
then
     echo "input natural number, not minus"   1>&2
     exit 1
fi

a=$1
b=$2

# 本体

while [ $b -ne 0 ]; do 
  remainder=$(( $a % $b ))	
  a=$b
  b=$remainder
done
 echo $a 1>&1
 

