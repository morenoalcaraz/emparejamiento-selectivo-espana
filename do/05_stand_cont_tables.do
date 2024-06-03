// -------------------------------------------------------------------------- //
// Archivo do: 05_stand_cont_tables.do
// Descripción: Estandariza las tablas de contingencia.
//
// Autor: Carmen Moreno
// Fecha: April 2024
// -------------------------------------------------------------------------- //

clear all
capture log close
set more off
cd "/Users/carmenmoreno/Library/CloudStorage/Dropbox/TFG/Stata/ECV"

*------------------------------------------------------------------------------*
**# EMPAREJAIENTO SELECTIVO
*------------------------------------------------------------------------------*

**# Medida 1 estandarizada -----------------------------------------------------

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

quietly foreach yr of numlist 1/16 {
	matrix matrix_`yr' = J(3,3,.)
}

tabstat share*, by(year) save

quietly foreach yr of numlist 1/16 {
	
	matrix matrix_`yr'[1,1] = r(Stat`yr')[1,1]
	matrix matrix_`yr'[1,2] = r(Stat`yr')[1,2]
	matrix matrix_`yr'[1,3] = r(Stat`yr')[1,3]
	matrix matrix_`yr'[2,1] = r(Stat`yr')[1,4]
	matrix matrix_`yr'[2,2] = r(Stat`yr')[1,5]
	matrix matrix_`yr'[2,3] = r(Stat`yr')[1,6]
	matrix matrix_`yr'[3,1] = r(Stat`yr')[1,7]
	matrix matrix_`yr'[3,2] = r(Stat`yr')[1,8]
	matrix matrix_`yr'[3,3] = r(Stat`yr')[1,9]

}

* Definir matrices auxiliares

matrix rows_ones        = J(1,3,1)
matrix cols_ones        = J(3,1,1)
matrix row_wanted_distr = J(3,1,0.3333)
matrix col_wanted_distr = J(1,3,0.3333)

* Normalizar filas y columnas

local tol = 0.01
local max_dev = 1

* Definir matrices auxiliares

matrix rows_ones        = J(1,3,1)
matrix cols_ones        = J(3,1,1)
matrix row_wanted_distr = J(3,1,0.3333)
matrix col_wanted_distr = J(1,3,0.3333)

* Normalizar filas y columnas para 2008

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_1 * J(colsof(matrix_1), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_1", st_matrix("matrix_1") :/ st_matrix("row_sums"))

	matrix matrix_1 = matrix_1 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_1), 1) * matrix_1
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_1", st_matrix("matrix_1") :/ st_matrix("col_sums"))

	matrix matrix_1 = matrix_1 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_1 * J(colsof(matrix_1), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_1), 1) * matrix_1

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

matrix list matrix_1

