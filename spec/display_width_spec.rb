# frozen_string_literal: true

require_relative '../lib/unicode/display_width/string_ext'

describe 'Unicode::DisplayWidth.of' do
  describe '[east asian width]' do
    it 'returns 2 for F' do
      expect( '！'.display_width ).to eq 2
    end

    it 'returns 2 for W' do
      expect( '一'.display_width ).to eq 2
    end

    it 'returns 2 for W (which are currently unassigned)' do
      expect( "\u{3FFFD}".display_width ).to eq 2
    end

    it 'returns 1 for N' do
      expect( 'À'.display_width ).to eq 1
    end

    it 'returns 1 for Na' do
      expect( 'A'.display_width ).to eq 1
    end

    it 'returns 1 for H' do
      expect( '｡'.display_width ).to eq 1
    end

    it 'returns first argument of display_width for A' do
      expect( '·'.display_width(1) ).to eq 1
    end

    it 'returns first argument of display_width for A' do
      expect( '·'.display_width(2) ).to eq 2
    end

    it 'returns 1 for A if no argument given' do
      expect( '·'.display_width ).to eq 1
    end
  end

  describe '[zero width]' do
    it 'returns 0 for Mn chars' do
      expect( 'ֿ'.display_width ).to eq 0
    end

    it 'returns 0 for Me chars' do
      expect( '҈'.display_width ).to eq 0
    end

    it 'returns 0 for Cf chars' do
      expect( '​'.display_width ).to eq 0
    end

    it 'returns 0 for HANGUL JUNGSEONG chars' do
      expect( 'ᅠ'.display_width ).to eq 0
      expect( 'ힰ'.display_width ).to eq 0
    end

    it 'returns 0 for U+2060..U+206F' do
      expect( "\u{2060}".display_width ).to eq 0
    end

    it 'returns 0 for U+FFF0..U+FFF8' do
      expect( "\u{FFF0}".display_width ).to eq 0
    end

    it 'returns 0 for U+E0000..U+E0FFF' do
      expect( "\u{E0000}".display_width ).to eq 0
    end
  end

  describe '[special characters]' do
    it 'returns 0 for ␀' do
      expect( "\0".display_width ).to eq 0
    end

    it 'returns 0 for ␅' do
      expect( "\x05".display_width ).to eq 0
    end

    it 'returns 0 for ␇' do
      expect( "\a".display_width ).to eq 0
    end

    it 'returns -1 for ␈' do
      expect( "aaaa\b".display_width ).to eq 3
    end

    it 'returns -1 for ␈, but at least 0' do
      expect( "\b".display_width ).to eq 0
    end

    it 'returns 0 for ␊' do
      expect( "\n".display_width ).to eq 0
    end

    it 'returns 0 for ␋' do
      expect( "\v".display_width ).to eq 0
    end

    it 'returns 0 for ␌' do
      expect( "\f".display_width ).to eq 0
    end

    it 'returns 0 for ␍' do
      expect( "\r".display_width ).to eq 0
    end

    it 'returns 0 for ␎' do
      expect( "\x0E".display_width ).to eq 0
    end

    it 'returns 0 for ␏' do
      expect( "\x0F".display_width ).to eq 0
    end

    it 'returns 1 for other C0 characters' do
      expect( "\x01".display_width ).to eq 1
      expect( "\x02".display_width ).to eq 1
      expect( "\x03".display_width ).to eq 1
      expect( "\x04".display_width ).to eq 1
      expect( "\x06".display_width ).to eq 1
      expect( "\x10".display_width ).to eq 1
      expect( "\x11".display_width ).to eq 1
      expect( "\x12".display_width ).to eq 1
      expect( "\x13".display_width ).to eq 1
      expect( "\x14".display_width ).to eq 1
      expect( "\x15".display_width ).to eq 1
      expect( "\x16".display_width ).to eq 1
      expect( "\x17".display_width ).to eq 1
      expect( "\x18".display_width ).to eq 1
      expect( "\x19".display_width ).to eq 1
      expect( "\x1a".display_width ).to eq 1
      expect( "\x1b".display_width ).to eq 1
      expect( "\x1c".display_width ).to eq 1
      expect( "\x1d".display_width ).to eq 1
      expect( "\x1e".display_width ).to eq 1
      expect( "\x1f".display_width ).to eq 1
      expect( "\x7f".display_width ).to eq 1
    end

    it 'returns 1 for SOFT HYPHEN' do
      expect( "­".display_width ).to eq 1
    end

    it 'returns 2 for THREE-EM DASH' do
      expect( "⸺".display_width ).to eq 2
    end

    it 'returns 3 for THREE-EM DASH' do
      expect( "⸻".display_width ).to eq 3
    end
  end


  describe '[overwrite]' do
    it 'can be passed a 3rd parameter with overwrites' do
      expect( "\t".display_width(1, 0x09 => 12) ).to eq 12
    end
  end

  describe '[encoding]' do
    it 'works with non-utf8 Unicode encodings' do
      expect( 'À'.encode("UTF-16LE").display_width ).to eq 1
    end
  end

  describe '[emoji]' do
    it 'does not count modifiers and zjw sequences for valid emoji' do
      expect( "🤾🏽‍♀️".display_width(1, {}, emoji: true) ).to eq 2
    end

    it 'respects different ambiguous values' do
      expect( "🤾🏽‍♀️".display_width(2, {}, emoji: true) ).to eq 2
    end

    it 'works with flags' do
      expect( "🇵🇹".display_width(1, {}, emoji: true) ).to eq 2
    end
  end
end

describe "Config object based API" do
  let :display_width do
    Unicode::DisplayWidth.new(
      # ambiguous: 1,
      overwrite: { "A".ord => 100 },
      emoji: true
    )
  end

  it "will respect given overwrite option" do
    expect( display_width.of "A" ).to eq 100
  end

  it "will respect given emoji option" do
    expect( display_width.of "🤾🏽‍♀️" ).to eq 2
  end
end
