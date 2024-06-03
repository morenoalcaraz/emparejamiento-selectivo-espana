// -------------------------------------------------------------------------- //
// Archivo do: 06_brecha_salarial.do
// Descripción: Hace las regresiones.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
capture log close
set more off
cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV"

**# BRECHA SALARIAL POR PAREJA A LO LARGO DEL TIEMPO ---------------------------

use "data/panel_ass.dta", clear

**# Identificando variables que cambian con el tiempo --------------------------

bysort year: egen aux_w_higer_educ = mean(w_higher_educ)

bysort year: egen aux_m_higer_educ = mean(m_higher_educ)

bysort year: egen aux_has_ch = mean(has_ch)

bysort year: egen aux_diff_born = mean(diff_born)

su exper_diff, d

bysort year: egen aux_exper_diff = mean(exper_diff)

twoway (line aux_exper_diff year, lcolor(blue)), graphregion(color(white)) ///
	   xlabel(2008(2)2023) xtitle("Año") ylabel(-3(3)8)                    ///
	   ytitle("Experiencia hombre - experiencia mujer") yline(4.10,        ///
	   lcolor(pink)) legend(off)

graph export "graphs/aux_exper_diff.pdf", replace

bysort year: egen aux_occup_diff = mean(occup_diff)

bysort year: egen aux_sector_diff = mean(sector_diff)

bysort year: egen aux_worker_diff = mean(fixed_worker_diff)

twoway (line aux_w_higer_educ year, lcolor(cranberry*0.4))             ///
	   (line aux_m_higer_educ year, lcolor(cranberry))                 ///
	   (line aux_has_ch year, lcolor(ebblue))                          ///
	   (line aux_diff_born year, lcolor(blue*2))                       ///
	   (line aux_occup_diff year, lcolor(green*1.2))                   ///
	   (line aux_sector_diff year, lcolor(green*.4))                   ///
	   (line aux_worker_diff year, lcolor(orange)),                    ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año")     ///
	   ylabel(0(.25)1) ytitle("Variables binarias")                    ///
	   legend(lab(1 "Mujer más educada") lab(2 "Marido más educado")   ///
	   lab(3 "Hijos") lab(4 "Distinto país de nacimiento")             ///
	   lab(5 "Distinta ocupación") lab(6 "Distinto sector de trabajo") ///
	   lab(7 "Distinto tipo de trabajador") cols(2))

graph export "graphs/binary_variables.pdf", replace

* Segunda tanda de variables

foreach var in l_hwage_w l_hwage_m l_other_hhincome basic_w basic_m         ///
		intermediate_w intermediate_m advanced_w advanced_m exper_w exper_m ///
		fixed_worker_w fixed_worker_m good_health_w good_health_m           ///
		spanish_born_w spanish_born_m eu_born_w eu_born_m foreigner_born_w  ///
		foreigner_born_m {
			
			bysort year: egen aux_`var' = mean(`var')
}

twoway (line aux_basic_w year, lcolor(ebblue*0.5))                           ///
	   (line aux_basic_m year, lcolor(ebblue*0.5) lpattern(dash))            ///
	   (line aux_intermediate_w year, lcolor(ebblue*1.25))                   ///
	   (line aux_intermediate_m year, lcolor(ebblue*1.25) lpattern(dash))    ///
	   (line aux_advanced_w year, lcolor(ebblue*2))                          ///
	   (line aux_advanced_m year, lcolor(ebblue*2) lpattern(dash))           ///
	   (line aux_fixed_worker_w year, lcolor(orange*1.4))                    ///
	   (line aux_fixed_worker_m year, lcolor(orange*1.4) lpattern(dash))     ///
	   (line aux_good_health_w year, lcolor(green*0.4))                      ///
	   (line aux_good_health_m year, lcolor(green*0.4) lpattern(dash))       ///
	   (line aux_spanish_born_w year, lcolor(cranberry*0.4))                 ///
	   (line aux_spanish_born_m year, lcolor(cranberry*0.4) lpattern(dash))  ///
	   (line aux_eu_born_w year, lcolor(cranberry))                          ///
	   (line aux_eu_born_m year, lcolor(cranberry) lpattern(dash))           ///
	   (line aux_foreigner_born_w year, lcolor(cranberry*2))                 ///
	   (line aux_foreigner_born_m year, lcolor(cranberry*2) lpattern(dash)), ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año")           ///
	   ylabel(0(.25)1) ytitle("Variables binarias")                          ///
	   legend(order(1 "Educación básica" 11 "Nacido en España"               ///
	   3 "Educación intermedia" 13 "Nacido resto de la UE"                   ///
	   5 "Educación avanzada" 15 "Nacido fuera de la UE" 7 "Trabajador fijo" ///
	   9 "Buena salud") cols(2))

graph export "graphs/other_binary_variables.pdf", replace

su l_hwage_w l_hwage_m, d

twoway (line aux_l_hwage_w year, lcolor(blue))                            ///
	   (line aux_l_hwage_m year, lcolor(blue) lpattern(dash)),            ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año")        ///
	   ylabel(1.87(.2)2.67) ytitle("Logaritmo del salario por hora")      ///
	   yline(2.33, lcolor(pink) lpattern(dash)) yline(2.18, lcolor(pink)) ///
	   legend(off)

