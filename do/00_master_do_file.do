// -------------------------------------------------------------------------- //
// Archivo do: 00_master_do_file.do
// Descripción: Corre todos los códigos del trabajo.
//
// Autor: Carmen Moreno
// Fecha: May 2024
// -------------------------------------------------------------------------- //

clear all
set more off
capture log close

cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV/do"

do "01_data_prep_over_time.do"
do "02_descriptive_stats.do"
do "03_random_couples_data_prep.do"
do "04_assortative_mating_over_time.do"
do "05_stand_cont_tables.do"
do "06_brecha_salarial.do"
