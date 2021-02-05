module AIRAC

export Airac

using Dates

const airac_delay = Dict(
  :publication_date_major_changes => Day(56),
  :publication_date_normal => Day(42),
  :latest_delivery_date => Day(28),
  :cut_off_date => Day(20),
  :fms_data_production => Day(15),
  :delivery_to_operator => Day(7)
)

const airac_interval = Day(28)
const airac_initial_date = Date(2015, 1, 8)

function airac_date(date::Date = today())
  if date >= airac_initial_date
    diff_cycle = (date - airac_initial_date) ÷ airac_interval
  else
    diff_cycle = -((airac_initial_date - date) ÷ airac_interval + 1)
  end
  airac_initial_date + diff_cycle * airac_interval
end

function airac_first_cycle_date(year)
  airac_date(Date(year -1, 12, 31)) + airac_interval
end

function airac_last_cycle_date(year)
  airac_date(Date(year, 12, 31))
end

function airac_cycle_dates(year)
  airac_first_cycle_date(year):airac_interval:airac_last_cycle_date(year)
end

function airac_cycle(::Type{Tuple}, date::Date = today())
  date = airac_date(date)
  airac_year = year(date)
  cycle = (date - airac_first_cycle_date(airac_year)) ÷ airac_interval + 1
  (airac_year, cycle)
end

function airac_cycle(year::Int, cycle::Int)
  (year - 2000) * 100 + cycle
end

function airac_cycle(::Type{Int}, date::Date = today())
  t = airac_cycle(date, Tuple)
  airac_cycle(t[1], t[2])
end

struct Airac
  date::Date
  year::Int
  cycle::Int
  ident::Int

  function Airac(date::Date = today())
    date = airac_date(date)
    airac_year, cycle = airac_cycle(Tuple, date)
    ident = airac_cycle(airac_year, cycle)
    new(date, airac_year, cycle, ident)
  end
end

function Airac(year)
  Airac(airac_first_cycle_date(year))
end

import Base: parse

function parse(::Type{Airac}, ident::Int)
  cycle = ident % 100
  airac_year = 2000 + ident ÷ 100
  date = airac_first_cycle_date(airac_year) + (cycle - 1) * airac_interval
  if year(date) != airac_year
    throw(ArgumentError("can't parse Airac ident $ident"))
  end
  Airac(date)
end

function parse(::Type{Airac}, s::String)
  ident = parse(Int, s)
  parse(Airac, ident)
end

function move(airac::Airac, cycles_number)
  Airac(airac.date + cycles_number * airac_interval)
end

function next(airac::Airac)
  move(airac, 1)
end

function previous(airac::Airac)
  move(airac, -1)
end

end