graph export "graphs/aux_l_hwage.pdf", replace

su l_other_hhincome, d

twoway (line aux_l_other_hhincome year, lcolor(blue)),                    ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año")        ///
	   ylabel(7.1(.5)8.9) ytitle("Logaritmo de otros ingresos del hogar") ///
	   yline(7.91, lcolor(pink)) legend(off)

graph export "graphs/aux_l_other_hhincome.pdf", replace

su exper_w exper_m, d

twoway (line aux_exper_w year, lcolor(blue))                       ///
	   (line aux_exper_m year, lcolor(blue) lpattern(dash)),       ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año") ///
	   ylabel(12(5)27) ytitle("Experiencia laboral") yline(21.34,  ///
	   lcolor(pink) lpattern(dash)) yline(17.24, lcolor(pink)) legend(off)

graph export "graphs/aux_exper.pdf", replace

drop aux*

**# Regresiones panel ----------------------------------------------------------

log using "log/regressions.log", replace

* OLS gap_hwage con tipo de emparejamiento

reg gap_hwage w_higher_educ m_higher_educ l_other_hhincome has_ch diff_born ///
	exper_diff occup_diff sector_diff fixed_worker_diff i.year, ro

reg gap_hwage w_higher_educ m_higher_educ l_other_hhincome has_ch diff_born  ///
	exper_diff occup_diff sector_diff fixed_worker_diff i.year ast cant pv ///
	nav rio ara mad cyl clm ext cat val bal and mur ceu mel can, ro

* OLS gap_hwage con distancia de Mahalanobis

reg abs_gap_hwage mahadist l_other_hhincome has_ch diff_born abs_exper_diff ///
	occup_diff sector_diff fixed_worker_diff i.year, ro

reg abs_gap_hwage mahadist l_other_hhincome has_ch diff_born abs_exper_diff   ///
	occup_diff sector_diff fixed_worker_diff i.year ast cant ///
	pv nav rio ara mad cyl clm ext cat val bal and mur ceu mel can, ro

* OLS log salario mujer sobre log salario hombre

reg l_hwage_w intermediate_w advanced_w exper_w exper_w_sq i.year ast cant ///
	pv nav rio ara mad cyl clm ext cat val bal and mur ceu mel can, ro
	
reg l_hwage_w l_hwage_m  has_ch l_other_hhincome intermediate_w advanced_w  ///
	exper_w exper_w_sq fixed_worker_w good_health_w eu_born_w               ///
	foreigner_born_w i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can, ro

reg l_hwage_w l_hwage_m l_other_hhincome intermediate_w advanced_w exper_w  ///
	exper_w_sq has_ch fixed_worker_w good_health_w eu_born_w                ///
	foreigner_born_w i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if same_educ == 1, ro

reg l_hwage_w l_hwage_m l_other_hhincome advanced_w exper_w exper_w_sq      ///
	has_ch fixed_worker_w good_health_w eu_born_w                           ///
	foreigner_born_w i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if w_higher_educ == 1, ro

reg l_hwage_w l_hwage_m l_other_hhincome intermediate_w exper_w exper_w_sq  ///
	has_ch fixed_worker_w good_health_w eu_born_w                           ///
	foreigner_born_w i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if m_higher_educ == 1, ro

* Cambiando roles

reg l_hwage_m l_hwage_w l_other_hhincome intermediate_m advanced_m exper_m  ///
	exper_m_sq has_ch fixed_worker_m good_health_m eu_born_m    ///
	foreigner_born_m i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if same_educ == 1, ro

reg l_hwage_m l_hwage_w l_other_hhincome advanced_m exper_m exper_m_sq      ///
	has_ch fixed_worker_m good_health_m eu_born_m               ///
	foreigner_born_m i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if m_higher_educ == 1, ro

reg l_hwage_m l_hwage_w l_other_hhincome intermediate_m exper_m exper_m_sq  ///
	has_ch fixed_worker_m good_health_m eu_born_m               ///
	foreigner_born_m i.year ast cant pv nav rio ara mad cyl clm ext cat val ///
	bal and mur ceu mel can if w_higher_educ == 1, ro
	
* Regresión cuantílica salario mujer vs salario marido

sqreg l_hwage_w l_hwage_m l_other_hhincome intermediate_w advanced_w exper_w ///
	  exper_w_sq has_ch fixed_worker_w good_health_w eu_born_w   ///
	  foreigner_born_w i.year if same_educ == 1, q(.1 .5 .9)

sqreg l_hwage_w l_hwage_m l_other_hhincome advanced_w exper_w exper_w_sq ///
	  has_ch fixed_worker_w good_health_w eu_born_w          ///
	  foreigner_born_w i.year if w_higher_educ == 1, q(.1 .5 .9)

sqreg l_hwage_w l_hwage_m l_other_hhincome intermediate_w exper_w exper_w_sq ///
	  has_ch fixed_worker_w good_health_w eu_born_w              ///
	  foreigner_born_w i.year if m_higher_educ == 1, q(.1 .5 .9)

log close
