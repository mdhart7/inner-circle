# Turns a StyleProfile's questionnaire answers into a color palette, using
# plain color-theory rules (undertone + contrast level) rather than AI.
# No API calls, no cost — this is a lookup table.
class StylePalette
  Swatch = Struct.new(:name, :hex, :why, keyword_init: true)
  ColorCombination = Struct.new(:primary, :accent, :why, keyword_init: true)
  OutfitCombination = Struct.new(:top, :bottom, :shoes, :why, keyword_init: true)

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
      accent_colors: [
        Swatch.new(name: "Marigold", hex: "#D49A24", why: nil),
        Swatch.new(name: "Paprika", hex: "#C94F2D", why: nil),
        Swatch.new(name: "Peacock teal", hex: "#167C78", why: nil),
        Swatch.new(name: "Coral", hex: "#E27655", why: nil),
        Swatch.new(name: "Jade", hex: "#33815B", why: nil),
        Swatch.new(name: "Copper", hex: "#B96B45", why: nil),
        Swatch.new(name: "Petrol blue", hex: "#356D7A", why: nil),
        Swatch.new(name: "Berry", hex: "#963D52", why: nil)
      ],
      color_combinations: [
        [ 0, 0, "Olive and marigold combine neighboring earthy hues with lively warmth." ],
        [ 1, 2, "Rust and peacock teal add complementary orange-blue-green contrast." ],
        [ 4, 4, "Burnt orange and jade create a vivid complementary pairing." ],
        [ 5, 6, "Forest green and petrol blue make a rich, close-toned combination." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Olive", hex: "#5E6B2F"), Swatch.new(name: "Camel", hex: "#B98B57"), Swatch.new(name: "Chocolate", hex: "#4A2C21"), "Warm earth tones stay cohesive, with chocolate grounding the look." ],
        [ Swatch.new(name: "Rust", hex: "#B7472A"), Swatch.new(name: "Warm navy", hex: "#26384A"), Swatch.new(name: "Oxblood", hex: "#54252C"), "Rust and navy balance warmth with cool depth; oxblood adds a rich finish." ],
        [ Swatch.new(name: "Burnt orange", hex: "#C1622D"), Swatch.new(name: "Forest green", hex: "#31502E"), Swatch.new(name: "Golden tan", hex: "#A87536"), "Orange and green create natural complementary contrast, warmed by tan." ],
        [ Swatch.new(name: "Deep teal", hex: "#1B5B55"), Swatch.new(name: "Burgundy", hex: "#722F37"), Swatch.new(name: "Cognac", hex: "#8A4B2D"), "Deep jewel tones balance each other while cognac brings warmth." ]
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
      accent_colors: [
        Swatch.new(name: "Soft coral", hex: "#D88469", why: nil),
        Swatch.new(name: "Terracotta", hex: "#C27658", why: nil),
        Swatch.new(name: "Saffron", hex: "#C89A3A", why: nil),
        Swatch.new(name: "Soft teal", hex: "#5F9990", why: nil),
        Swatch.new(name: "Apricot", hex: "#D99A72", why: nil),
        Swatch.new(name: "Moss", hex: "#77794C", why: nil),
        Swatch.new(name: "Dusty paprika", hex: "#A95843", why: nil),
        Swatch.new(name: "Muted turquoise", hex: "#4F8986", why: nil)
      ],
      color_combinations: [
        [ 0, 0, "Soft camel and coral share a gentle warmth without sharp contrast." ],
        [ 3, 3, "Terracotta and soft teal balance neighboring earthy warmth and coolness." ],
        [ 2, 5, "Muted olive and saffron create a soft complementary pairing." ],
        [ 5, 4, "Honey gold and apricot make a warm, blended tonal combination." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Soft camel", hex: "#C9A876"), Swatch.new(name: "Muted olive", hex: "#7C7A4E"), Swatch.new(name: "Warm cocoa", hex: "#76513C"), "Soft earth tones stay close in depth and warmth." ],
        [ Swatch.new(name: "Dusty terracotta", hex: "#C08262"), Swatch.new(name: "Warm taupe", hex: "#A68A6D"), Swatch.new(name: "Moss", hex: "#77794C"), "Muted neighboring hues create an easy, low-contrast outfit." ],
        [ Swatch.new(name: "Honey gold", hex: "#D6A552"), Swatch.new(name: "Soft chocolate", hex: "#6B4A3A"), Swatch.new(name: "Clay", hex: "#B77F63"), "Warm gold and chocolate create gentle depth with a clay accent." ],
        [ Swatch.new(name: "Warm sand", hex: "#D6BE9C"), Swatch.new(name: "Soft moss", hex: "#8C8B5A"), Swatch.new(name: "Muted peach", hex: "#D7A186"), "Sand and moss make a nature-inspired base, lifted by muted peach." ]
      ],
      gold_metal_percentage: 100,
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
      accent_colors: [
        Swatch.new(name: "Cobalt", hex: "#0047AB", why: nil),
        Swatch.new(name: "Royal purple", hex: "#5B2C83", why: nil),
        Swatch.new(name: "Fuchsia", hex: "#C71585", why: nil),
        Swatch.new(name: "Emerald", hex: "#065535", why: nil),
        Swatch.new(name: "Sapphire", hex: "#0F52BA", why: nil),
        Swatch.new(name: "Raspberry", hex: "#A3134D", why: nil),
        Swatch.new(name: "Blue violet", hex: "#4B3F9B", why: nil),
        Swatch.new(name: "Jade", hex: "#168A78", why: nil)
      ],
      color_combinations: [
        [ 1, 0, "Sapphire and cobalt create a crisp, tonal blue pairing." ],
        [ 2, 5, "Emerald and raspberry make a vivid complementary contrast." ],
        [ 4, 1, "Fuchsia and royal purple pair neighboring saturated jewel tones." ],
        [ 6, 7, "Royal purple and jade add bold contrast with cool clarity." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Sapphire", hex: "#0F52BA"), Swatch.new(name: "Charcoal", hex: "#1C1C1C"), Swatch.new(name: "Cobalt", hex: "#0047AB"), "Sapphire and charcoal make a crisp high-contrast base, finished with blue." ],
        [ Swatch.new(name: "Emerald", hex: "#065535"), Swatch.new(name: "Icy white", hex: "#F4F6F7"), Swatch.new(name: "Plum", hex: "#56304A"), "Emerald and icy white create clear contrast with a cool jewel-tone shoe." ],
        [ Swatch.new(name: "Fuchsia", hex: "#C71585"), Swatch.new(name: "Navy", hex: "#14213D"), Swatch.new(name: "Steel", hex: "#717C87"), "A vivid fuchsia top stands out against navy with a cool gray finish." ],
        [ Swatch.new(name: "Royal purple", hex: "#5B2C83"), Swatch.new(name: "Sapphire blue", hex: "#1756A9"), Swatch.new(name: "Raspberry", hex: "#A3134D"), "Saturated jewel tones create confident cool contrast." ]
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
      accent_colors: [
        Swatch.new(name: "Soft lavender", hex: "#B9A6CC", why: nil),
        Swatch.new(name: "Mauve", hex: "#A77D91", why: nil),
        Swatch.new(name: "Muted teal", hex: "#4C8C8A", why: nil),
        Swatch.new(name: "Dusty rose", hex: "#C08497", why: nil),
        Swatch.new(name: "Powder blue", hex: "#A9C4D9", why: nil),
        Swatch.new(name: "Eucalyptus", hex: "#78928B", why: nil),
        Swatch.new(name: "Periwinkle", hex: "#8998C7", why: nil),
        Swatch.new(name: "Orchid", hex: "#A47AA8", why: nil)
      ],
      color_combinations: [
        [ 0, 6, "Powder blue and soft lavender keep the look light and cool." ],
        [ 1, 2, "Dusty rose and muted teal balance soft complementary colors." ],
        [ 2, 1, "Soft lavender and mauve make a calm cool pairing." ],
        [ 4, 7, "Muted teal and orchid balance cool color with gentle contrast." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Powder blue", hex: "#A9C4D9"), Swatch.new(name: "Slate gray", hex: "#6E7A82"), Swatch.new(name: "Muted teal", hex: "#4C8C8A"), "Cool, softened colors create definition without harsh contrast." ],
        [ Swatch.new(name: "Dusty rose", hex: "#C08497"), Swatch.new(name: "Cool taupe", hex: "#9C9186"), Swatch.new(name: "Eucalyptus", hex: "#78928B"), "Muted rose and taupe blend gently, with eucalyptus adding a cool finish." ],
        [ Swatch.new(name: "Soft lavender", hex: "#B9A6CC"), Swatch.new(name: "Misty blue", hex: "#BBCBD8"), Swatch.new(name: "Mauve", hex: "#A77D91"), "Related cool tones make a calm, softly layered outfit." ],
        [ Swatch.new(name: "Muted berry", hex: "#A66D7C"), Swatch.new(name: "Soft navy", hex: "#2C3E56"), Swatch.new(name: "Cool rose", hex: "#C89AA7"), "Muted berry and navy balance a soft accent with a deeper cool base." ]
      ],
      gold_metal_percentage: 0,
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
      accent_colors: [
        Swatch.new(name: "Jade", hex: "#2E7D6B", why: nil),
        Swatch.new(name: "Plum", hex: "#713B59", why: nil),
        Swatch.new(name: "Burgundy", hex: "#722F37", why: nil),
        Swatch.new(name: "Balanced olive", hex: "#6B7047", why: nil),
        Swatch.new(name: "Deep teal", hex: "#1B4B4B", why: nil),
        Swatch.new(name: "Cranberry", hex: "#9E3B4F", why: nil),
        Swatch.new(name: "Blue spruce", hex: "#3D7774", why: nil),
        Swatch.new(name: "Aubergine", hex: "#583C59", why: nil)
      ],
      color_combinations: [
        [ 0, 6, "Navy and blue spruce make a tonal, balanced pairing." ],
        [ 2, 5, "Deep teal and cranberry create rich color contrast." ],
        [ 3, 1, "Burgundy and plum combine neighboring jewel tones." ],
        [ 4, 6, "Olive and blue spruce create a grounded, nature-inspired look." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Navy", hex: "#1F2A44"), Swatch.new(name: "Greige", hex: "#A99C8B"), Swatch.new(name: "Black", hex: "#111111"), "A strong dark and soft neutral create balanced definition." ],
        [ Swatch.new(name: "Deep teal", hex: "#1B4B4B"), Swatch.new(name: "Burgundy", hex: "#722F37"), Swatch.new(name: "Stone", hex: "#B5AA9A"), "Rich, balanced hues are lifted by a quiet natural accent." ],
        [ Swatch.new(name: "Balanced olive", hex: "#6B7047"), Swatch.new(name: "White", hex: "#FFFFFF"), Swatch.new(name: "Mid gray", hex: "#808080"), "Olive and white create clean contrast with a neutral gray finish." ],
        [ Swatch.new(name: "Jade", hex: "#2E7D6B"), Swatch.new(name: "Charcoal", hex: "#333333"), Swatch.new(name: "Silver", hex: "#BFC3C7"), "Jade and charcoal feel polished, with silver adding a cool light accent." ]
      ],
      gold_metal_percentage: 50,
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
      accent_colors: [
        Swatch.new(name: "Dusty teal", hex: "#5C8A89", why: nil),
        Swatch.new(name: "Muted sage", hex: "#9CAF88", why: nil),
        Swatch.new(name: "Soft burgundy", hex: "#8C5766", why: nil),
        Swatch.new(name: "Dusty blue", hex: "#8299AA", why: nil),
        Swatch.new(name: "Muted rose", hex: "#B9858B", why: nil),
        Swatch.new(name: "Soft plum", hex: "#876A83", why: nil),
        Swatch.new(name: "Eucalyptus", hex: "#7F9788", why: nil),
        Swatch.new(name: "Muted berry", hex: "#A66D7C", why: nil)
      ],
      color_combinations: [
        [ 0, 0, "Soft navy and dusty teal create a calm, close-toned pairing." ],
        [ 1, 2, "Dusty teal and muted sage blend nature-inspired colors." ],
        [ 3, 1, "Soft burgundy and muted sage balance muted warmth and green." ],
        [ 6, 6, "Dusty blue and eucalyptus create a gentle, cool-toned look." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Soft navy", hex: "#39496B"), Swatch.new(name: "Mushroom", hex: "#B2A296"), Swatch.new(name: "Dusty teal", hex: "#5C8A89"), "Soft, balanced shades add definition without a sharp contrast." ],
        [ Swatch.new(name: "Muted sage", hex: "#9CAF88"), Swatch.new(name: "Soft burgundy", hex: "#8C5766"), Swatch.new(name: "Warm gray", hex: "#948C7E"), "Muted complementary hues add color while staying blended." ],
        [ Swatch.new(name: "Dusty blue", hex: "#8299AA"), Swatch.new(name: "Taupe", hex: "#9B8F80"), Swatch.new(name: "Soft plum", hex: "#876A83"), "Soft cool and warm tones balance each other without overpowering." ],
        [ Swatch.new(name: "Muted rose", hex: "#B9858B"), Swatch.new(name: "Soft white", hex: "#F1EFEA"), Swatch.new(name: "Eucalyptus", hex: "#7F9788"), "Muted rose and eucalyptus add gentle contrast over a light base." ]
      ],
      gold_metal_percentage: 50,
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
      accent_colors: [
        Swatch.new(name: "Amber", hex: "#C68A1E", why: nil),
        Swatch.new(name: "Burgundy", hex: "#8C3445", why: nil),
        Swatch.new(name: "Peacock teal", hex: "#26766D", why: nil),
        Swatch.new(name: "Copper", hex: "#B96B45", why: nil),
        Swatch.new(name: "Deep olive", hex: "#74764A", why: nil),
        Swatch.new(name: "Muted coral", hex: "#CF765F", why: nil),
        Swatch.new(name: "Berry", hex: "#963D52", why: nil),
        Swatch.new(name: "Warm turquoise", hex: "#398982", why: nil)
      ],
      color_combinations: [
        [ 0, 4, "Olive and amber echo hazel's green and gold flecks." ],
        [ 1, 6, "Burgundy and berry layer warm reds for a rich tonal look." ],
        [ 2, 2, "Camel and peacock teal make a warm-cool complementary pairing." ],
        [ 5, 7, "Forest green and turquoise bring out the green in hazel eyes." ]
      ],
      outfit_combinations: [
        [ Swatch.new(name: "Olive", hex: "#5E6B2F"), Swatch.new(name: "Camel", hex: "#B98B57"), Swatch.new(name: "Chocolate", hex: "#4A2C21"), "Olive and camel echo hazel's green and gold flecks; chocolate grounds the look." ],
        [ Swatch.new(name: "Burgundy", hex: "#6E1F2F"), Swatch.new(name: "Navy", hex: "#1F2A44"), Swatch.new(name: "Warm sand", hex: "#CDBB9B"), "Burgundy and navy bring depth to hazel eyes, lifted by warm sand." ],
        [ Swatch.new(name: "Forest green", hex: "#31502E"), Swatch.new(name: "Terracotta", hex: "#C08262"), Swatch.new(name: "Espresso", hex: "#38251D"), "Green echoes the eye color; terracotta and espresso keep the outfit warm." ],
        [ Swatch.new(name: "Deep teal", hex: "#245B56"), Swatch.new(name: "Warm cream", hex: "#F1E8D6"), Swatch.new(name: "Cognac", hex: "#8A4B2D"), "Deep teal and warm cream create contrast with a golden-brown shoe." ]
      ],
      gold_metal_percentage: 100,
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

  def accent_colors
    override ? override[:accent_colors] : bucket[:accent_colors]
  end

  def lean_away
    override ? override[:lean_away] : bucket[:lean_away]
  end

  def color_combinations
    palette = override || bucket
    palette.fetch(:color_combinations).map do |primary_index, accent_index, why|
      ColorCombination.new(
        primary: palette.fetch(:lean_toward).fetch(primary_index),
        accent: palette.fetch(:accent_colors).fetch(accent_index),
        why: why
      )
    end
  end

  def outfit_combinations
    palette = override || bucket
    palette.fetch(:outfit_combinations).map do |top, bottom, shoes, why|
      OutfitCombination.new(top: top, bottom: bottom, shoes: shoes, why: why)
    end
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
