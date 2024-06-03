// -------------------------------------------------------------------------- //
// Archivo do: 04_assortative_mating_over_time.do
// Descripción: Calcula medidas de emparejamiento selectivo en la muestra
// original y en la aleatoria.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
capture log close
set more off
cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV"

*------------------------------------------------------------------------------*
**# SINGLE EARNER COUPLES
*------------------------------------------------------------------------------*

use "data/panel_full.dta", clear

keep if (hwage_w == 0 | hwage_w == .) | (hwage_m == 0 | hwage_m == .)

drop if (status_w != 1) & (status_m != 1)
drop if (status_w == 1) & (status_m == 1)

gen     aux = 1 if (status_w != 1) & (status_m == 1)
replace aux = 2 if (status_w == 1) & (status_m != 1)

gen w_not_work = (aux == 1)
gen m_not_work = (aux == 2)

drop aux

tabstat w_not_work m_not_work, by(year)

*------------------------------------------------------------------------------*
**# EMPAREJAIENTO SELECTIVO
*------------------------------------------------------------------------------*

**# Medida 1 -------------------------------------------------------------------

use "data/panel_double_earner_couples.dta", clear

* Básica hombre - Básica mujer

gen     share_p_p = 0
replace share_p_p = 1 if basic_m + basic_w == 2

* Básica hombre - Intermedia mujer

gen     share_p_s = 0
replace share_p_s = 1 if basic_m + intermediate_w == 2

* Básica hombre - Avanzada mujer

gen     share_p_ps = 0
replace share_p_ps = 1 if basic_m + advanced_w == 2

* Intermedia hombre - Básica mujer

gen     share_s_p = 0
replace share_s_p = 1 if intermediate_m + basic_w == 2

* Intermedia hombre - Intermedia mujer

gen     share_s_s = 0
replace share_s_s = 1 if intermediate_m + intermediate_w == 2

* Intermedia hombre - Avanzada mujer

gen     share_s_ps = 0
replace share_s_ps = 1 if intermediate_m + advanced_w == 2

* Avanzada hombre - Básica mujer

gen     share_ps_p = 0
replace share_ps_p = 1 if advanced_m + basic_w == 2

* Avanzada hombre - Intermedia mujer

gen     share_ps_s = 0
replace share_ps_s = 1 if advanced_m + intermediate_w == 2

* Avanzada hombre - Avanzada mujer

gen     share_ps_ps = 0
replace share_ps_ps = 1 if advanced_m + advanced_w == 2

tabstat share*, by(year) save

* Medida 1 a lo largo del tiempo

gen ass_m1 = 0

replace ass_m1 = 1 if (basic_m + basic_w == 2)     |           ///
		              (intermediate_m + intermediate_w == 2) | ///
					  (advanced_m + advanced_w == 2)

gen mean_ass1_by_year = .

tabstat ass_m1, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_`yr' = r(Stat`yr')[1,1]
	replace mean_ass1_by_year = `mean_`yr'' if t == `yr'
}

drop share_*

**# Distancia de Mahalanobis según educación y edad ----------------------------

gen diff_educ = educ_m - educ_w
gen diff_age  = age_m  - age_w

gen mean_diff_educ_by_yr = .

tabstat diff_educ, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_diff_educ_`yr' = r(Stat`yr')[1,1]
	replace mean_diff_educ_by_yr = `mean_diff_educ_`yr'' if t == `yr'
}

gen mean_diff_age_by_yr = .

tabstat diff_age, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_diff_age_`yr' = r(Stat`yr')[1,1]
	replace mean_diff_age_by_yr = `mean_diff_age_`yr'' if t == `yr'
}

* Calculando la covarianza y su inversa

gen cov = .
gen var_deduc = .
gen var_dage = .

gen aux11 = .
gen aux21 = .
gen aux22 = .

quietly foreach year of numlist 2008/2023 {
	
	cor diff_educ diff_age if year == `year', cov
	replace cov       = r(cov_12) if year == `year'
	replace var_deduc = r(Var_1)  if year == `year'
	replace var_dage  = r(Var_2)  if year == `year'

	matrix covMat = J(2,2,.)

	matrix covMat[1,1] = r(Var_1)
	matrix covMat[2,2] = r(Var_2)
	matrix covMat[2,1] = r(cov_12)
	matrix covMat[1,2] = r(cov_12)

	matrix covInv = inv(covMat)

	matrix list covInv

	replace aux11 = covInv[1,1] if year == `year'
	replace aux21 = covInv[2,1] if year == `year'
	replace aux22 = covInv[2,2] if year == `year'
}

