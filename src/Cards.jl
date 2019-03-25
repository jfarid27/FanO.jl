module Cards

  export Card

  export Suit, Hearts, Spades, Diamonds, Clovers
  export FaceValue, Combat, Ace, Two, Three, Four, Five, Six, Seven
  export Prestige, Eight, Nine, Ten
  export Commander, Jack, Queen, King, Winning

  export promote

  export fanoPlane

  export isValidAttack
  export isValidPrestigeIncrease

  abstract type Suit end;
  struct Hearts <: Suit end;
  struct Spades <: Suit end;
  struct Diamonds <: Suit end;
  struct Clovers <: Suit end;

  abstract type FaceValue end;

  abstract type Combat <: FaceValue end;
  struct Ace <: Combat end;
  struct Two <: Combat end;
  struct Three <: Combat end;
  struct Four <: Combat end;
  struct Five <: Combat end;
  struct Six <: Combat end;
  struct Seven <: Combat end;

  abstract type Prestige <: FaceValue end;
  struct Eight <: Prestige end;
  struct Nine <: Prestige end;
  struct Ten <: Prestige end;

  abstract type Commander <: FaceValue end;
  struct Jack <: Commander end;
  struct Queen <: Commander end;
  struct King <: Commander end;
  struct Winning <: Commander end;

  struct Card{S<:Suit, V<:FaceValue}
    suit::S
    value::V
  end

  function promote(x::Commander)  
    if isa(x, Jack)
      return Queen();
    elseif isa(x, Queen)
      return King();
    else
      return Winning();
    end
  end

  prestigeVals = [
    (Ace, Seven) => Eight(),
    (Seven, Ace) => Eight(),
    (Two, Six) => Eight(),
    (Six, Two) => Eight(),
    (Three, Five) => Eight(),
    (Five, Three) => Eight(),
    (Four, Four) => Eight(),

    (Seven, Two) => Nine(),
    (Two, Seven) => Nine(),
    (Three, Six) => Nine(),
    (Six, Three) => Nine(),
    (Four, Five) => Nine(),
    (Five, Four) => Nine(),

    (Four, Six) => Ten(),
    (Six, Four) => Ten(),
    (Five, Five) => Ten()
  ]

  fanoPlaneVals = [
    Four => Five(),
    Five => Seven(),
    Seven => Two(),
    Two => Six(),
    Six => Three(),
    Three => Four(),
    Three => Five(),
    Five => Two(),
    Two => Three(),
    Four => Ace(),
    Ace => Two(),
    Seven => Ace(),
    Ace() => Three(),
    Six => Ace(),
    Ace() => Five
  ];

  fanoPlane = foldl(Base.ImmutableDict, fanoPlaneVals[2:end], init=Base.ImmutableDict(fanoPlaneVals[1]))
  prestigeSums = foldl(Base.ImmutableDict, prestigeVals[2:end], init=Base.ImmutableDict(prestigeVals[1]))

  function isSameSuit(c::Card, d::Card)
    return isa(c.suit, typeof(d.suit))
  end

  function isSameFaceValue(c::FaceValue, d::FaceValue)
    return isa(c, typeof(d))
  end

  function isValidAttack(first::Combat, second::Combat, attacking::Combat)
    mid = get(fanoPlane, typeof(first), false);
    if isSameFaceValue(mid, second)
      return isSameFaceValue(get(fanoPlane, typeof(second), false), attacking);
    end
    return false;
  end 

  function isValidAttack(init::Card, help::Card, victim::Card)
    if !isSameSuit(init, help) || isSameSuit(init, victim)
      return false;
    end
    return isValidAttack(init.value, help.value, victim.value)
  end 

  function isValidPrestigeIncrease(init::Card, help::Card, prestige::Card)
    if !(isSameSuit(init, help) && isSameSuit(help, prestige))
      return false;
    end
    return isValidPrestigeIncrease(init.value, help.value, prestige.value);
  end

  function isValidPrestigeIncrease(first::Combat, second::Combat, prestige::Prestige)
    mid = get(prestigeSums, (typeof(first), typeof(second)), false);
    return isSameFaceValue(mid, prestige);
  end
end
