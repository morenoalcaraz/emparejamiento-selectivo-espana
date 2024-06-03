// -------------------------------------------------------------------------- //
// Archivo do: 01_data_prep_over_time.do
// Descripción: Prepara la muestra usando las ECVs desde 2008 a 2023.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
set more off
capture log close

cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV/data"

**# 2008

foreach year of numlist 2008 {
	
	**# Fichero d: datos básicos del hogar
	
    import delimited "raw/`year'/esudb`year'd.csv", delimiter(",") clear
	
	* Variables de interés
	
	rename db030 id_hh
	rename db040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	import delimited "raw/`year'/esudb`year'h.csv", delimiter(",") clear
	
	* Variables de interés
	
	ren hb030 id_hh
	ren hx040 hh_size
	ren hy020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	import delimited "raw/`year'/esudb`year'p.csv", delimiter(",") clear
	
	* Variables of interest
	
	ren pb030  id
	ren pb150  sex
	ren pb180  id_partner
	ren pb200  marital_status
	ren pb210  birth_country
	ren pb220a nationality
	ren pe040  educ
	ren pl030  employment_situation
	ren pl050  occupation
	ren pl060  hours
	ren pl070  months_full_time
	ren pl072  months_part_time
	ren pl110a work_sector
	ren pl140  contract_duration
	ren pl200  exper
	ren ph010  health_status
	ren py010n earnings
	
	keep id sex id_partner marital_status birth_country nationality educ    ///
		 employment_situation occupation hours months_full_time             ///
		 months_part_time work_sector contract_duration exper health_status ///
		 earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3 | birth_country == 4)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3 | nationality == 4)

	* Niveles de educación

	destring educ, replace

	gen basic       = (educ == 1)
	gen intermediate     = (educ == 2 | educ == 3 | educ == 4)
	gen advanced = (educ == 5)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1 | employment_situation == 2)

	replace status = 2 if employment_situation == 3
	replace status = 3 if employment_situation == 8
	replace status = 4 if employment_situation == 4 |               ///
			employment_situation == 5 | employment_situation == 6 | ///
			employment_situation == 7 | employment_situation == 9
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo
	
	replace work_sector = "agricultura"  if work_sector == "a+b"
	replace work_sector = "industria"    if work_sector == "c+d+e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "h"
	replace work_sector = "transporte"   if work_sector == "i"
	replace work_sector = "finanzas"     if work_sector == "j"
	replace work_sector = "inmobiliaria" if work_sector == "k"
	replace work_sector = "otros"        if (strlen(work_sector) < 7) & ///
											(work_sector != " ")
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0

	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 2)
	gen fixed_worker    = (contract_duration == 1)
	
	* Horario de trabajo
	
	gen full_time = (employment_situation == 1)
	gen part_time = (employment_situation == 2)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)

	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                   ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                ///
		   "`var'" != "contract_duration" & "`var'" != "earnings" &         ///
		   "`var'" != "wage" &  "`var'" != "hwage" & "`var'" != "l_hwage" & ///
		   "`var'" != "l_earnings" & "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
	
	* Eliminando variables innecesarias
	
	drop sex marital_status birth_country nationality educ                   ///
		 employment_situation hours months_full_time months_part_time months ///
		 contract_duration health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	import delimited "raw/`year'/esudb`year'r.csv", delimiter(",") clear
	
	* Variables de interés

	ren rb030 id
	ren rb080 birth_year
	ren rb220 id_father
	ren rb230 id_mother

	keep id birth_year id_father id_mother
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal ///
			and mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# 2009 - 2010

