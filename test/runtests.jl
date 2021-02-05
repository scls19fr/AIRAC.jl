using AIRAC
using AIRAC: airac_date
using AIRAC: airac_first_cycle_date, airac_last_cycle_date, airac_cycle_dates
using AIRAC: next, previous

using Test
using Dates

@testset "AIRAC.jl" begin
    @testset "airac_date" begin
        @test airac_date(Date(2020, 1, 15)) == Date(2020, 1, 2)
        @test airac_date(Date(2021, 2, 5)) == Date(2021, 1, 28)
    end

    @testset "airac_first_cycle_date" begin
        first_day = [(2003, 23), (2004, 22), (2005, 20),
            (2006, 19), (2007, 18), (2008, 17), (2009, 15), (2010, 14), 
            (2011, 13), (2012, 12), (2013, 10), (2014, 9), (2015, 8),
            (2016, 7), (2017, 5), (2018, 4), (2019, 3), (2020, 2),
            (2021, 28), (2022, 27)]
        for (year, day) in first_day
            @test airac_first_cycle_date(year) == Date(year, 1, day)
        end
    end

    @testset "airac_last_cycle_date" begin
        last_day = [(2003, 25), (2004, 23), (2005, 22),
            (2019, 5), (2020, 31),
            (2021, 30), (2022, 29)]
        for (year, day) in last_day
            @test airac_last_cycle_date(year) == Date(year, 12, day)
        end
    end

    @testset "airac_number_of_cycles" begin
        exceptions = [2020, 2043]
        for year in 2003:2050
            n = length(airac_cycle_dates(year))
            if !(year in exceptions)
                @test n == 13
            else
                @test n == 14
            end
        end
    end

    @testset "Airac struct" begin
        year = 2020
        airac = Airac(year)
        @test airac.date == Date(2020, 1, 2)
        @test airac.year == 2020
        @test airac.cycle == 1
        @test airac.ident == 2001

        airac = next(airac)
        @test airac.date == Date(2020, 1, 30)
        @test airac.year == 2020
        @test airac.cycle == 2
        @test airac.ident == 2002

        airac = previous(airac)
        airac = previous(airac)
        @test airac.date == Date(2019, 12, 5)
        @test airac.year == 2019
        @test airac.cycle == 13
        @test airac.ident == 1913
    end

    @testset "parse Airac ident" begin
        @test parse(Airac, "1913").date == Date(2019, 12, 5)
        @test parse(Airac, "2001").date == Date(2020, 1, 2)
        @test parse(Airac, "2002").date == Date(2020, 1, 30)
        @test parse(Airac, "2014").date == Date(2020, 12, 31)

        @test_throws ArgumentError parse(Airac, "2115")
    end

end