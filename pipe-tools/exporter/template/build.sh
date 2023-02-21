#!/bin/bash

for version in v3 v4 v5 v6 v7; do
  output_file="standalone_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" standalone.tpl > ../standalone/${output_file}
done
