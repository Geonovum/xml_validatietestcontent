#!/usr/bin/env bash

cp -r -v -u 1.0.4-matrix-1.3-rc/ID-Omkatter/* 1.0.4-matrix-1.3-rc_generate-only/ID-Omkatter_generate_only
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/BHKV/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/BHKV
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/GEO/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/GEO
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/LVBB_/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/LVBB_
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/OZON/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/OZON
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/STOP/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/STOP
cp -r -v -u 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/TPOD/* 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/TPOD

cd 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden
setscreate/create_all_sets_without_git.sh
cd ../..
rm 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/opdrachten_gereed/*
cp -v 1.0.4-matrix-1.3-rc_generate-only/opdracht_voorbeeldbestanden/opdrachten_gereed/* 1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/opdrachten_gereed
datePart=$(date +%Y-%m-%d:%H%M)
git commit -a -m "$datePart: generated new test-set"
