LOST=""
for c in $*; do
  if [ -z "$(which $c)" ]; then
    LOST="$LOST $c"
  fi
done

if [ -n "$LOST" ]; then
  echo "#E> missing:$LOST"
  exit 1
else
  echo "#> passed"
  exit 0
fi
