# Turns a StyleProfile's questionnaire answers into a color palette, using
# plain color-theory rules (undertone + contrast level) rather than AI.
# No API calls, no cost — this is a lookup table.
class StylePalette
  Swatch = Struct.new(:name, :hex, :why, keyword_init: true)

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
      supporting: [
        Swatch.new(name: "Ivory", hex: "#F5F0E1", why: nil),
        Swatch.new(name: "Warm Charcoal", hex: "#3A3530", why: nil),
        Swatch.new(name: "Chocolate Brown", hex: "#4A2C21", why: nil),
        Swatch.new(name: "Camel", hex: "#C19A6B", why: nil),
        Swatch.new(name: "Oatmeal", hex: "#D8C4A5", why: nil),
        Swatch.new(name: "Espresso", hex: "#38251D", why: nil),
        Swatch.new(name: "Olive", hex: "#5E6B2F", why: nil),
        Swatch.new(name: "Warm Navy", hex: "#26384A", why: nil)
      ],
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
      supporting: [
        Swatch.new(name: "Warm Ivory", hex: "#F2E9D8", why: nil),
        Swatch.new(name: "Soft Chocolate", hex: "#6B4A3A", why: nil),
        Swatch.new(name: "Warm Gray", hex: "#8A8172", why: nil),
        Swatch.new(name: "Sand", hex: "#D9C7A8", why: nil),
        Swatch.new(name: "Mushroom", hex: "#A99A87", why: nil),
        Swatch.new(name: "Soft Olive", hex: "#89865D", why: nil),
        Swatch.new(name: "Muted Clay", hex: "#B77F63", why: nil),
        Swatch.new(name: "Warm Stone", hex: "#C2B39B", why: nil)
      ],
      lean_away: [
        Swatch.new(name: "Stark Black + White", hex: "#111111", why: "too much contrast for your natural blend"),
        Swatch.new(name: "Icy Cool Blue", hex: "#B7D3E0", why: "fights the warm undertone"),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "overwhelms a low-contrast palette"),
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
      supporting: [
        Swatch.new(name: "Pure White", hex: "#FFFFFF", why: nil),
        Swatch.new(name: "Charcoal Gray", hex: "#36454F", why: nil),
        Swatch.new(name: "Navy", hex: "#14213D", why: nil),
        Swatch.new(name: "Silver", hex: "#C0C0C0", why: nil),
        Swatch.new(name: "Black", hex: "#111111", why: nil),
        Swatch.new(name: "Icy Blue", hex: "#DDEAF1", why: nil),
        Swatch.new(name: "Cool Plum", hex: "#56304A", why: nil),
        Swatch.new(name: "Steel Gray", hex: "#717C87", why: nil)
      ],
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
      supporting: [
        Swatch.new(name: "Soft White", hex: "#F1F3F4", why: nil),
        Swatch.new(name: "Cool Gray", hex: "#8B8D8E", why: nil),
        Swatch.new(name: "Soft Navy", hex: "#2C3E56", why: nil),
        Swatch.new(name: "Dove Gray", hex: "#A9A9AB", why: nil),
        Swatch.new(name: "Pale Lavender", hex: "#D5CBDD", why: nil),
        Swatch.new(name: "Misty Blue", hex: "#BBCBD8", why: nil),
        Swatch.new(name: "Cool Rose", hex: "#C89AA7", why: nil),
        Swatch.new(name: "Soft Slate", hex: "#737D85", why: nil)
      ],
      lean_away: [
        Swatch.new(name: "Bright Orange", hex: "#D2601A", why: "too warm and too bold"),
        Swatch.new(name: "Golden Yellow", hex: "#E8B923", why: "warm and saturated, fights soft cool coloring"),
        Swatch.new(name: "Warm Camel", hex: "#C19A6B", why: "too warm for cool undertones"),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "too much contrast for a soft palette")
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
      supporting: [
        Swatch.new(name: "White", hex: "#FFFFFF", why: nil),
        Swatch.new(name: "Black", hex: "#111111", why: nil),
        Swatch.new(name: "Mid Gray", hex: "#808080", why: nil),
        Swatch.new(name: "Stone", hex: "#B5AA9A", why: nil),
        Swatch.new(name: "Navy", hex: "#1F2A44", why: nil),
        Swatch.new(name: "Greige", hex: "#A99C8B", why: nil),
        Swatch.new(name: "Silver", hex: "#BFC3C7", why: nil),
        Swatch.new(name: "Deep Teal", hex: "#1B4B4B", why: nil)
      ],
      lean_away: [
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "too extreme in either temperature"),
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
      supporting: [
        Swatch.new(name: "Soft White", hex: "#F1EFEA", why: nil),
        Swatch.new(name: "Stone", hex: "#B5AA9A", why: nil),
        Swatch.new(name: "Taupe", hex: "#9B8F80", why: nil),
        Swatch.new(name: "Mid Gray", hex: "#8F8F8F", why: nil),
        Swatch.new(name: "Soft Navy", hex: "#39496B", why: nil),
        Swatch.new(name: "Muted Sage", hex: "#9CAF88", why: nil),
        Swatch.new(name: "Mushroom", hex: "#B2A296", why: nil),
        Swatch.new(name: "Dusty Rose", hex: "#C08497", why: nil)
      ],
      lean_away: [
        Swatch.new(name: "Stark Black + White", hex: "#111111", why: "too much contrast for soft coloring"),
        Swatch.new(name: "Neon Brights", hex: "#39FF14", why: "overwhelms a muted, blended palette"),
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
      supporting: [
        Swatch.new(name: "Warm cream", hex: "#F1E8D6", why: "Use instead of stark white."),
        Swatch.new(name: "Warm sand", hex: "#CDBB9B", why: "Only when it leans yellow, not gray."),
        Swatch.new(name: "Warm charcoal", hex: "#3B3733", why: "The gray that works for you."),
        Swatch.new(name: "Black", hex: "#141210", why: "Strong contrast and good with every best color."),
        Swatch.new(name: "Amber / mustard", hex: "#C68A1E", why: "Small doses: a bag, socks, a lens tint."),
        Swatch.new(name: "Gold", hex: "#C8A24A", why: "Hardware, chains, watch details."),
        Swatch.new(name: "Espresso", hex: "#38251D", why: "A softer dark neutral than pure black."),
        Swatch.new(name: "Warm olive", hex: "#74764A", why: "A quieter everyday neutral that echoes hazel eyes.")
      ],
      lean_away_intro: "These wash out or fight warm skin. They're fine low on the body, broken up by pattern, or set against black.",
      lean_away: [
        Swatch.new(name: "Pastels", hex: "#BFD9E8", why: "Baby blue, blush, mint. Low saturation washes out warm skin."),
        Swatch.new(name: "Muddy and dull", hex: "#8A8172", why: "Gray-olive, dusty mauve, taupe-gray. They read flat."),
        Swatch.new(name: "Neon", hex: "#39FF14", why: "Synthetic brights compete with your skin instead of complementing it."),
        Swatch.new(name: "Cool gray and icy white", hex: "#D9DEE2", why: "Ashy against warm undertones. Switch to warm charcoal or cream.")
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

  def supporting
    override ? override[:supporting] : bucket[:supporting]
  end

  def lean_away
    override ? override[:lean_away] : bucket[:lean_away]
  end
end
