#!/bin/bash

# git diff --name-only <commit compare1> <compare2>
# checkFiles=$(git diff --name-only HEAD~ HEAD)
# 

# cpp lint check
##git checkout -f ${sha1};
commit_msg=$(git log --oneline -1);
# commit_msg="5cd6d9f Merge c91688f9c04c2ada26f31eebf71fd812f2634beb into 43aedf77ce81a0121f767e02107f4b13779a9dfe";
index_merge=$(expr index "$commit_msg" "Merge");
index_into=$(expr index "$commit_msg" "into");
commit_src=${commit_msg:$((index_merge+5)):$((index_into-index_merge-7))};
commit_target=${commit_msg:$((index_into+4))};

echo "commit_msg: $commit_msg";
echo "index: $index";
echo "commit_src: $commit_src";
echo "commit_target: $commit_target";

checkFiles=$(git diff --name-only $commit_src $commit_target);
echo $checkFiles;

# # cpplint check file type
CPPLINT_EXTENS=cc,cpp,h

# # cpplint filter;  -xxx remove, +xxx add
CPPLINT_FILTER=-whitespace/line_length,-build/include_what_you_use,-readability/todo,-build/include,-build/header_guard
cpplint --extensions=$CPPLINT_EXTENS --filter=$CPPLINT_FILTER $checkFiles 2>&1 | tee cpplint-result.xml

# clang-format check
# clang-format -i $checkFiles
clang-format $checkFiles