gen mahadist = sqrt( ///
			   (( (diff_educ * aux11) + (diff_age * aux21) ) * diff_educ) + ///
			   (( (diff_educ * aux21) + (diff_age * aux22) ) * diff_age)    ///
			   )

gen mean_ass_m2_by_year = .

tabstat mahadist, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_`yr' = r(Stat`yr')[1,1]
	replace mean_ass_m2_by_year = `mean_`yr'' if t == `yr'
}

drop mean_diff_age_by_yr mean_diff_educ_by_yr cov var_deduc var_dage aux11 ///
	 aux21 aux22

**# Regresión educación mujer sobre educación hombre ---------------------------

reg educ_w educ_m c.educ_m##i.year_2009 c.educ_m##i.year_2010         ///
	c.educ_m##i.year_2011 c.educ_m##i.year_2012 c.educ_m##i.year_2013 ///
	c.educ_m##i.year_2014 c.educ_m##i.year_2015 c.educ_m##i.year_2016 ///
	c.educ_m##i.year_2017 c.educ_m##i.year_2018 c.educ_m##i.year_2019 ///
	c.educ_m##i.year_2020 c.educ_m##i.year_2021 c.educ_m##i.year_2022 ///
	c.educ_m##i.year_2023 i.year
	
gen base_coeff = _b[educ_m]

gen     coeff = base_coeff if year == 2008
replace coeff = base_coeff + _b[1.year_2009#c.educ_m] if year == 2009
replace coeff = base_coeff + _b[1.year_2010#c.educ_m] if year == 2010
replace coeff = base_coeff + _b[1.year_2011#c.educ_m] if year == 2011
replace coeff = base_coeff + _b[1.year_2012#c.educ_m] if year == 2012
replace coeff = base_coeff + _b[1.year_2013#c.educ_m] if year == 2013
replace coeff = base_coeff + _b[1.year_2014#c.educ_m] if year == 2014
replace coeff = base_coeff + _b[1.year_2015#c.educ_m] if year == 2015
replace coeff = base_coeff + _b[1.year_2016#c.educ_m] if year == 2016
replace coeff = base_coeff + _b[1.year_2017#c.educ_m] if year == 2017
replace coeff = base_coeff + _b[1.year_2018#c.educ_m] if year == 2018
replace coeff = base_coeff + _b[1.year_2019#c.educ_m] if year == 2019
replace coeff = base_coeff + _b[1.year_2020#c.educ_m] if year == 2020
replace coeff = base_coeff + _b[1.year_2021#c.educ_m] if year == 2021
replace coeff = base_coeff + _b[1.year_2022#c.educ_m] if year == 2022
replace coeff = base_coeff + _b[1.year_2023#c.educ_m] if year == 2023

* Guardar ----------------------------------------------------------------------

save "data/panel_ass.dta", replace

gen random = 0

save "data/temp/aux.dta", replace

*------------------------------------------------------------------------------*
**# EMPAREJAIENTO ALEATORIO
*------------------------------------------------------------------------------*

**# Medida 1 -------------------------------------------------------------------

use "data/random_panel_double_earner_couples.dta", clear

* Básica hombre - Básica mujer

gen     share_p_p = 0
replace share_p_p = 1 if basic_m + basic_w == 2

* Básica hombre - Intermedia mujer

gen     share_p_s = 0
replace share_p_s = 1 if basic_m + intermediate_w == 2

* Básica hombre - Avanzada mujer

gen     share_p_ps = 0
replace share_p_ps = 1 if basic_m + advanced_w == 2

* Intermedia hombre - Básica mujer

gen     share_s_p = 0
replace share_s_p = 1 if intermediate_m + basic_w == 2

* Intermedia hombre - Intermedia mujer

gen     share_s_s = 0
replace share_s_s = 1 if intermediate_m + intermediate_w == 2

* Intermedia hombre - Avanzada mujer

gen     share_s_ps = 0
replace share_s_ps = 1 if intermediate_m + advanced_w == 2

* Avanzada hombre - Básica mujer

gen     share_ps_p = 0
replace share_ps_p = 1 if advanced_m + basic_w == 2

* Avanzada hombre - Intermedia mujer

gen     share_ps_s = 0
replace share_ps_s = 1 if advanced_m + intermediate_w == 2

* Avanzada hombre - Avanzada mujer

gen     share_ps_ps = 0
replace share_ps_ps = 1 if advanced_m + advanced_w == 2

tabstat share*, by(year)

* Medida 1 a lo largo del tiempo

gen ass_m1 = 0

replace ass_m1 = 1 if (basic_m + basic_w == 2)     |           ///
		              (intermediate_m + intermediate_w == 2) | ///
					  (advanced_m + advanced_w == 2)

gen mean_ass1_by_year_r = .

tabstat ass_m1, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_`yr' = r(Stat`yr')[1,1]
	replace mean_ass1_by_year_r = `mean_`yr'' if t == `yr'
}

**# Distancia de Mahalanobis según educación y edad ----------------------------

* Calculando las medias por año

gen diff_educ = educ_m - educ_w
gen diff_age  = age_m  - age_w

gen mean_diff_educ_by_yr = .

tabstat diff_educ, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_diff_educ_`yr' = r(Stat`yr')[1,1]
	replace mean_diff_educ_by_yr = `mean_diff_educ_`yr'' if t == `yr'
}

gen mean_diff_age_by_yr = .

tabstat diff_age, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_diff_age_`yr' = r(Stat`yr')[1,1]
	replace mean_diff_age_by_yr = `mean_diff_age_`yr'' if t == `yr'
}

* Calculando la covarianza y su inversa

gen cov = .
gen var_deduc = .
gen var_dage = .

gen aux11 = .
gen aux21 = .
gen aux22 = .

quietly foreach year of numlist 2008/2023 {
	
	cor diff_educ diff_age if year == `year', cov
	replace cov       = r(cov_12) if year == `year'
	replace var_deduc = r(Var_1)  if year == `year'
	replace var_dage  = r(Var_2)  if year == `year'

	matrix covMat = J(2,2,.)

	matrix covMat[1,1] = r(Var_1)
	matrix covMat[2,2] = r(Var_2)
	matrix covMat[2,1] = r(cov_12)
	matrix covMat[1,2] = r(cov_12)

	matrix covInv = inv(covMat)

	matrix list covInv

	replace aux11 = covInv[1,1] if year == `year'
	replace aux21 = covInv[2,1] if year == `year'
	replace aux22 = covInv[2,2] if year == `year'
}

