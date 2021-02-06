# AIRAC

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://scls19fr.github.io/AIRAC.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://scls19fr.github.io/AIRAC.jl/dev)
[![Build Status](https://travis-ci.com/scls19fr/AIRAC.jl.svg?branch=master)](https://travis-ci.com/scls19fr/AIRAC.jl)
[![Coverage](https://codecov.io/gh/scls19fr/AIRAC.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/scls19fr/AIRAC.jl)

Regular, planned Aeronautical Information Publications (AIP) as defined by the International Civil Aviation Organization (ICAO) are published and become effective at fixed dates.

AIRAC cycle definition as published in the [ICAO Aeronautical Information Services Manual (DOC 8126; AN/872; 6th Edition; 2003)](https://www.icao.int/NACC/Documents/Meetings/2014/ECARAIM/REF09-Doc8126.pdf). Test cases validate documented dates from 2003 until 2022. They also assert that the rare cases of a 14th cycle, e. g. in the years 2020 and 2043 are correctly handled.

https://en.wikipedia.org/wiki/Aeronautical_Information_Publication

This project provides a Julia library to deal with AIRAC cycle dates.

This project is not maintained by ICAO. Please use this project at your own risk.

## Installation

[AIRAC.jl](https://github.com/scls19fr/AIRAC.jl) is not currently a [Julia registered package](https://juliapackages.com/).

Currently only developer version is available. It can be installed by running Julia REPL:

```bash
$ julia
julia> ]
(@v1.5) pkg> dev https://github.com/scls19fr/AIRAC.jl
```

## Usage

### Airac struct

#### Get current AIRAC cycle
```julia
julia> using AIRAC

julia> airac = Airac()
Airac(2101, 2021-01-28)
```

#### Get first AIRAC cycle of a given year

```julia
julia> Airac(2021)
Airac(2101, 2021-01-28)
```

#### Get properties of an AIRAC cycle

```julia
julia> airac.date
2021-01-28

julia> airac.ident
2101

julia> airac.year
2021
```

### Iterating over AIRAC cycle
```julia
julia> using AIRAC: next, previous

julia> airac = Airac(2021)

julia> next(airac)
Airac(2102, 2021-02-25)

julia> previous(airac)
Airac(2014, 2020-12-31)
```

### Showing all cycle dates of a given year

```julia
julia> using AIRAC: airac_cycle_dates

julia> Airac.(airac_cycle_dates(2021))
13-element Array{Airac,1}:
 Airac(2101, 2021-01-28)
 Airac(2102, 2021-02-25)
 Airac(2103, 2021-03-25)
 Airac(2104, 2021-04-22)
 Airac(2105, 2021-05-20)
 Airac(2106, 2021-06-17)
 Airac(2107, 2021-07-15)
 Airac(2108, 2021-08-12)
 Airac(2109, 2021-09-09)
 Airac(2110, 2021-10-07)
 Airac(2111, 2021-11-04)
 Airac(2112, 2021-12-02)
 Airac(2113, 2021-12-30)
```

### More informations

More informations can be found by watching at code:

- [code](src/AIRAC.jl)
- [test](test/runtests.jl)
