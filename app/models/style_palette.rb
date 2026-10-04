# Turns a StyleProfile's questionnaire answers into a color palette, using
# plain color-theory rules (undertone + contrast level) rather than AI.
# No API calls, no cost — this is a lookup table.
class StylePalette
  Swatch = Struct.new(:name, :hex, :why, :hexes, keyword_init: true)

  BUCKETS = {
    %w[warm high] => {
      summary: "Warm undertone with high contrast between your hair, skin, and eyes — bold, richly saturated colors and strong dark/light pairings suit you best.",
      lean_toward: [
        Swatch.new(name: "Olive", hex: "#5E6B2F", why: "a warm green that reads sophisticated, not flat"),
        Swatch.new(name: "Rust", hex: "#B7472A", why: "warm and grounded without being loud"),
        Swatch.new(name: "Golden Camel", hex: "#B98B57", why: "the classic warm neutral that flatters warm skin"),
        Swatch.new(name: "Deep Chocolate", hex: "#4A2C21", why: "reads richer on you than plain black"),
        Swatch.new(name: "Burnt Orange", hex: "#C1622D", why: "high-contrast skin can carry a saturated warm color"),
        Swatch.new(name: "Forest Green", hex: "#31502E", why: "deep enough to match your natural contrast"),
        Swatch.new(name: "Burgundy", hex: "#722F37", why: "a rich red that balances warm coloring"),
        Swatch.new(name: "Deep Teal", hex: "#1B5B55", why: "adds saturated contrast without feeling icy")
      ],
      neutrals: [
        Swatch.new(name: "Ivory", hex: "#F5F0E1", why: "Your light neutral. Warmer and softer than stark white."),
        Swatch.new(name: "Black", hex: "#141210", why: "Your dark neutral. Strong contrast, and it works with every color on your list.")
      ],
      neutral_note: "Lean into ivory and black. They give your coloring the strong light-to-dark contrast it can carry. Skip stark white and cool gray, which look harsh next to warm skin.",
      accent_colors: [
        Swatch.new(name: "Marigold", hex: "#D49A24", why: nil),
        Swatch.new(name: "Paprika", hex: "#C94F2D", why: nil),
        Swatch.new(name: "Peacock teal", hex: "#167C78", why: nil),
        Swatch.new(name: "Berry", hex: "#963D52", why: nil)
      ],
      gold_metal_percentage: 100,
      lean_away: [
        Swatch.new(name: "Icy Pastel Blue", hex: "#BFD9E8", why: "fights a warm undertone"),
        Swatch.new(name: "Cool Fuchsia", hex: "#C9469E", why: "too cool against warm skin"),
        Swatch.new(name: "Stark Cool Gray", hex: "#9AA0A6", why: "reads flat next to high contrast"),
        Swatch.new(name: "Icy Lavender", hex: "#D6D2E8", why: "washes out warm coloring")
      ]
    },
    %w[warm soft] => {
      summary: "Warm undertone with softer, closer-in-depth contrast — muted, blended, tonal colors suit you better than stark combinations.",
      lean_toward: [
        Swatch.new(name: "Soft Camel", hex: "#C9A876", why: "warm without demanding attention"),
        Swatch.new(name: "Warm Sand", hex: "#D6BE9C", why: "close enough in depth to blend, not clash"),
        Swatch.new(name: "Muted Olive", hex: "#7C7A4E", why: "a softer, dustier take on olive"),
        Swatch.new(name: "Dusty Terracotta", hex: "#C08262", why: "warm, but gentler than saturated rust"),
        Swatch.new(name: "Warm Taupe", hex: "#A68A6D", why: "a warm neutral with low contrast"),
        Swatch.new(name: "Honey Gold", hex: "#D6A552", why: "soft warmth, not brassy"),
        Swatch.new(name: "Muted Peach", hex: "#D7A186", why: "a gentle warm accent that blends naturally"),
        Swatch.new(name: "Soft Moss", hex: "#8C8B5A", why: "a quiet green that keeps the palette tonal")
      ],
      neutrals: [
        Swatch.new(name: "Warm ivory", hex: "#F2E9D8", why: "Use it wherever you would reach for white."),
        Swatch.new(name: "Soft chocolate", hex: "#6B4A3A", why: "Does the job black would, without the hard edge.")
      ],
      neutral_note: "Lean into warm ivory and soft chocolate over pure white and black. Your coloring blends, so a jump from black to white overpowers it.",
      accent_colors: [
        Swatch.new(name: "Soft coral", hex: "#D88469", why: nil),
        Swatch.new(name: "Saffron", hex: "#C89A3A", why: nil),
        Swatch.new(name: "Soft teal", hex: "#5F9990", why: nil),
        Swatch.new(name: "Dusty paprika", hex: "#A95843", why: nil)
      ],
      gold_metal_percentage: 100,
      lean_away: [
        Swatch.new(name: "Stark Black + White", hex: "#111111", why: "too much contrast for your natural blend", hexes: [ "#111111", "#FFFFFF" ]),
        Swatch.new(name: "Icy Cool Blue", hex: "#B7D3E0", why: "fights the warm undertone"),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "overwhelms a low-contrast palette", hexes: [ "#39FF14", "#FF2E93", "#00E5FF" ]),
        Swatch.new(name: "Cool Charcoal", hex: "#3B3F44", why: "too stark next to soft coloring")
      ]
    },
    %w[cool high] => {
      summary: "Cool undertone with high contrast — clear, saturated jewel tones and crisp dark/light combinations suit you best.",
      lean_toward: [
        Swatch.new(name: "True Red", hex: "#B0202E", why: "a clean red with no orange in it"),
        Swatch.new(name: "Sapphire Blue", hex: "#0F52BA", why: "cool and saturated enough to match your contrast"),
        Swatch.new(name: "Emerald Green", hex: "#065535", why: "a jewel tone that reads sharp, not muddy"),
        Swatch.new(name: "Charcoal / Black", hex: "#1C1C1C", why: "classic high-contrast neutral"),
        Swatch.new(name: "Fuchsia", hex: "#C71585", why: "bold cool color, well-suited to strong contrast"),
        Swatch.new(name: "Icy White", hex: "#F4F6F7", why: "crisp rather than warm-toned cream"),
        Swatch.new(name: "Royal Purple", hex: "#5B2C83", why: "a clear jewel tone that holds its own"),
        Swatch.new(name: "Cobalt", hex: "#0047AB", why: "a vivid cool blue that suits strong contrast")
      ],
      neutrals: [
        Swatch.new(name: "Pure white", hex: "#FFFFFF", why: "Your light neutral. Crisp, not creamy."),
        Swatch.new(name: "Navy", hex: "#14213D", why: "Your dark neutral. Softer than black and still strong enough for your contrast.")
      ],
      neutral_note: "Lean into pure white and deep navy. Skip cream, beige, and camel, whose yellow undertone fights cool skin.",
      accent_colors: [
        Swatch.new(name: "Raspberry", hex: "#A3134D", why: nil),
        Swatch.new(name: "Blue violet", hex: "#4B3F9B", why: nil),
        Swatch.new(name: "Jade", hex: "#168A78", why: nil),
        Swatch.new(name: "Steel blue", hex: "#4A6FA5", why: nil)
      ],
      gold_metal_percentage: 0,
      lean_away: [
        Swatch.new(name: "Rust / Orange", hex: "#C1622D", why: "too warm for cool undertones"),
        Swatch.new(name: "Golden Camel", hex: "#C19A6B", why: "warm neutral fights cool skin"),
        Swatch.new(name: "Golden Yellow", hex: "#E8B923", why: "reads sallow against cool skin"),
        Swatch.new(name: "Warm Beige", hex: "#D8C3A5", why: "too warm-neutral for you")
      ]
    },
    %w[cool soft] => {
      summary: "Cool undertone with softer contrast — muted, dusty, tonal cool colors suit you better than stark saturated ones.",
      lean_toward: [
        Swatch.new(name: "Powder Blue", hex: "#A9C4D9", why: "cool and gentle, matches soft contrast"),
        Swatch.new(name: "Dusty Rose", hex: "#C08497", why: "a muted cool pink, not a bright one"),
        Swatch.new(name: "Soft Lavender", hex: "#B9A6CC", why: "cool without being harsh"),
        Swatch.new(name: "Slate Gray", hex: "#6E7A82", why: "a blended cool neutral"),
        Swatch.new(name: "Muted Teal", hex: "#4C8C8A", why: "cool, but dialed down from bright jewel tones"),
        Swatch.new(name: "Cool Taupe", hex: "#9C9186", why: "low-contrast cool neutral"),
        Swatch.new(name: "Mauve", hex: "#A77D91", why: "a dusty pink-purple that stays soft"),
        Swatch.new(name: "Eucalyptus", hex: "#78928B", why: "a muted green with a cool cast")
      ],
      neutrals: [
        Swatch.new(name: "Soft white", hex: "#F1F3F4", why: "A gentler light neutral than optic white."),
        Swatch.new(name: "Dove gray", hex: "#A9A9AB", why: "A blended mid-tone neutral that sits quietly next to your colors.")
      ],
      neutral_note: "Lean into soft white and dove gray. Skip black and optic white, which overpower soft coloring, and skip beige and camel.",
      accent_colors: [
        Swatch.new(name: "Periwinkle", hex: "#8998C7", why: nil),
        Swatch.new(name: "Orchid", hex: "#A47AA8", why: nil),
        Swatch.new(name: "Sage mist", hex: "#8FA593", why: nil),
        Swatch.new(name: "Heather", hex: "#9B8AA6", why: nil)
      ],
      gold_metal_percentage: 0,
      lean_away: [
        Swatch.new(name: "Bright Orange", hex: "#D2601A", why: "too warm and too bold"),
        Swatch.new(name: "Golden Yellow", hex: "#E8B923", why: "warm and saturated, fights soft cool coloring"),
        Swatch.new(name: "Warm Camel", hex: "#C19A6B", why: "too warm for cool undertones"),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "too much contrast for a soft palette", hexes: [ "#39FF14", "#FF2E93", "#00E5FF" ])
      ]
    },
    %w[neutral high] => {
      summary: "Neutral undertone with high contrast — colors that aren't strongly warm or cool, worn boldly, suit you best.",
      lean_toward: [
        Swatch.new(name: "Navy", hex: "#1F2A44", why: "a balanced dark that works on neutral skin"),
        Swatch.new(name: "Charcoal", hex: "#333333", why: "strong neutral for high contrast"),
        Swatch.new(name: "Deep Teal", hex: "#1B4B4B", why: "balanced between warm and cool"),
        Swatch.new(name: "Burgundy", hex: "#722F37", why: "reads rich without leaning too warm or cool"),
        Swatch.new(name: "Balanced Olive", hex: "#6B7047", why: "neither strongly warm nor cool"),
        Swatch.new(name: "Greige", hex: "#A99C8B", why: "a gray-camel blend built for neutral undertones"),
        Swatch.new(name: "Jade", hex: "#2E7D6B", why: "a clear green that stays balanced"),
        Swatch.new(name: "Plum", hex: "#713B59", why: "a bold but even-toned jewel color")
      ],
      neutrals: [
        Swatch.new(name: "White", hex: "#FFFFFF", why: "Your light neutral. Neither creamy nor icy."),
        Swatch.new(name: "Black", hex: "#111111", why: "Your dark neutral. Works with every color on your list.")
      ],
      neutral_note: "Lean into clean white and black. Skip very creamy whites and very icy tints, which pull you too far warm or too far cool.",
      accent_colors: [
        Swatch.new(name: "Cranberry", hex: "#9E3B4F", why: nil),
        Swatch.new(name: "Blue spruce", hex: "#3D7774", why: nil),
        Swatch.new(name: "Aubergine", hex: "#583C59", why: nil),
        Swatch.new(name: "Rust", hex: "#A8522E", why: nil)
      ],
      gold_metal_percentage: 50,
      lean_away: [
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "too extreme in either temperature", hexes: [ "#39FF14", "#FF2E93", "#00E5FF" ]),
        Swatch.new(name: "Very Warm Orange", hex: "#D2601A", why: "pushes past your balanced undertone"),
        Swatch.new(name: "Icy Pastel Blue", hex: "#BFD9E8", why: "pushes too far cool"),
        Swatch.new(name: "Overly Warm Gold", hex: "#D4AF37", why: "too warm-leaning for neutral skin")
      ]
    },
    %w[neutral soft] => {
      summary: "Neutral undertone with softer contrast — muted, blended tones that aren't strongly warm or cool suit you best.",
      lean_toward: [
        Swatch.new(name: "Soft Navy", hex: "#39496B", why: "balanced and gentle"),
        Swatch.new(name: "Dusty Teal", hex: "#5C8A89", why: "neither warm nor cool, softened"),
        Swatch.new(name: "Mushroom", hex: "#B2A296", why: "a muted neutral built for soft contrast"),
        Swatch.new(name: "Soft Burgundy", hex: "#8C5766", why: "rich but not overpowering"),
        Swatch.new(name: "Muted Sage", hex: "#9CAF88", why: "balanced green, softened"),
        Swatch.new(name: "Warm Gray", hex: "#948C7E", why: "gentle neutral with a touch of warmth"),
        Swatch.new(name: "Dusty Blue", hex: "#8299AA", why: "a softened blue with balanced undertones"),
        Swatch.new(name: "Muted Rose", hex: "#B9858B", why: "a gentle warm-cool blend")
      ],
      neutrals: [
        Swatch.new(name: "Soft white", hex: "#F1EFEA", why: "Your light neutral. Gentler than optic white."),
        Swatch.new(name: "Soft charcoal", hex: "#4D5155", why: "Your dark neutral. Gives you depth without black's hard edge.")
      ],
      neutral_note: "Lean into soft white and soft charcoal. Black against white is too big a jump for blended coloring.",
      accent_colors: [
        Swatch.new(name: "Soft plum", hex: "#876A83", why: nil),
        Swatch.new(name: "Eucalyptus", hex: "#7F9788", why: nil),
        Swatch.new(name: "Muted berry", hex: "#A66D7C", why: nil),
        Swatch.new(name: "Clay", hex: "#B98269", why: nil)
      ],
      gold_metal_percentage: 50,
      lean_away: [
        Swatch.new(name: "Stark Black + White", hex: "#111111", why: "too much contrast for soft coloring", hexes: [ "#111111", "#FFFFFF" ]),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "overwhelms a muted, blended palette", hexes: [ "#39FF14", "#FF2E93", "#00E5FF" ]),
        Swatch.new(name: "Very Warm Orange", hex: "#D2601A", why: "too warm and too bold"),
        Swatch.new(name: "Icy Blue", hex: "#B7D3E0", why: "too cool and too stark")
      ]
    }
  }.freeze

  # Hand-written palettes for specific (undertone, contrast, eye_color)
  # combinations, richer than the generic buckets above. Checked first;
  # anyone whose exact three answers match gets this instead of the
  # generic bucket for their undertone/contrast pair.
  EYE_OVERRIDES = {
    [ "warm", "soft", "hazel" ] => {
      summary: "Warm-golden skin with hazel eyes: amber and gold near the pupil, brown-green on the outer ring. That means warm versions of every color work, and green plus gold are the two hues your eyes can echo.",
      lean_toward_intro: "Ranked. Olive first because it pulls the green out of your eyes.",
      lean_toward: [
        Swatch.new(name: "Olive / moss", hex: "#5E6B2F", why: "Echoes the green flecks in your eyes. Your strongest color."),
        Swatch.new(name: "Burgundy / wine", hex: "#6E1F2F", why: "Red sits opposite green on the wheel, so it makes hazel eyes pop."),
        Swatch.new(name: "Camel / rust", hex: "#B98B57", why: "Echoes the gold in your eyes and lifts golden skin."),
        Swatch.new(name: "Chocolate brown", hex: "#4A2C21", why: "Warm and deep."),
        Swatch.new(name: "Navy", hex: "#1F2A44", why: "Your best cool color. Pick ink navy over bright royal blue."),
        Swatch.new(name: "Forest green", hex: "#31502E", why: "Echoes the green in your eyes while staying warm."),
        Swatch.new(name: "Terracotta", hex: "#C08262", why: "Adds a softer warm accent than bright orange."),
        Swatch.new(name: "Deep teal", hex: "#245B56", why: "A rich cool-leaning shade that still works with golden skin.")
      ],
      neutrals: [
        Swatch.new(name: "Black", hex: "#141210", why: "Strong contrast, and it works with every color on your list."),
        Swatch.new(name: "Warm charcoal", hex: "#3B3733", why: "The gray that works for you.")
      ],
      neutral_note: "Lean into black and warm charcoal over white or cool gray. When you do go light, choose cream, not stark white.",
      color_theory: [
        [ "Keep every color warm-leaning.", "Olive, not gray-green. Wine, not blue-red. Navy with ink depth, not bright royal." ],
        [ "Use your eyes as the palette.", "They hold green, gold, and brown. Wear olive or camel to echo them, or burgundy to contrast the green." ],
        [ "Win the near-face zone first.", "The 6 inches around your face matter most. Put your best colors in the collar, knit, or tee, and let riskier colors sit low on the body or in shoes." ],
        [ "Go rich, not pale.", "Deep or saturated mid-to-dark tones read intentional on you. Pale-on-pale washes out. If you wear white, choose cream." ],
        [ "Let pattern break the rules.", "Plaid, stripes, and embroidery can carry a less flattering color because the pattern breaks it up. A solid lean-away color near your face is the real risk." ]
      ],
      accent_colors: [
        Swatch.new(name: "Marigold", hex: "#D9A628", why: nil),
        Swatch.new(name: "Brick", hex: "#A8452E", why: nil),
        Swatch.new(name: "Plum", hex: "#5C3350", why: nil),
        Swatch.new(name: "Copper", hex: "#B5651D", why: nil)
      ],
      gold_metal_percentage: 100,
      lean_away_intro: "These wash out or fight warm skin. They're fine low on the body, broken up by pattern, or set against black.",
      lean_away: [
        Swatch.new(name: "Pastels", hex: "#BFD9EE", why: "Baby blue, blush, mint. Low saturation washes out warm skin.", hexes: [ "#BFD9EE", "#F4C6D0", "#BFE5D3" ]),
        Swatch.new(name: "Muddy and dull", hex: "#8C8A6E", why: "Gray-olive, dusty mauve, taupe-gray. They read flat.", hexes: [ "#8C8A6E", "#B08D99", "#9A968E" ]),
        Swatch.new(name: "Neon", hex: "#39FF14", why: "Synthetic brights compete with your skin instead of complementing it.", hexes: [ "#39FF14", "#FF2E93", "#00E5FF" ]),
        Swatch.new(name: "Cool gray and icy white", hex: "#A9AFB5", why: "Ashy against warm undertones. Switch to warm charcoal or cream.", hexes: [ "#A9AFB5", "#8E97A0", "#F4F8FC" ])
      ]
    }
  }.freeze

  EYE_LINES = {
    "brown" => "Brown eyes work with almost anything you wear — warm golds and rich browns tend to deepen them.",
    "hazel" => "Hazel eyes shift with what's near them — olive and gold bring out the warm flecks, while deep green or brown brings out the cooler ring.",
    "green" => "Green eyes get a lift from burgundy, copper, and warm browns, which sit opposite green on the color wheel.",
    "blue" => "Blue eyes stand out most next to warm oranges, rust, and camel, or navy for a tonal look.",
    "gray" => "Gray eyes pick up whatever's nearby — richer jewel tones tend to bring out the most color.",
    "amber" => "Amber eyes pair naturally with warm greens, olive, and gold, which echo their own warmth."
  }.freeze

  UNDERTONE_RULES = {
    "warm" => [ "Keep every color warm-leaning.", "Choose olive over gray-green, wine over blue-red, and ink navy over bright royal." ],
    "cool" => [ "Keep every color cool-leaning.", "Choose blue-red over orange-red, blue-based greens over yellow-greens, and crisp tones over creamy ones." ],
    "neutral" => [ "Stay balanced.", "Pick colors that do not lean hard warm or hard cool: greige over camel or ash, and muted teal over bright turquoise." ]
  }.freeze

  EYE_RULE = [ "Use your eyes as the palette.", "Repeat one of your eye colors near your face (an echo), or pick its opposite on the color wheel (a contrast). Either one makes your eyes the focal point." ].freeze

  NEAR_FACE_RULE = [ "Win the near-face zone first.", "The 6 inches around your face matter most. Put your best colors in the collar, knit, or tee, and let riskier colors sit low on the body or in shoes." ].freeze

  CONTRAST_RULES = {
    "high" => [ "Go rich, not pale.", "Deep or saturated mid-to-dark tones hold their own against your natural contrast, and pale-on-pale washes you out." ],
    "soft" => [ "Stay tonal, not stark.", "Close shades of one color family look polished on you. Hard light-to-dark splits, like black against white, overpower soft coloring." ]
  }.freeze

  PATTERN_RULE = [ "Let pattern break the rules.", "Plaid, stripes, and embroidery can carry a less flattering color because the pattern breaks it up. A solid lean-away color near your face is the real risk." ].freeze

  attr_reader :profile

  def self.for(profile)
    new(profile)
  end

  def initialize(profile)
    @profile = profile
  end

  def bucket
    BUCKETS.fetch([ profile.undertone, profile.contrast ])
  end

  # Present only when this exact (undertone, contrast, eye_color) has a
  # hand-written override; nil for every other combination.
  def override
    EYE_OVERRIDES[[ profile.undertone, profile.contrast, profile.eye_color ]]
  end

  def summary
    override ? override[:summary] : bucket[:summary]
  end

  # Only set when an override provides one; the generic buckets don't
  # have a ranking rationale, only individual reasons per swatch.
  def lean_toward_intro
    override && override[:lean_toward_intro]
  end

  def lean_away_intro
    override && override[:lean_away_intro]
  end

  # nil for overrides that already fold the eye color into every
  # swatch's own reasoning, so the generic one-line summary would be
  # redundant.
  def eye_line
    return nil if override

    EYE_LINES[profile.eye_color]
  end

  def lean_toward
    override ? override[:lean_toward] : bucket[:lean_toward]
  end

  def accent_colors
    override ? override[:accent_colors] : bucket[:accent_colors]
  end

  def lean_away
    override ? override[:lean_away] : bucket[:lean_away]
  end

  # Two best neutrals for this person, with a short lean-into-these-over-those note.
  def neutrals
    (override || bucket).fetch(:neutrals)
  end

  def neutral_note
    (override || bucket).fetch(:neutral_note)
  end

  # Five plain styling rules. A hand-written override can supply its own;
  # everyone else gets rules built from their undertone and contrast.
  def color_theory_rules
    return override[:color_theory] if override && override[:color_theory]

    [
      UNDERTONE_RULES.fetch(profile.undertone),
      EYE_RULE,
      NEAR_FACE_RULE,
      CONTRAST_RULES.fetch(profile.contrast),
      PATTERN_RULE
    ]
  end

  def gold_metal_percentage
    (override || bucket).fetch(:gold_metal_percentage)
  end

  def metal_preference
    percentage = gold_metal_percentage
    return "Mixed metals: 50% gold, 50% silver" if percentage == 50

    percentage.positive? ? "Gold: 100%" : "Silver: 100%"
  end
end