gen mahadist = sqrt( ///
			   (( (diff_educ * aux11) + (diff_age * aux21) ) * diff_educ) + ///
			   (( (diff_educ * aux21) + (diff_age * aux22) ) * diff_age)    ///
			   )

gen ass_m2 = .

tabstat mahadist, by(year) statistics(mean) save

quietly foreach yr of numlist 1/16 {
	local mean_`yr' = r(Stat`yr')[1,1]
	replace ass_m2 = `mean_`yr'' if t == `yr'
}

**# Regresión educación mujer sobre educación hombre ---------------------------

reg educ_w educ_m c.educ_m##i.year_2009 c.educ_m##i.year_2010         ///
	c.educ_m##i.year_2011 c.educ_m##i.year_2012 c.educ_m##i.year_2013 ///
	c.educ_m##i.year_2014 c.educ_m##i.year_2015 c.educ_m##i.year_2016 ///
	c.educ_m##i.year_2017 c.educ_m##i.year_2018 c.educ_m##i.year_2019 ///
	c.educ_m##i.year_2020 c.educ_m##i.year_2021 c.educ_m##i.year_2022 ///
	c.educ_m##i.year_2023 i.year
	
gen base_coeff_r = _b[educ_m]

gen     coeff_r = base_coeff_r if year == 2008
replace coeff_r = base_coeff_r + _b[1.year_2009#c.educ_m] if year == 2009
replace coeff_r = base_coeff_r + _b[1.year_2010#c.educ_m] if year == 2010
replace coeff_r = base_coeff_r + _b[1.year_2011#c.educ_m] if year == 2011
replace coeff_r = base_coeff_r + _b[1.year_2012#c.educ_m] if year == 2012
replace coeff_r = base_coeff_r + _b[1.year_2013#c.educ_m] if year == 2013
replace coeff_r = base_coeff_r + _b[1.year_2014#c.educ_m] if year == 2014
replace coeff_r = base_coeff_r + _b[1.year_2015#c.educ_m] if year == 2015
replace coeff_r = base_coeff_r + _b[1.year_2016#c.educ_m] if year == 2016
replace coeff_r = base_coeff_r + _b[1.year_2017#c.educ_m] if year == 2017
replace coeff_r = base_coeff_r + _b[1.year_2018#c.educ_m] if year == 2018
replace coeff_r = base_coeff_r + _b[1.year_2019#c.educ_m] if year == 2019
replace coeff_r = base_coeff_r + _b[1.year_2020#c.educ_m] if year == 2020
replace coeff_r = base_coeff_r + _b[1.year_2021#c.educ_m] if year == 2021
replace coeff_r = base_coeff_r + _b[1.year_2022#c.educ_m] if year == 2022
replace coeff_r = base_coeff_r + _b[1.year_2023#c.educ_m] if year == 2023

**# Preparando gráficos

* Guardar ----------------------------------------------------------------------

save "data/random_panel_ass.dta", replace

gen random = 1

append using "data/temp/aux.dta"

* Gráfica distancia Mahalanobis

twoway (line mean_ass_m2_by_year year if random == 0, lcolor(blue))    ///
	   (line ass_m2 year if random == 1, lcolor(blue) lpattern(dash)), ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año")     ///
	   ytitle("Distancia de Mahalanobis") yscale(reverse)              ///
	   legend(lab(1 "Emparejamiento observado")                        ///
	   lab(2 "Emparejamiento aleatorio") size(3.6))

graph export "graphs/mahadist_juntas.pdf", replace

* Gráfica coeficientes educación de los cónyuges

twoway (line coeff year if random == 0, lcolor(blue))                 ///
	   (line coeff_r year if random == 1, lcolor(blue)                ///
	   lpattern(dash)), graphregion(color(white)) xlabel(2008(2)2023) ///
	   xtitle("Año") ytitle("{&gamma}{sub:t}")                        ///
	   legend(lab(1 "Emparejamiento observado")                       ///
	   lab(2 "Emparejamiento aleatorio") size(3.6))

graph export "graphs/coef_juntas.pdf", replace

* Gráfica parejas con mismo nivel educativo

replace ass_m1 = . if ass_m1 == 0 | ass_m1 == 1

duplicates drop year mean_ass1_by_year mean_ass1_by_year_r, force

sort year mean_ass1_by_year

order year mean_ass1_by_year mean_ass1_by_year_r

gen ratio_ass1 = mean_ass1_by_year[_n] / mean_ass1_by_year_r[_n+1] ///
	if random == 0

twoway (line ratio_ass1 year if random == 0, lcolor(blue)),        ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año") ///
	   ytitle("Ratio de emparejamiento observado y aleatorio")

graph export "graphs/ass1_ratio.pdf", replace
