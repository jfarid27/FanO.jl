using FanO.Cards;

@testset "Cards" begin

  @testset "Promotion" begin
    @testset "From existing commander" begin
      @test isa(Cards.promote(Jack()), Queen)

      @test isa(Cards.promote(King()), Winning)
    end
  end

  @testset "Prestige" begin
    @testset "Maneuver should work" begin
      first = Card(Hearts(), Five());
      second = Card(Hearts(), Four());
      prestige = Card(Hearts(), Nine());
      @test isValidPrestigeIncrease(first, second, prestige);
      @test !isValidPrestigeIncrease(first, second, Card(Hearts(), Ten()));
    end

  end

  @testset "Fano plane" begin
    @testset "Valid attacks" begin
      @test isValidAttack(Three(), Five(), Two());
      @test isValidAttack(Card(Hearts(), Three()), Card(Hearts(),Five()), Card(Spades(), Two()));
    end
    @testset "Invalid attacks" begin
      @test !isValidAttack(Card(Spades(), Three()), Card(Hearts(),Five()), Card(Spades(), Two()));
    end
  end

end

