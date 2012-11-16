#!/bin/sh

oneTimeSetUp()
{
	unset -f KV_to_int
	. ../init.d/udev
}

check_kv()
{
	local input="$1" actual= expected="$2"
	actual=$(KV_to_int "$input" 2>/dev/null)
	assertEquals "$?" "0"
	assertEquals "$expected" "$actual"
}

expect_fail_kv()
{
	local input="$1" actual=
	actual=$(KV_to_int "$input" 2>&1)
	assertEquals "$?" "1"
	assertEquals "" "$actual"
}

testTooOld()
{
	expect_fail_kv 2.1.0
	expect_fail_kv 2.1.1
	expect_fail_kv 2.1.2
}

testOneDigit()
{
	check_kv 3	196608
}

testTwoDigit()
{
	check_kv 2.6	132608
	check_kv 3.0	196608
	check_kv 3.1	196864
}

testThreeDigit()
{
	check_kv 2.6.0	132608
	check_kv 2.6.1	132609
	check_kv 2.6.2	132610
	check_kv 2.6.35	132643
	check_kv 3.0.1	196609
}

testFourDigit()
{
	check_kv 2.6.35.1	132643
	check_kv 2.6.35.995	132643
}

testSuffixNormal()
{
	check_kv 2.6.35-2suf	132643
	check_kv 3.0-2suf	196608
}

testSuffixSpecial()
{
	check_kv 2.6.35.1+1suf	132643
	check_kv 2.6.35.1%3suf	132643
	check_kv 2.6.35.1x4suf	132643

	check_kv 2.6.35+1suf	132643
	check_kv 2.6.35%3suf	132643
	check_kv 2.6.35x4suf	132643

	check_kv 3.0+1suf	196608
	check_kv 3.0%3suf	196608
	check_kv 3.0x4suf	196608
}

. ./shunit2