* Normalizar filas y columnas para 2009

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_2 * J(colsof(matrix_2), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_2", st_matrix("matrix_2") :/ st_matrix("row_sums"))

	matrix matrix_2 = matrix_2 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_2), 1) * matrix_2
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_2", st_matrix("matrix_2") :/ st_matrix("col_sums"))

	matrix matrix_2 = matrix_2 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_2 * J(colsof(matrix_2), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_2), 1) * matrix_2

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2010

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_3 * J(colsof(matrix_3), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_3", st_matrix("matrix_3") :/ st_matrix("row_sums"))

	matrix matrix_3 = matrix_3 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_3), 1) * matrix_3
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_3", st_matrix("matrix_3") :/ st_matrix("col_sums"))

	matrix matrix_3 = matrix_3 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_3 * J(colsof(matrix_3), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_3), 1) * matrix_3

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2011

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_4 * J(colsof(matrix_4), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_4", st_matrix("matrix_4") :/ st_matrix("row_sums"))

	matrix matrix_4 = matrix_4 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_4), 1) * matrix_4
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_4", st_matrix("matrix_4") :/ st_matrix("col_sums"))

	matrix matrix_4 = matrix_4 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_4 * J(colsof(matrix_4), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_4), 1) * matrix_4

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2012

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_5 * J(colsof(matrix_5), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_5", st_matrix("matrix_5") :/ st_matrix("row_sums"))

	matrix matrix_5 = matrix_5 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_5), 1) * matrix_5
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_5", st_matrix("matrix_5") :/ st_matrix("col_sums"))

	matrix matrix_5 = matrix_5 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_5 * J(colsof(matrix_5), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_5), 1) * matrix_5

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2013

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_6 * J(colsof(matrix_6), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_6", st_matrix("matrix_6") :/ st_matrix("row_sums"))

	matrix matrix_6 = matrix_6 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_6), 1) * matrix_6
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_6", st_matrix("matrix_6") :/ st_matrix("col_sums"))

	matrix matrix_6 = matrix_6 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_6 * J(colsof(matrix_6), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_6), 1) * matrix_6

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2014

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_7 * J(colsof(matrix_7), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_7", st_matrix("matrix_7") :/ st_matrix("row_sums"))

	matrix matrix_7 = matrix_7 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_7), 1) * matrix_7
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_7", st_matrix("matrix_7") :/ st_matrix("col_sums"))

	matrix matrix_7 = matrix_7 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_7 * J(colsof(matrix_7), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_7), 1) * matrix_7

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2015

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_8 * J(colsof(matrix_8), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_8", st_matrix("matrix_8") :/ st_matrix("row_sums"))

	matrix matrix_8 = matrix_8 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_8), 1) * matrix_8
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_8", st_matrix("matrix_8") :/ st_matrix("col_sums"))

	matrix matrix_8 = matrix_8 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_8 * J(colsof(matrix_8), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_8), 1) * matrix_8

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2016

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_9 * J(colsof(matrix_9), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_9", st_matrix("matrix_9") :/ st_matrix("row_sums"))

	matrix matrix_9 = matrix_9 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_9), 1) * matrix_9
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_9", st_matrix("matrix_9") :/ st_matrix("col_sums"))

	matrix matrix_9 = matrix_9 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_9 * J(colsof(matrix_9), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_9), 1) * matrix_9

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2017

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_10 * J(colsof(matrix_10), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_10", st_matrix("matrix_10") :/ st_matrix("row_sums"))

	matrix matrix_10 = matrix_10 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_10), 1) * matrix_10
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_10", st_matrix("matrix_10") :/ st_matrix("col_sums"))

	matrix matrix_10 = matrix_10 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_10 * J(colsof(matrix_10), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_10), 1) * matrix_10

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2018

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_11 * J(colsof(matrix_11), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_11", st_matrix("matrix_11") :/ st_matrix("row_sums"))

	matrix matrix_11 = matrix_11 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_11), 1) * matrix_11
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_11", st_matrix("matrix_11") :/ st_matrix("col_sums"))

	matrix matrix_11 = matrix_11 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_11 * J(colsof(matrix_11), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_11), 1) * matrix_11

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2019

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_12 * J(colsof(matrix_12), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_12", st_matrix("matrix_12") :/ st_matrix("row_sums"))

	matrix matrix_12 = matrix_12 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_12), 1) * matrix_12
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_12", st_matrix("matrix_12") :/ st_matrix("col_sums"))

	matrix matrix_12 = matrix_12 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_12 * J(colsof(matrix_12), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_12), 1) * matrix_12

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2020

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_13 * J(colsof(matrix_13), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_13", st_matrix("matrix_13") :/ st_matrix("row_sums"))

	matrix matrix_13 = matrix_13 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_13), 1) * matrix_13
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_13", st_matrix("matrix_13") :/ st_matrix("col_sums"))

	matrix matrix_13 = matrix_13 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_13 * J(colsof(matrix_13), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_13), 1) * matrix_13

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2021

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_14 * J(colsof(matrix_14), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_14", st_matrix("matrix_14") :/ st_matrix("row_sums"))

	matrix matrix_14 = matrix_14 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_14), 1) * matrix_14
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_14", st_matrix("matrix_14") :/ st_matrix("col_sums"))

	matrix matrix_14 = matrix_14 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_14 * J(colsof(matrix_14), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_14), 1) * matrix_14

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2022

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_15 * J(colsof(matrix_15), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_15", st_matrix("matrix_15") :/ st_matrix("row_sums"))

	matrix matrix_15 = matrix_15 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_15), 1) * matrix_15
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_15", st_matrix("matrix_15") :/ st_matrix("col_sums"))

	matrix matrix_15 = matrix_15 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_15 * J(colsof(matrix_15), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_15), 1) * matrix_15

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2023

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_16 * J(colsof(matrix_16), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_16", st_matrix("matrix_16") :/ st_matrix("row_sums"))

	matrix matrix_16 = matrix_16 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_16), 1) * matrix_16
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_16", st_matrix("matrix_16") :/ st_matrix("col_sums"))

	matrix matrix_16 = matrix_16 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_16 * J(colsof(matrix_16), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_16), 1) * matrix_16

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

