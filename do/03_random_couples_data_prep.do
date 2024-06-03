// -------------------------------------------------------------------------- //
// Archivo do: 03_random_couples_data_prep.do
// Descripción: Prepara la muestra de emparejamiento aleatorio.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
capture log close
set more off
cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV/data"

**# EMPAREJAIENTO ALEATORIO

* Crear una muestra para mujeres

quietly foreach year of numlist 2008/2023 {
	
	use "temp/`year'_women_renamed.dta", clear
	
	drop id_couple

	set seed 131271

	gen  random_number = runiform()
	sort random_number

	gen id_r_couple = _n

	drop random_number

	save "temp/`year'_random_women.dta", replace
}

* Crear una muestra para hombres

quietly foreach year of numlist 2008/2023 {
	
	use "temp/`year'_men_renamed.dta", clear
	
	drop id_couple

	set seed 160371

	gen  random_number = runiform()
	sort random_number

	gen id_r_couple = _n

	drop random_number

	save "temp/`year'_random_men.dta", replace
}

* Merge

foreach year of numlist 2008/2023 {
	
	use "temp/`year'_random_women.dta", clear
	
	merge m:m id_r_couple using "temp/`year'_random_men"

	drop id man woman _merge

	* Misma educación
	
	gen same_educ = 0
	
	replace same_educ = 1 if (basic_m == basic_w) & (intermediate_m == ///
		intermediate_w) & (advanced_m == advanced_w)
	
	* Mujer con mayor educación
	
	gen w_higher_educ = 0
	
	replace w_higher_educ = 1 if (basic_m == 1) & ///
		    (intermediate_w == 1 | advanced_w == 1)
	
	replace w_higher_educ = 1 if (intermediate_m == 1) & (advanced_w == 1)
	
	* Hombre con mayor educación
	
	gen m_higher_educ = 0
	
	replace m_higher_educ = 1 if (basic_w == 1) & ///
		    (intermediate_m == 1 | advanced_m == 1)
	
	replace m_higher_educ = 1 if (intermediate_w == 1) & (advanced_m == 1)
	
	* Creando variable para el grado de emparejamiento selectivo (orden inverso)

	gen     assortative = 1 if same_educ == 1
	replace assortative = 2 if w_higher_educ == 1
	replace assortative = 3 if m_higher_educ == 1
	
	* Year
	
	gen year = `year'

	save "data_`year'_random_couples.dta", replace
}

* Append

use "data_2008_random_couples.dta", clear

foreach year of numlist 2009/2023 {
	
    append using "data_`year'_random_couples.dta"
	
}

* Trend dummies

gen t  = year - 2007
gen t2 = t * t
gen t3 = t2 * t

* Year duumies

foreach yr of numlist 2008/2023 {
    gen year_`yr' = (year == `yr')
}

save "panel_random_full.dta", replace

merge m:1 year using "CPI.dta"

drop _merge

replace hwage_w    = hwage_w    / CPI
replace hwage_m    = hwage_m    / CPI
replace earnings_w = earnings_w / CPI
replace earnings_m = earnings_m / CPI
replace wage_w     = wage_w     / CPI
replace wage_m     = wage_m     / CPI

drop CPI

gen l_hwage_w     = log(hwage_w)
gen l_hwage_m     = log(hwage_m)
gen l_earnings_w  = log(earnings_w)
gen l_earnings_m  = log(earnings_m)
gen l_wage_w      = log(wage_w)
gen l_wage_m      = log(wage_m)
gen l_hh_income_w = log(hh_income_w)
gen l_hh_income_m = log(hh_income_m)

save "panel_random_full.dta", replace

* Mantener parejas para los que se observa salario para ambos

drop if (hwage_w == 0 | hwage_w == .)
drop if (hwage_m == 0 | hwage_m == .)

gen gap_hwage    = (l_hwage_m - l_hwage_w) * 100
gen gap_earnings = (l_earnings_m - l_earnings_w) * 100
gen abs_gap_hwage = abs(gap_hwage)

* Restringir muestra a personas entre 23 y 60 años

drop if age_w < 23 | age_w > 55
drop if age_m < 23 | age_m > 55

* Creando variables de educación

gen     educ_w = 1 if basic_w        == 1
replace educ_w = 2 if intermediate_w == 1
replace educ_w = 3 if advanced_w     == 1

gen     educ_m = 1 if basic_m        == 1
replace educ_m = 2 if intermediate_m == 1
replace educ_m = 3 if advanced_m     == 1

* Restringiendo la muestra a logaritmos positivos

drop if l_hwage_m     <= 0
drop if l_hwage_w     <= 0
drop if l_hh_income_w <= 0
drop if l_hh_income_m <= 0
drop if l_earnings_w  <= 0
drop if l_earnings_m  <= 0

* Creando variable dummy de hijos

gen has_ch = 0
replace has_ch = 1 if children_w >= 1 | children_m >= 1

* Creando dummy de cónyuges nacidos en países distintos

gen     diff_born = 1
replace diff_born = 0 if (spanish_born_w == spanish_born_m) & ///
		(eu_born_w == eu_born_m) & (foreigner_born_w == foreigner_born_m)

* Creando cuadrado de experiencia y diferencia de experiencia

gen exper_w_sq = exper_w^2
gen exper_m_sq = exper_m^2

gen exper_diff = exper_m - exper_w

* Creando dummy de cónyuges con distina ocupación

gen     occup_diff = 1
replace occup_diff = 0 if occupation_w == occupation_m

* Creando dummy de cónyuges con distino sector de trabajo

gen     sector_diff = 1
replace sector_diff = 0 if work_sector_w == work_sector_m

save "random_panel_double_earner_couples.dta", replace