foreach year of numlist 2009/2010 {
	
	**# Fichero d: Datos básicos del hogar
	
    import delimited "raw/`year'/esudb`year'd.csv", delimiter(",") clear
	
	* Variables de interés
	
	rename db030 id_hh
	rename db040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	import delimited "raw/`year'/esudb`year'h.csv", delimiter(",") clear
	
	* Variables de interés
	
	ren hb030 id_hh
	ren hx040 hh_size
	ren hy020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	import delimited "raw/`year'/esudb`year'p.csv", delimiter(",") clear
	
	* Variables of interest
	
	ren pb030  id
	ren pb150  sex
	ren pb180  id_partner
	ren pb200  marital_status
	ren pb210  birth_country
	ren pb220a nationality
	ren pe040  educ
	ren pl031  employment_situation
	ren pl050  occupation
	ren pl060  hours
	ren pl073  months_full_time
	ren pl074  months_part_time
	ren pl111a work_sector
	ren pl140  contract_duration
	ren pl200  exper
	ren ph010  health_status
	ren py010n earnings
	
	keep id sex id_partner marital_status birth_country nationality educ    ///
		 employment_situation occupation hours months_full_time             ///
		 months_part_time work_sector contract_duration exper health_status ///
		 earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3 | birth_country == 4)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3 | nationality == 4)

	* Niveles de educación

	destring educ, replace

	gen basic       = (educ == 1)
	gen intermediate     = (educ == 2 | educ == 3 | educ == 344 | educ == 4)
	gen advanced = (educ == 5)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1 | employment_situation == 2 ///
		| employment_situation == 3 | employment_situation == 4)

	replace status = 2 if employment_situation == 5
	replace status = 3 if employment_situation == 10
	replace status = 4 if employment_situation == 6 |                ///
			employment_situation == 7 | employment_situation == 8  | ///
			employment_situation == 9 | employment_situation == 11
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo

	replace work_sector = "agricultura"  if work_sector == "a"
	replace work_sector = "industria"    if work_sector == "b" | ///
											work_sector == "c" | ///
											work_sector == "d" | ///
											work_sector == "e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "i"
	replace work_sector = "transporte"   if work_sector == "h" | ///
											work_sector == "j"
	replace work_sector = "finanzas"     if work_sector == "k"
	replace work_sector = "inmobiliaria" if work_sector == "l" | ///
											work_sector == "n"
	replace work_sector = "otros"        if work_sector == "m" | ///
											work_sector == "o" | ///
											work_sector == "p" | ///
											work_sector == "q" | ///
											work_sector == "r" | ///
											work_sector == "s" | ///
											work_sector == "t" | ///
											work_sector == "u"
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0

	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 2)
	gen fixed_worker    = (contract_duration == 1)
	
	* Horario de trabajo
	
	gen full_time = (employment_situation == 1 | employment_situation == 3)
	gen part_time = (employment_situation == 2 | employment_situation == 4)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)
	
	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                   ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                ///
		   "`var'" != "contract_duration" & "`var'" != "earnings" &         ///
		   "`var'" != "wage" &  "`var'" != "hwage" & "`var'" != "l_hwage" & ///
		   "`var'" != "l_earnings" & "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
					   
	* Eliminando variables innecesarias
	
	drop sex marital_status birth_country nationality educ                   ///
		 employment_situation hours months_full_time months_part_time months ///
		 contract_duration health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	import delimited "raw/`year'/esudb`year'r.csv", delimiter(",") clear
	
	* Variables de interés

	ren rb030 id
	ren rb080 birth_year
	ren rb220 id_father
	ren rb230 id_mother

	keep id birth_year id_father id_mother
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas completas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal and ///
			mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# 2011 - 2013