matrix list matrix_16

gen stand_ass1 = matrix_1[1,1] + matrix_1[2,2] + matrix_1[3,3]

quietly foreach yr of numlist 2/16 {
	
	replace stand_ass1 = matrix_`yr'[1,1] + matrix_`yr'[2,2] + ///
						 matrix_`yr'[3,3] if t == `yr'
}

gen random = 0

save "data/temp/aux_ass1.dta", replace

*------------------------------------------------------------------------------*
**# EMPAREJAIENTO ALEATORIO
*------------------------------------------------------------------------------*

**# Medida 1 estandarizada -----------------------------------------------------

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

quietly foreach yr of numlist 1/16 {
	matrix matrix_`yr' = J(3,3,.)
}

tabstat share*, by(year) save

quietly foreach yr of numlist 1/16 {
	
	matrix matrix_`yr'[1,1] = r(Stat`yr')[1,1]
	matrix matrix_`yr'[1,2] = r(Stat`yr')[1,2]
	matrix matrix_`yr'[1,3] = r(Stat`yr')[1,3]
	matrix matrix_`yr'[2,1] = r(Stat`yr')[1,4]
	matrix matrix_`yr'[2,2] = r(Stat`yr')[1,5]
	matrix matrix_`yr'[2,3] = r(Stat`yr')[1,6]
	matrix matrix_`yr'[3,1] = r(Stat`yr')[1,7]
	matrix matrix_`yr'[3,2] = r(Stat`yr')[1,8]
	matrix matrix_`yr'[3,3] = r(Stat`yr')[1,9]

}

* Definir matrices auxiliares

matrix rows_ones        = J(1,3,1)
matrix cols_ones        = J(3,1,1)
matrix row_wanted_distr = J(3,1,0.3333)
matrix col_wanted_distr = J(1,3,0.3333)

* Normalizar filas y columnas

local tol = 0.01
local max_dev = 1

* Definir matrices auxiliares

matrix rows_ones        = J(1,3,1)
matrix cols_ones        = J(3,1,1)
matrix row_wanted_distr = J(3,1,0.3333)
matrix col_wanted_distr = J(1,3,0.3333)

* Normalizar filas y columnas para 2008

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_1 * J(colsof(matrix_1), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_1", st_matrix("matrix_1") :/ st_matrix("row_sums"))

	matrix matrix_1 = matrix_1 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_1), 1) * matrix_1
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_1", st_matrix("matrix_1") :/ st_matrix("col_sums"))

	matrix matrix_1 = matrix_1 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_1 * J(colsof(matrix_1), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_1), 1) * matrix_1

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

matrix list matrix_1

