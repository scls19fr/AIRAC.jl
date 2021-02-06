using AIRAC
using AIRAC: airac_date
using AIRAC: airac_first_cycle_date, airac_last_cycle_date
using AIRAC: number_airac_cycles, airac_cycle_dates
using AIRAC: airac_cycle
using AIRAC: AiracDiff

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
        @test collect(airac_cycle_dates(2020)) == [
            Date("2020-01-02"), Date("2020-01-30"), Date("2020-02-27"),
            Date("2020-03-26"), Date("2020-04-23"), Date("2020-05-21"),
            Date("2020-06-18"), Date("2020-07-16"), Date("2020-08-13"),
            Date("2020-09-10"), Date("2020-10-08"), Date("2020-11-05"),
            Date("2020-12-03"), Date("2020-12-31")  
        ]
    end

    @testset "airac_number_of_cycles" begin
        exceptions = [2020, 2043]
        for year in 2003:2050
            n = number_airac_cycles(year)
            if !(year in exceptions)
                @test n == 13
            else
                @test n == 14
            end
        end
    end

    @testset "airac_cycle" begin
        @test airac_cycle(Tuple, Date(2020, 1, 30)) == (2020, 2)
        @test airac_cycle(2020, 2) == 2002
        @test airac_cycle(Int, Date(2020, 1, 30)) == 2002
    end

    @testset "Airac struct" begin
        airac = Airac(Date(2020, 1, 10))
        @test airac.date == Date(2020, 1, 2)

        year = 2020
        airac = Airac(year)
        @test airac.date == Date(2020, 1, 2)
        @test airac.year == 2020
        @test airac.cycle == 1
        @test airac.ident == 2001

        airac = airac + AiracDiff()
        @test airac.date == Date(2020, 1, 30)
        @test airac.year == 2020
        @test airac.cycle == 2
        @test airac.ident == 2002

        airac = airac - AiracDiff(2)
        @test airac.date == Date(2019, 12, 5)
        @test airac.year == 2019
        @test airac.cycle == 13
        @test airac.ident == 1913
    end

    @testset "Airac string representation" begin
        @test string(Airac(2021)) == "Airac(2101, 2021-01-28)"
    end


    @testset "parse Airac ident" begin
        @test parse(Airac, "1913").date == Date(2019, 12, 5)
        @test parse(Airac, "2001").date == Date(2020, 1, 2)
        @test parse(Airac, "2002").date == Date(2020, 1, 30)
        @test parse(Airac, "2014").date == Date(2020, 12, 31)

        @test_throws ArgumentError parse(Airac, "2115")
    end

    @testset "Airac comparison" begin
        @test Airac() == Airac()
        @test Airac() + AiracDiff() > Airac()
        @test Airac() - AiracDiff() < Airac()
    end

    @testset "Airac range" begin
        a1 = Airac(2018)
        a2 = Airac(2023) - AiracDiff()
        # ToFix
        # r = a1:AiracDiff():a2
        # r = a1:a2
    end
end