foreach year of numlist 2011/2013 {
	
	**# Fichero d: Datos básicos del hogar
	
    import delimited "raw/`year'/esudb`year'd.csv", delimiter(",") clear
	
	* Variables de interés
	
	rename db030 id_hh
	rename db040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	import delimited "raw/`year'/esudb`year'h.csv", delimiter(",") clear
	
	* Variables de interés
	
	ren hb030 id_hh
	ren hx040 hh_size
	ren hy020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	import delimited "raw/`year'/esudb`year'p.csv", delimiter(",") clear
	
	* Variables of interest
	
	ren pb030  id
	ren pb150  sex
	ren pb180  id_partner
	ren pb200  marital_status
	ren pb210  birth_country
	ren pb220a nationality
	ren pe040  educ
	ren pl031  employment_situation
	ren pl051  occupation
	ren pl060  hours
	ren pl073  months_full_time
	ren pl074  months_part_time
	ren pl111a work_sector
	ren pl140  contract_duration
	ren pl200  exper
	ren ph010  health_status
	ren py010n earnings
	
	keep id sex id_partner marital_status birth_country nationality educ    ///
		 employment_situation occupation hours months_full_time             ///
		 months_part_time work_sector contract_duration exper health_status ///
		 earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3 | birth_country == 4)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3 | nationality == 4)

	* Niveles de educación

	destring educ, replace

	gen basic       = (educ == 1)
	gen intermediate     = (educ == 2 | educ == 3 | educ == 344 | educ == 4)
	gen advanced = (educ == 5)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1 | employment_situation == 2 ///
		| employment_situation == 3 | employment_situation == 4)

	replace status = 2 if employment_situation == 5
	replace status = 3 if employment_situation == 10
	replace status = 4 if employment_situation == 6 |                ///
			employment_situation == 7 | employment_situation == 8  | ///
			employment_situation == 9 | employment_situation == 11
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo

	replace work_sector = "agricultura"  if work_sector == "a"
	replace work_sector = "industria"    if work_sector == "b" | ///
											work_sector == "c" | ///
											work_sector == "d" | ///
											work_sector == "e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "i"
	replace work_sector = "transporte"   if work_sector == "h" | ///
											work_sector == "j"
	replace work_sector = "finanzas"     if work_sector == "k"
	replace work_sector = "inmobiliaria" if work_sector == "l" | ///
											work_sector == "n"
	replace work_sector = "otros"        if work_sector == "m" | ///
											work_sector == "o" | ///
											work_sector == "p" | ///
											work_sector == "q" | ///
											work_sector == "r" | ///
											work_sector == "s" | ///
											work_sector == "t" | ///
											work_sector == "u"
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0

	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 2)
	gen fixed_worker    = (contract_duration == 1)
	
	* Horario de trabajo
	
	gen full_time = (employment_situation == 1 | employment_situation == 3)
	gen part_time = (employment_situation == 2 | employment_situation == 4)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)
	
	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                   ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                ///
		   "`var'" != "contract_duration" & "`var'" != "earnings" &         ///
		   "`var'" != "wage" &  "`var'" != "hwage" & "`var'" != "l_hwage" & ///
		   "`var'" != "l_earnings" & "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
					   
	* Eliminando variables innecesarias
	
	drop sex marital_status birth_country nationality educ                   ///
		 employment_situation hours months_full_time months_part_time months ///
		 contract_duration health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	import delimited "raw/`year'/esudb`year'r.csv", delimiter(",") clear
	
	* Variables de interés

	ren rb030 id
	ren rb080 birth_year
	ren rb220 id_father
	ren rb230 id_mother

	keep id birth_year id_father id_mother
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas completas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal and ///
			mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# 2014 - 2015

foreach year of numlist 2014/2015 {
	
	**# Fichero d: datos básicos del hogar
	
    import delimited "raw/`year'/esudb`year'd.csv", delimiter(",") clear
	
	* Variables de interés
	
	rename db030 id_hh
	rename db040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	import delimited "raw/`year'/esudb`year'h.csv", delimiter(",") clear
	
	* Variables de interés
	
	ren hb030 id_hh
	ren hx040 hh_size
	ren hy020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	import delimited "raw/`year'/esudb`year'p.csv", delimiter(",") clear
	
	* Variables of interest
	
	ren pb030  id
	ren pb150  sex
	ren pb180  id_partner
	ren pb200  marital_status
	ren pb210  birth_country
	ren pb220a nationality
	ren pe040  educ
	ren pl031  employment_situation
	ren pl051  occupation
	ren pl060  hours
	ren pl073  months_full_time
	ren pl074  months_part_time
	ren pl111a work_sector
	ren pl140  contract_duration
	ren pl200  exper
	ren ph010  health_status
	ren py010n earnings
	
	keep id sex id_partner marital_status birth_country nationality educ    ///
		 employment_situation occupation hours months_full_time             ///
		 months_part_time work_sector contract_duration exper health_status ///
		 earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3 | birth_country == 4)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3 | nationality == 4)

	* Niveles de educación

	destring educ, replace
	
	gen basic        = (educ == 0 | educ == 100)
	gen intermediate = (educ == 200 | educ == 300 | educ == 344 | ///
	                    educ == 353 | educ == 354 | educ == 400 | educ == 450)
	gen advanced     = (educ == 500)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1 | employment_situation == 2 ///
		| employment_situation == 3 | employment_situation == 4)

	replace status = 2 if employment_situation == 5
	replace status = 3 if employment_situation == 10
	replace status = 4 if employment_situation == 6 |                ///
			employment_situation == 7 | employment_situation == 8  | ///
			employment_situation == 9 | employment_situation == 11
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo

	replace work_sector = "agricultura"  if work_sector == "a"
	replace work_sector = "industria"    if work_sector == "b" | ///
											work_sector == "c" | ///
											work_sector == "d" | ///
											work_sector == "e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "i"
	replace work_sector = "transporte"   if work_sector == "h" | ///
											work_sector == "j"
	replace work_sector = "finanzas"     if work_sector == "k"
	replace work_sector = "inmobiliaria" if work_sector == "l" | ///
											work_sector == "n"
	replace work_sector = "otros"        if work_sector == "m" | ///
											work_sector == "o" | ///
											work_sector == "p" | ///
											work_sector == "q" | ///
											work_sector == "r" | ///
											work_sector == "s" | ///
											work_sector == "t" | ///
											work_sector == "u"
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0

	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 2)
	gen fixed_worker    = (contract_duration == 1)
	
	* Horario de trabajo
	
	gen full_time = (employment_situation == 1 | employment_situation == 3)
	gen part_time = (employment_situation == 2 | employment_situation == 4)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)
	
	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                   ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                ///
		   "`var'" != "contract_duration" & "`var'" != "earnings" &         ///
		   "`var'" != "wage" &  "`var'" != "hwage" & "`var'" != "l_hwage" & ///
		   "`var'" != "l_earnings" & "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
					   
	* Eliminando variables innecesarias
	
	drop sex marital_status birth_country nationality educ                   ///
		 employment_situation hours months_full_time months_part_time months ///
		 contract_duration health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	import delimited "raw/`year'/esudb`year'r.csv", delimiter(",") clear
	
	* Variables de interés

	ren rb030 id
	ren rb080 birth_year
	ren rb220 id_father
	ren rb230 id_mother

	keep id birth_year id_father id_mother
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas completas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal and ///
			mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# 2016 - 2020