* Normalizar filas y columnas para 2009

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_2 * J(colsof(matrix_2), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_2", st_matrix("matrix_2") :/ st_matrix("row_sums"))

	matrix matrix_2 = matrix_2 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_2), 1) * matrix_2
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_2", st_matrix("matrix_2") :/ st_matrix("col_sums"))

	matrix matrix_2 = matrix_2 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_2 * J(colsof(matrix_2), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_2), 1) * matrix_2

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2010

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_3 * J(colsof(matrix_3), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_3", st_matrix("matrix_3") :/ st_matrix("row_sums"))

	matrix matrix_3 = matrix_3 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_3), 1) * matrix_3
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_3", st_matrix("matrix_3") :/ st_matrix("col_sums"))

	matrix matrix_3 = matrix_3 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_3 * J(colsof(matrix_3), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_3), 1) * matrix_3

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2011

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_4 * J(colsof(matrix_4), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_4", st_matrix("matrix_4") :/ st_matrix("row_sums"))

	matrix matrix_4 = matrix_4 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_4), 1) * matrix_4
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_4", st_matrix("matrix_4") :/ st_matrix("col_sums"))

	matrix matrix_4 = matrix_4 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_4 * J(colsof(matrix_4), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_4), 1) * matrix_4

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2012

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_5 * J(colsof(matrix_5), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_5", st_matrix("matrix_5") :/ st_matrix("row_sums"))

	matrix matrix_5 = matrix_5 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_5), 1) * matrix_5
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_5", st_matrix("matrix_5") :/ st_matrix("col_sums"))

	matrix matrix_5 = matrix_5 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_5 * J(colsof(matrix_5), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_5), 1) * matrix_5

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2013

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_6 * J(colsof(matrix_6), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_6", st_matrix("matrix_6") :/ st_matrix("row_sums"))

	matrix matrix_6 = matrix_6 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_6), 1) * matrix_6
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_6", st_matrix("matrix_6") :/ st_matrix("col_sums"))

	matrix matrix_6 = matrix_6 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_6 * J(colsof(matrix_6), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_6), 1) * matrix_6

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2014

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_7 * J(colsof(matrix_7), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_7", st_matrix("matrix_7") :/ st_matrix("row_sums"))

	matrix matrix_7 = matrix_7 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_7), 1) * matrix_7
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_7", st_matrix("matrix_7") :/ st_matrix("col_sums"))

	matrix matrix_7 = matrix_7 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_7 * J(colsof(matrix_7), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_7), 1) * matrix_7

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2015

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_8 * J(colsof(matrix_8), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_8", st_matrix("matrix_8") :/ st_matrix("row_sums"))

	matrix matrix_8 = matrix_8 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_8), 1) * matrix_8
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_8", st_matrix("matrix_8") :/ st_matrix("col_sums"))

	matrix matrix_8 = matrix_8 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_8 * J(colsof(matrix_8), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_8), 1) * matrix_8

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2016

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_9 * J(colsof(matrix_9), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_9", st_matrix("matrix_9") :/ st_matrix("row_sums"))

	matrix matrix_9 = matrix_9 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_9), 1) * matrix_9
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_9", st_matrix("matrix_9") :/ st_matrix("col_sums"))

	matrix matrix_9 = matrix_9 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_9 * J(colsof(matrix_9), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_9), 1) * matrix_9

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2017

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_10 * J(colsof(matrix_10), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_10", st_matrix("matrix_10") :/ st_matrix("row_sums"))

	matrix matrix_10 = matrix_10 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_10), 1) * matrix_10
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_10", st_matrix("matrix_10") :/ st_matrix("col_sums"))

	matrix matrix_10 = matrix_10 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_10 * J(colsof(matrix_10), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_10), 1) * matrix_10

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2018

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_11 * J(colsof(matrix_11), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_11", st_matrix("matrix_11") :/ st_matrix("row_sums"))

	matrix matrix_11 = matrix_11 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_11), 1) * matrix_11
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_11", st_matrix("matrix_11") :/ st_matrix("col_sums"))

	matrix matrix_11 = matrix_11 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_11 * J(colsof(matrix_11), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_11), 1) * matrix_11

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2019

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_12 * J(colsof(matrix_12), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_12", st_matrix("matrix_12") :/ st_matrix("row_sums"))

	matrix matrix_12 = matrix_12 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_12), 1) * matrix_12
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_12", st_matrix("matrix_12") :/ st_matrix("col_sums"))

	matrix matrix_12 = matrix_12 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_12 * J(colsof(matrix_12), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_12), 1) * matrix_12

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2020

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_13 * J(colsof(matrix_13), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_13", st_matrix("matrix_13") :/ st_matrix("row_sums"))

	matrix matrix_13 = matrix_13 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_13), 1) * matrix_13
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_13", st_matrix("matrix_13") :/ st_matrix("col_sums"))

	matrix matrix_13 = matrix_13 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_13 * J(colsof(matrix_13), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_13), 1) * matrix_13

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2021

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_14 * J(colsof(matrix_14), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_14", st_matrix("matrix_14") :/ st_matrix("row_sums"))

	matrix matrix_14 = matrix_14 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_14), 1) * matrix_14
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_14", st_matrix("matrix_14") :/ st_matrix("col_sums"))

	matrix matrix_14 = matrix_14 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_14 * J(colsof(matrix_14), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_14), 1) * matrix_14

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2022

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_15 * J(colsof(matrix_15), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_15", st_matrix("matrix_15") :/ st_matrix("row_sums"))

	matrix matrix_15 = matrix_15 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_15), 1) * matrix_15
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_15", st_matrix("matrix_15") :/ st_matrix("col_sums"))

	matrix matrix_15 = matrix_15 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_15 * J(colsof(matrix_15), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_15), 1) * matrix_15

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

