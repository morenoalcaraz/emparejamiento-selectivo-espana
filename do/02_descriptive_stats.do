// -------------------------------------------------------------------------- //
// Archivo do: 02_descriptive_stats.do
// Descripción: Saca los estadísticos descriptivos.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
capture log close
set more off
cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV"

use "data/panel_ass.dta", clear

**# Estadísticos descriptivas por tipo de pareja -------------------------------

* Brecha salarial por pareja

tabstat gap_hwage, by(assortative) statistics(mean median sd count)

* Hijos por tipo de pareja

tabstat has_ch, by(assortative) statistics(mean median sd count)

* Parejas nacidas en distintos países por tipo de pareja

tabstat diff_born, by(assortative) statistics(mean median sd count)

* Diferencia de experiencia por tipo de pareja

tabstat exper_diff, by(assortative) statistics(mean median sd count)

tabstat abs_exper_diff, by(assortative) statistics(mean median sd count)

* Diferencia de ocupación por tipo de pareja

tabstat occup_diff, by(assortative) statistics(mean median sd count)

* Diferencia de sector de trabajo por tipo de pareja

tabstat sector_diff, by(assortative) statistics(mean median sd count)

* Distinto tipo de trabajador por tipo de pareja

tabstat fixed_worker_diff, by(assortative) statistics(mean median sd count)

* Ingreso del hogar por tipo de pareja

tabstat hh_income, by(assortative) statistics(mean median sd count)