foreach year of numlist 2016/2020 {
	
	**# Fichero d: datos básicos del hogar
	
    use "raw/`year'/ECV_Td_`year'.dta", clear
	
	* Variables de interés
	
	rename DB030 id_hh
	rename DB040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	use "raw/`year'/ECV_Th_`year'.dta", clear
	
	* Variables de interés
	
	ren HB030 id_hh
	ren HX040 hh_size
	ren HY020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	use "raw/`year'/ECV_Tp_`year'.dta", clear
	
	* Variables of interest
	
	ren PB030  id
	ren PB150  sex
	ren PB180  id_partner
	ren PB200  marital_status
	ren PB210  birth_country
	ren PB220A nationality
	ren PE040  educ
	ren PL031  employment_situation
	ren PL051  occupation
	ren PL060  hours
	ren PL073  months_full_time
	ren PL074  months_part_time
	ren PL111A work_sector
	ren PL140  contract_duration
	ren PL200  exper
	ren PH010  health_status
	ren PY010N earnings
	
	keep id sex id_partner marital_status birth_country nationality educ    ///
		 employment_situation occupation hours months_full_time             ///
		 months_part_time work_sector contract_duration exper health_status ///
		 earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3 | birth_country == 4)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3 | nationality == 4)

	* Niveles de educación

	destring educ, replace

	gen basic        = (educ == 0 | educ == 100)
	gen intermediate = (educ == 200 | educ == 300 | educ == 344 | ///
	                    educ == 353 | educ == 354 | educ == 400 | educ == 450)
	gen advanced     = (educ == 500)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1 | employment_situation == 2 ///
		| employment_situation == 3 | employment_situation == 4)

	replace status = 2 if employment_situation == 5
	replace status = 3 if employment_situation == 10
	replace status = 4 if employment_situation == 6 |                ///
			employment_situation == 7 | employment_situation == 8  | ///
			employment_situation == 9 | employment_situation == 11
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo

	replace work_sector = "agricultura"  if work_sector == "a"
	replace work_sector = "industria"    if work_sector == "b" | ///
											work_sector == "c" | ///
											work_sector == "d" | ///
											work_sector == "e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "i"
	replace work_sector = "transporte"   if work_sector == "h" | ///
											work_sector == "j"
	replace work_sector = "finanzas"     if work_sector == "k"
	replace work_sector = "inmobiliaria" if work_sector == "l" | ///
											work_sector == "n"
	replace work_sector = "otros"        if work_sector == "m" | ///
											work_sector == "o" | ///
											work_sector == "p" | ///
											work_sector == "q" | ///
											work_sector == "r" | ///
											work_sector == "s" | ///
											work_sector == "t" | ///
											work_sector == "u"
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0

	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 2)
	gen fixed_worker    = (contract_duration == 1)
	
	* Horario de trabajo
	
	gen full_time = (employment_situation == 1 | employment_situation == 3)
	gen part_time = (employment_situation == 2 | employment_situation == 4)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)
	
	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                   ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                ///
		   "`var'" != "contract_duration" & "`var'" != "earnings" &         ///
		   "`var'" != "wage" &  "`var'" != "hwage" & "`var'" != "l_hwage" & ///
		   "`var'" != "l_earnings" & "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
					   
	* Eliminando variables innecesarias
	
	drop sex marital_status birth_country nationality educ                   ///
		 employment_situation hours months_full_time months_part_time months ///
		 contract_duration health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	use "raw/`year'/ECV_Tr_`year'.dta", clear
	
	* Variables de interés

	ren RB030 id
	ren RB080 birth_year
	ren RB220 id_father
	ren RB230 id_mother

	keep id birth_year id_father id_mother
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas completas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal and ///
			mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# 2021 - 2023

