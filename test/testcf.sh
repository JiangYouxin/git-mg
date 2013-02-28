# /bin/sh

for TESTFILE in *.test; do
    RESULTFILE="$TESTFILE.result"
    TEMPFILE="$TESTFILE.temp"
    cp -f $TESTFILE $TEMPFILE
    echo "test case $TESTFILE..."
    git cf $TEMPFILE
    diff -q $RESULTFILE $TEMPFILE
    if [ $? -eq 0 ]; then
        rm $TEMPFILE
    fi  
done