* Normalizar filas y columnas para 2023

local tol = 0.01
local max_dev = 1

while `max_dev' > `tol' {
	
    matrix row_sums = matrix_16 * J(colsof(matrix_16), 1, 1)
	matrix row_sums = row_sums * rows_ones

	mata: st_matrix("matrix_16", st_matrix("matrix_16") :/ st_matrix("row_sums"))

	matrix matrix_16 = matrix_16 * 0.3333

	matrix col_sums = J(1, rowsof(matrix_16), 1) * matrix_16
	matrix col_sums = cols_ones * col_sums

	mata: st_matrix("matrix_16", st_matrix("matrix_16") :/ st_matrix("col_sums"))

	matrix matrix_16 = matrix_16 * 0.3333

	* Calcular las desviaciones de las sumas marginales de las filas y columnas

	matrix row_sums = matrix_16 * J(colsof(matrix_16), 1, 1)
	matrix col_sums = J(1, rowsof(matrix_16), 1) * matrix_16

	* Obtener la máxima desviación para las filas y columnas
	matrix row_dev = row_sums - row_wanted_distr
	matrix col_dev = col_sums - col_wanted_distr

	local max_dev = max(abs(row_dev[1,1]), abs(row_dev[2,1]), ///
						 abs(row_dev[3,1]), abs(col_dev[1,1]), ///
						 abs(col_dev[1,2]), abs(col_dev[1,3]))
}

matrix list matrix_16

gen stand_ass1_r = matrix_1[1,1] + matrix_1[2,2] + matrix_1[3,3]

quietly foreach yr of numlist 2/16 {
	
	replace stand_ass1 = matrix_`yr'[1,1] + matrix_`yr'[2,2] + ///
						 matrix_`yr'[3,3] if t == `yr'
}

**# Creando ratio medida 1 -----------------------------------------------------

gen random = 1

append using "data/temp/aux_ass1.dta"

duplicates drop year stand_ass1 stand_ass1_r, force

sort year stand_ass1

order year stand_ass1 stand_ass1_r

gen ratio_ass1 = stand_ass1[_n] / stand_ass1_r[_n+1] ///
	if random == 0

twoway (line ratio_ass1 year if random == 0, lcolor(blue)),        ///
	   graphregion(color(white)) xlabel(2008(2)2023) xtitle("Año") ///
	   ytitle("Ratio de emparejamiento observado y aleatorio")

graph export "graphs/stand_ass1_ratio.pdf", replace
