#!/usr/bin/env bash


rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/BHKV/*
rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/GEO/*
rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/LVBB_/*
rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/OZON/*
rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/STOP/*
rm -fr 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/TPOD/*
cp -r -v 1.1.0-STOP-2.0.0-OW/ID-Omkatter/* 1.0.4-matrix-1.3-rc_generate-only/ID-Omkatter_generate_only
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/BHKV/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/BHKV
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/GEO/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/GEO
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/LVBB_/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/LVBB_
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/OZON/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/OZON
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/STOP/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/STOP
cp -r -v 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/TPOD/* 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/TPOD

cd 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden
setscreate/create_all_sets_without_git.sh
cd ../..
rm 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/opdrachten_gereed/*
cp -v 1.1.0-STOP-2.0.0-OW_generate-only/opdracht_voorbeeldbestanden/opdrachten_gereed/* 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/opdrachten_gereed
git add 1.1.0-STOP-2.0.0-OW/opdracht_voorbeeldbestanden/opdrachten_gereed
datePart=$(date +%Y-%m-%d:%H%M)
git commit -a -m "$datePart: generated new test-set"