foreach year of numlist 2021/2023 {
	
	**# Fichero d: datos básicos del hogar
	
    use "raw/`year'/ECV_Td_`year'.dta", clear
	
	* Variables de interés
	
	rename DB030 id_hh
	rename DB040 region
	
	keep id_hh region
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Regiones
	
	drop if region == "ESZZ"
	
	gen gal  = (region == "ES11")
	gen ast  = (region == "ES12")
	gen cant = (region == "ES13")
	gen pv   = (region == "ES21")
	gen nav  = (region == "ES22")
	gen rio  = (region == "ES23")
	gen ara  = (region == "ES24")
	gen mad  = (region == "ES30")
	gen cyl  = (region == "ES41")
	gen clm  = (region == "ES42")
	gen ext  = (region == "ES43")
	gen cat  = (region == "ES51")
	gen val  = (region == "ES52")
	gen bal  = (region == "ES53")
	gen and  = (region == "ES61")
	gen mur  = (region == "ES62")
	gen ceu  = (region == "ES63")
	gen mel  = (region == "ES64")
	gen can  = (region == "ES70")
	
	* Eliminando variables innecesarias
	
	drop region
	
	* Guardar
	
	save "temp/d_`year'.dta", replace
	
	**# Fichero h: datos detallados del hogar
	
	use "raw/`year'/ECV_Th_`year'.dta", clear
	
	* Variables de interés
	
	ren HB030 id_hh
	ren HX040 hh_size
	ren HY020 hh_income
	
	keep id_hh hh_size hh_income
	
	* Eliminano valores ausentes
	
	foreach var of varlist _all {
		drop if mi(`var')
	}
	
	* Guardar
	
	save "temp/h_`year'.dta", replace
	
	**# Fichero p: datos detallados de la persona
	
	use "raw/`year'/ECV_Tp_`year'.dta", clear
	
	* Variables of interest
	
	ren PB030   id
	ren PB150   sex
	ren PB180   id_partner
	ren PB200   marital_status
	ren PE041   educ
	ren PL032   employment_situation
	ren PL051A  occupation
	ren PL060   hours
	ren PL073   months_full_time
	ren PL074   months_part_time
	ren PL111AA work_sector
	ren PL141   contract_duration
	ren PL145   work_schedule
	ren PL200   exper
	ren PH010   health_status
	ren PY010N  earnings
	
	keep id sex id_partner marital_status educ employment_situation     ///
		 occupation hours months_full_time months_part_time work_sector ///
		 contract_duration work_schedule exper health_status earnings
	
	* id del hogar

	gen id_hh = floor(id / 100)

	* Sexo

	destring sex, replace

	gen man   = (sex == 1)
	gen woman = (sex == 2)

	* Casados/parejas de hecho

	destring marital_status, replace

	gen married  = (marital_status == 1 | marital_status == 2)

	* Niveles de educación

	destring educ, replace
	
	gen basic        = (educ == 0 | educ == 100)
	gen intermediate = (educ == 200 | educ == 340 | educ == 344 | ///
	                    educ == 350 | educ == 353 | educ == 354 | educ == 450)
	gen advanced     = (educ == 500)
	
	* Situación de empleo

	destring employment_situation, replace

	gen status = (employment_situation == 1)

	replace status = 2 if employment_situation == 2
	replace status = 3 if employment_situation == 6
	replace status = 4 if employment_situation == 3 | employment_situation == 4 ///
			| employment_situation == 5 | employment_situation == 7 ///
			| employment_situation == 8
	
	label define status 1 "Trabajador"
	label define status 2 "Parado", add
	label define status 3 "Dedicado a labores del hogar", add
	label define status 4 "Otro inactivo", add

	* Ocupación

	replace occupation = "Managers"      if substr(occupation, 1, 1) == "1"
	replace occupation = "Professionals" if substr(occupation, 1, 1) == "2"
	replace occupation = "Technicians and associate professionals"          ///
										 if substr(occupation, 1, 1) == "3"
	replace occupation = "Clerical support workers"                         ///
										 if substr(occupation, 1, 1) == "4"
	replace occupation = "Service and sales workers"                        ///
										 if substr(occupation, 1, 1) == "5"
	replace occupation = "Skilled agricultural, forestry & fishery workers" ///
										 if substr(occupation, 1, 1) == "6"
	replace occupation = "Craft and related trades workers"                 ///
										 if substr(occupation, 1, 1) == "7"
	replace occupation = "Plant and machine operators, and assemblers"      ///
										 if substr(occupation, 1, 1) == "8"
	replace occupation = "Elementary occupations"                           ///
										 if substr(occupation, 1, 1) == "9"
	replace occupation = "Armed forces occupations"                         ///
										 if substr(occupation, 1, 1) == "0"
	replace occupation = "Not specified" if substr(occupation, 1, 1) == " "
	
	* Sector del trabajo

	replace work_sector = "agricultura"  if work_sector == "a"
	replace work_sector = "industria"    if work_sector == "b" | ///
											work_sector == "c" | ///
											work_sector == "d" | ///
											work_sector == "e"
	replace work_sector = "construccion" if work_sector == "f"
	replace work_sector = "comercio"     if work_sector == "g"
	replace work_sector = "hosteleria"   if work_sector == "i"
	replace work_sector = "transporte"   if work_sector == "h" | ///
											work_sector == "j"
	replace work_sector = "finanzas"     if work_sector == "k"
	replace work_sector = "inmobiliaria" if work_sector == "l" | ///
											work_sector == "n"
	replace work_sector = "otros"        if work_sector == "m" | ///
											work_sector == "o" | ///
											work_sector == "p" | ///
											work_sector == "q" | ///
											work_sector == "r" | ///
											work_sector == "s" | ///
											work_sector == "t" | ///
											work_sector == "u"
	replace work_sector = "No se especifica" if substr(work_sector, 1, 1) == " "

	* Meses trabajados
	
	destring months_full_time months_part_time hours, replace

	gen months = max(months_full_time, months_part_time) if !mi(hours) & ///
		!(months_full_time + months_part_time == 0)
		
	* Salario anual y por hora
	
	gen wage = earnings if !mi(hours) & !mi(months)
	
	gen hwage = wage / (hours * 4.345 * months)
	
	replace hwage = . if hwage == 0
	
	* Tipos de contrato

	destring contract_duration, replace

	gen temporal_worker = (contract_duration == 11 | contract_duration == 12)
	gen fixed_worker    = (contract_duration == 21 | contract_duration == 22)
	
	* Horario de trabajo
	
	destring work_schedule, replace

	gen full_time = (work_schedule == 1)
	gen part_time = (work_schedule == 2)
	
	* Exper
	
	destring exper, replace

	replace exper = 0 if missing(exper)

	* Estado de salud

	destring health_status, replace
	
	gen good_health = (health_status == 1 | health_status == 2)
	gen bad_health  = (health_status == 3 | health_status == 4 | ///
					   health_status == 5)
	
	* Eliminando valores ausentes

	foreach var of varlist _all {
		if "`var'" != "occupation" & "`var'" != "hours" &                    ///
		   "`var'" != "months" &  "`var'" != "work_sector" &                 ///
		   "`var'" != "contract_duration" & "`var'" != "work_schedule" &     ///
		   "`var'" != "earnings" & "`var'" != "wage" &  "`var'" != "hwage" & ///
		   "`var'" != "l_hwage" & "`var'" != "l_earnings" &                  ///
		   "`var'" != "id_partner" {
			display "Checking variable: `var'"
			drop if mi(`var')
		}
	}
					   
	* Eliminando variables innecesarias
	
	drop sex marital_status educ employment_situation hours months_full_time ///
		 months_part_time months contract_duration work_schedule health_status
		
	* Guardar
	
	save "temp/p_`year'.dta", replace
	
	**# Fichero r: datos básicos de la persona (incluye menores de 16)
	
	use "raw/`year'/ECV_Tr_`year'.dta", clear
	
	* Variables de interés

	ren RB030 id
	ren RB080 birth_year
	ren RB220 id_father
	ren RB230 id_mother
	ren RB280 birth_country
	ren RB290 nationality

	keep id birth_year id_father id_mother birth_country nationality
	
	* Edad
	
	gen age = `year' - birth_year

	* Número de hijos y edad del hijo menor
	
	destring id_father id_mother, replace

	egen temp = count(id_father), by(id_father)

	egen f_child = min(age), by(id_father)

	replace f_child = . if id_father == .

	gen aux = .

	quietly forvalues i = 1 / `=_N' {
		replace aux = temp[`i'] if id == id_father[`i']
		replace f_child = f_child[`i'] if id == id_father[`i']
	}

	egen temp2 = count(id_mother), by(id_mother)

	egen m_child = min(age), by(id_mother)

	replace m_child = . if id_mother == .

	gen aux2 = .

	quietly forvalues i = 1 / `=_N' {
		replace aux2 = temp2[`i'] if id == id_mother[`i']
		replace m_child = m_child[`i'] if id == id_mother[`i']
	}

	replace aux  = 0 if missing(aux)
	replace aux2 = 0 if missing(aux2)

	gen children = aux + aux2

	gen     youngest_child = f_child if children != 0
	replace youngest_child = m_child if children != 0 & youngest_child == .

	foreach var in id age children {
		drop if mi(`var')
	}
	
	* País de nacimiento

	destring birth_country, replace

	gen spanish_born   = (birth_country == 1)
	gen eu_born        = (birth_country == 2)
	gen foreigner_born = (birth_country == 3)

	* Nacionalidad

	destring nationality, replace

	gen spanish_nat   = (nationality == 1)
	gen eu_nat        = (nationality == 2)
	gen foreigner_nat = (nationality == 3)
	
	* Eliminando variables innecesarias
	
	drop temp temp2 id_father id_mother aux aux2 f_child m_child ///
		 birth_country nationality
	
	* Guardar
	
	save "temp/r_`year'.dta", replace
	
	**# Juntando bases de datos
	
	* Hogares
	
	use "temp/d_`year'.dta", clear

	merge 1:1 id_hh using "temp/h_`year'.dta"

	drop _merge

	save "temp/households_`year'.dta", replace
	
	* Individuos
	
	use "temp/p_`year'.dta", clear
	
	merge 1:1 id using "temp/r_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	save "temp/individuals_`year'.dta", replace
	
	* Final dataset
	
	use "temp/individuals_`year'.dta", clear
	
	merge m:1 id_hh using "temp/households_`year'.dta"
	
	keep if _merge == 3
	
	drop _merge
	
	* Identificando y restringiendo la muestra a parejas completas
	
	destring id_partner, replace

	drop if missing(id_partner)

	gen   id_min    = min(id, id_partner)
	egen  id_couple = group(id_min)
	order id*
	drop  id_min id_partner
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	* Quedándonos con parejas heterosexuales
	
	duplicates report id_couple woman
	duplicates drop   id_couple woman, force
	
	sort       id_couple
	duplicates report id_couple
	drop if    id_couple != id_couple[_n-1] & id_couple != id_couple[_n+1]

	save "temp/`year'_data_couples.dta", replace
	
	**# Organizar parejas por filas
	
	* Hombres

	use "temp/`year'_data_couples.dta", clear

	keep if man == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_m
	}
		  
	save "temp/`year'_men_renamed", replace

	* Para mujeres

	use "temp/`year'_data_couples.dta", clear

	keep if woman == 1

	ds id id_couple man woman, not

	foreach var of varlist `r(varlist)' {
		rename `var' `var'_w
	}
		  
	save "temp/`year'_women_renamed", replace

	* Merge

	merge m:m id_couple using "temp/`year'_men_renamed"

	foreach var in gal ast cant pv nav rio ara mad cyl clm ext cat val bal and ///
			mur ceu mel can id_hh hh_size hh_income married {
				drop if `var'_w != `var'_m
				drop `var'_w
				ren `var'_m `var'
			}

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

	save "data_`year'_couples_in_rows.dta", replace
}

**# Panel

use "data_2008_couples_in_rows.dta", clear

foreach year of numlist 2009/2023 {
	
    append using "data_`year'_couples_in_rows.dta"
	
}

* Trend dummies

gen t  = year - 2007
gen t2 = t * t
gen t3 = t2 * t

* Year duumies

foreach yr of numlist 2008/2023 {
    gen year_`yr' = (year == `yr')
}

* Creando variable de ingreso del hogar distinto de salarios de los cónyuges

gen other_hhincome   = hh_income - earnings_w - earnings_m

drop if other_hhincome <= 0

save "panel_full.dta", replace

* Deflating hwage and nincome

import excel "raw/CPI.xls", clear

ren A year
ren B CPI

destring year, replace
replace  CPI = CPI/100

save "CPI.dta", replace

use "panel_full.dta", clear

merge m:1 year using "CPI.dta"

drop _merge

replace hwage_w        = hwage_w        / CPI
replace hwage_m        = hwage_m        / CPI
replace earnings_w     = earnings_w     / CPI
replace earnings_m     = earnings_m     / CPI
replace wage_w         = wage_w         / CPI
replace wage_m         = wage_m         / CPI
replace hh_income      = hh_income      / CPI
replace other_hhincome = other_hhincome / CPI

drop CPI

gen l_hwage_w        = log(hwage_w)
gen l_hwage_m        = log(hwage_m)
gen l_earnings_w     = log(earnings_w)
gen l_earnings_m     = log(earnings_m)
gen l_wage_w         = log(wage_w)
gen l_wage_m         = log(wage_m)
gen l_hh_income      = log(hh_income)
gen l_other_hhincome = log(other_hhincome)

save "panel_full.dta", replace

* Mantener parejas para los que se observa salario para ambos

drop if (hwage_w == 0 | hwage_w == .)
drop if (hwage_m == 0 | hwage_m == .)

gen gap_hwage    = l_hwage_m - l_hwage_w
gen gap_earnings = l_earnings_m - l_earnings_w
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

drop if l_hwage_m        <= 0
drop if l_hwage_w        <= 0
drop if l_hh_income      <= 0
drop if l_earnings_w     <= 0
drop if l_earnings_m     <= 0
drop if l_other_hhincome <= 0

* Creando variable dummy de hijos

gen has_ch = 0
replace has_ch = 1 if children_w >= 1 | children_m >= 1

* Creando dummy de cónyuges nacidos en países distintos

gen     diff_born = 1
replace diff_born = 0 if (spanish_born_w == spanish_born_m) & ///
		(eu_born_w == eu_born_m) & (foreigner_born_w == foreigner_born_m)

* Creando cuadrado de experiencia y diferencia de experiencia

gen exper_w_sq     = exper_w^2
gen exper_m_sq     = exper_m^2
gen exper_diff     = exper_m - exper_w
gen abs_exper_diff = abs(exper_diff)

* Creando dummy de cónyuges con distina ocupación

gen     occup_diff = 1
replace occup_diff = 0 if occupation_w == occupation_m

* Creando dummy de cónyuges con distino sector de trabajo

gen     sector_diff = 1
replace sector_diff = 0 if work_sector_w == work_sector_m

* Creando dummy de cónyuges con distino contrato laboral

gen     part_time_diff = 1
replace part_time_diff = 0 if part_time_m == part_time_w

* Creando dummy de cónyuges que son distintos tipos de trabajadores

gen     fixed_worker_diff = 1
replace fixed_worker_diff = 0 if fixed_worker_m == fixed_worker_w

* Creando dummy de cónyuges que tienen salud distinta

gen     good_health_diff = 1
replace good_health_diff = 0 if good_health_m == good_health_w

save "panel_double_earner_couples.dta", replace
