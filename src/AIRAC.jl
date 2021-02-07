module AIRAC

export Airac, AiracDiff
import Base: show, zero, parse, isless
# import Base: div, rem
import Base: range
import Base: +, -

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

# function airac_cycle_dates(year)
#   airac_first_cycle_date(year):airac_interval:airac_last_cycle_date(year)
# end

function number_airac_cycles(year)
  length(airac_cycle_dates(year))
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
  t = airac_cycle(Tuple, date)
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

show(io::IO, a::Airac) = print(io, "Airac($(a.ident), $(a.date))")

function airac_cycle_dates(a1::Airac, a2::Airac)
  # ToDo: implement range (a1:AiracDiff():a2 and a1:a2)
  Airac.(a1.date:airac_interval:a2.date)
end

function airac_cycle_dates(year)
  airac_cycle_dates(Airac(airac_first_cycle_date(year)), Airac(airac_last_cycle_date(year)))
end


struct AiracDiff
  value::Int
end
AiracDiff() = AiracDiff(1)

zero(ad::AiracDiff) = AiracDiff(0)
isless(ad1::AiracDiff, ad2::AiracDiff) = isless(ad1.value, ad2.value)

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

function +(a::Airac, ad::AiracDiff)
  Airac(a.date + ad.value * airac_interval)
end

function -(a::Airac, ad::AiracDiff)
  Airac(a.date - ad.value * airac_interval)
end

function -(a1::Airac, a2::Airac)
  days = (a1.date - a2.date).value
  AiracDiff(days ÷ airac_interval.value)
end

function +(ad1::AiracDiff, ad2::AiracDiff)
  AiracDiff(ad1.value + ad2.value)
end

#=
function range(start::Airac, stop::Airac)

end

rem(ad1::AiracDiff, ad2::AiracDiff) = AiracDiff(rem(ad1.value, ad2.value))

function div(ad1::AiracDiff, ad2::AiracDiff, rounding_mode)
  AiracDiff(div(ad1.value, ad2.value, rounding_mode))
end
=#

function isless(airac1::Airac, airac2::Airac)
  isless(airac1.date, airac2.date)
end

end
