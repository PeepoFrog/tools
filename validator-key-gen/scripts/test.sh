#!/usr/bin/env bash

mnemonic='"over where supreme taste warrior morning perfect memory glove stereo taste trip sheriff fringe weather finger segment under arrange gain warrior olympic urge vacant"'


# Testing address generation with predetermined mnemonic against hard coded results
declare -a Output=("kira103luqf09g5juctmvrmgnw5gmn2mhpelqhcsy84" "kiravaloper103luqf09g5juctmvrmgnw5gmn2mhpelqy7v8le" "kiravalcons103luqf09g5juctmvrmgnw5gmn2mhpelqsdlmnc")
declare -a AdrType=("Account address" "Validator address" "Consensus address")
declare -a Input=("go run . --mnemonic=${mnemonic} --accadr" "go run . --mnemonic=${mnemonic} --valadr" "go run . --mnemonic=${mnemonic} --consadr")

testadr(){
    echo "Testing address formation:"
    for (( i = 0; i < ${#Input[@]} ; i++ ));
    do
        in=$(eval "${Input[$i]}")
        out="${Output[$i]}"
        adr="${AdrType[$i]}"
        
        if [ "$in" = "$out" ]; then
                echo "[PASSED]: $adr"
            else
                echo "[FAILED]: malformed $adr. Want $out, got $in"
                return 1
        fi
    done
    return 0
}


# Checking md5 checksum of created files against hard coded results
declare -a md5=("8a100779d27e5ae2098498674df32f8b" "d14df3851190d360953989e296db3cf3" "7ab595fe3d53672ac918a351bcaa10b5")
declare -a files=("./valkey" "./nodekey" "./keyid")
declare -a cmd=("go run . --mnemonic=${mnemonic} --valkey=${files[0]}" "go run . --mnemonic=${mnemonic} --nodekey=${files[1]}" "go run . --mnemonic=${mnemonic} --keyid=${files[2]}")

testmd5(){
    echo "Checking files md5 checksum:"
    for (( i = 0; i < ${#cmd[@]} ; i++ ));
        do
            eval "${cmd[$i]}"
            in=$(md5sum ${files[$i]} | awk '{print $1}')
            out="${md5[$i]}"

            if [ "$in" = "$out" ]; then
                echo "[PASSED]: File ${files[$i]} $in"
            else
                echo "[FAILED]: File ${files[$i]} wrong MD5. Want $out, got $in"
                return 1
                
        fi
        done
    return 0
}

# Deleating files created by testmd5 func
clean(){
    echo "Deleting files:"
    for f in ${files[@]};
        do 
            rm "$f" ||  (echo "Failed to delete: $f" &&  return 1)
            echo "File $f deleted"
        done
    return 0
}

# Launch sequence of tests

declare -a tests=(testadr testmd5 clean)

test(){
    errs=()
    for test in "${tests[@]}"; do
        $test >&2
        if [[ $? -eq 1 ]]; then
            errs+=("$test" "failed")
        fi
    done
    if [[ ${#errs[@]}>0 ]]; then
        exit 1
    fi
}